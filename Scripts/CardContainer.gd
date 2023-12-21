extends Node

@export var cards:Array[CardConfig]
@export var template:Card
@export var scene:Node
@export var width:float
# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
static func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
	
func display_cards(cards:Array[CardConfig]):
	
	delete_children(self)
	var offset = width/cards.size()
	var c=0
	if true:
		for card in cards:
			var newcard = preload("res://Scenes/card2d.tscn")

			var new_node = newcard.instantiate()
			new_node.cardConfig=card
			new_node.position = Vector2(900+(offset*c),950)
			new_node.name="Card"+str(c)

			print(new_node.name)
			add_child(new_node)
			c+=1
	pass

func unselect():
	delete_children(self)
	pass

