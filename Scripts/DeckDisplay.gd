extends Node

@export var cards:Array[CardConfig]
@export var scene:Node
@export var width:float
@export var columns:int
@export var hoffset:float
@export var voffset:float
# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.

func _enter_tree():
	scene=get_parent()
	#display_cards(cards)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
static func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
	
func display_cards(cards:Array[CardConfig]):
	
	delete_children(self)
	var c=0
	if true:
		for card in cards:
			var col= c%6
			var row= c/6
			var newcard = preload("res://Scenes/card2d.tscn")

			var new_node = newcard.instantiate()
			new_node.cardConfig=card.duplicate(true)
			new_node.position = Vector2(150+(hoffset*col),150+(row*voffset))
			new_node.name="Card"+str(c)
			new_node.gameDirector=get_parent().get_node("GameDirector")

			print(new_node.name)
			add_child(new_node)
			c+=1
	pass

func unselect():
	delete_children(self)
	pass


func _on_show_deck_pressed():
	pass # Replace with function body.


func _on_gui_stop_showing_deck():
	delete_children(self)
	self.visible=false
	pass # Replace with function body.
