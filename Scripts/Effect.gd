extends Node2D

class_name Effect


@export var timer: int
@export var sprite: Sprite2D
@export var label: Label

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite = get_node("Sprite2D")
	label = get_node("Label")
	label.text = str(0)
	if get_parent() is Card:
		label.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _add_timer(time: int):
	label.text = str(int(label.text) + time)
	
func _set_effect(keyword: Keyword):
	match keyword.type:
		keyword.KeywordType.BURN:
			sprite.texture = load("res://Assets/Effects/BURN.png")
		keyword.KeywordType.POISON:
			sprite.texture = load("res://Assets/Effects/POIZON.png")
		keyword.KeywordType.SHRED:
			sprite.texture = load("res://Assets/Effects/SHRED.png")
		keyword.KeywordType.FINAL_POWER:
			sprite.texture = load("res://Assets/Effects/white1.png")
		keyword.KeywordType.COIN_POWER:
			sprite.texture = load("res://Assets/Effects/white1.png")
		keyword.KeywordType.ARMOR:
			sprite.texture = load("res://Assets/Effects/ARMOR.png")
		keyword.KeywordType.SPEED:
			sprite.texture = load("res://Assets/Effects/white1.png")
		
