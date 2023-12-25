extends CanvasLayer

# Notifies `Main` node that the button has been pressed
signal next_turn
signal show_deck()
signal stop_showing_deck
var unit:Unit
var unit_deck:Array[CardConfig]
var clicks:int=2
var sound: Node

func _ready():
	sound = get_node("/root/Sound")

func _on_turn_button_pressed():
	emit_signal("next_turn")


func _on_show_deck_pressed():
	sound.click_standart_player.play()
	find_child("DeckDisplay").visible=true
	find_child("DarkOverlay").visible=true
	if unit_deck!=null:
		find_child("DeckDisplay").display_cards(unit_deck)
	pass
	

func _on_unit_unselected():
	visible=false


func _on_game_director_selected_unit(id, event_type):
	if ((id.has_method("get_type")) and (id.get_type()=="Ally")):
		print(id.deck)
		unit=id
		unit_deck=id.deck
		emit_signal("show_deck")


func _on_game_director_unselect(id, event_type):
	clicks-=1
	if clicks==0:
		clicks=2
		find_child("DarkOverlay").visible=false
		find_child("DeckDisplay").visible=false
		find_child("TurnButton").visible=true
		emit_signal("stop_showing_deck")
