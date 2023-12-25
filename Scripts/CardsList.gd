extends Control

var list_of_cards: Array[CardConfig]
var grid_container: Node
var new_card = preload("res://Scenes/card_combat_menu.tscn")

func _ready():
	visible = false
	list_of_cards = get_node("/root/GlobalConfig").list_cards
	grid_container = get_node("Panel/ScrollContainer/MarginContainer/GridContainerCardsList")
	for item in grid_container.get_children():
		remove_child(item)
		item.queue_free()
	for config in list_of_cards:
		var new_node = new_card.duplicate(true).instantiate()
		new_node.cardConfig = config
		grid_container.add_child(new_node)


func _on_close_button_pressed():
	visible = false
