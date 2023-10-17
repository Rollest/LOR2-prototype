extends Node2D
class_name Card

@export var countText:Label
@export var powerText:Label
@export var baseText:Label
@export var cardConfig : CardConfig
# Called when the node enters the scene tree for the first time.
func _ready():
	countText.text = str(cardConfig.count)
	powerText.text = str(cardConfig.power)
	baseText.text = str(cardConfig.base)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_card_input_event(camera, event, position, normal, shape_idx):
	pass # Replace with function body.
