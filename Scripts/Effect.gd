extends Node2D

class_name Effect


@export var timer: int
@export var sprite: Sprite2D
@export var label: Label
@export var powerlabel:Label

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite = get_node("Sprite2D")
	label = get_node("Label")
	powerlabel = get_node("PowerLabel")
	label.text = str(0)
	powerlabel.text=str(0)
	if get_parent() is Card:
		label.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _add_timer(time: int,power:int):
	label.text = str(int(label.text) + time)
	powerlabel.text = str(int(powerlabel.text) + power)
	
func _set_effect(keyword: Keyword):
	match keyword.type:
		keyword.KeywordType.BURN:
			sprite.texture = load("res://Assets/Effects/BURN.png")
		keyword.KeywordType.POISON:
			sprite.texture = load("res://Assets/Effects/POIZON.png")
		keyword.KeywordType.SHRED:
			sprite.texture = load("res://Assets/Effects/SHRED.png")
		keyword.KeywordType.FINAL_POWER:
			if keyword.value>0:
				sprite.texture = load("res://Assets/Effects/POWER_PLUS.PNG")
			else : sprite.texture = load("res://Assets/Effects/POWER_DOWN.PNG")
		keyword.KeywordType.COIN_POWER:
			if keyword.value>0:
				sprite.texture = load("res://Assets/Effects/COIN_UP.PNG")
			else : sprite.texture = load("res://Assets/Effects/COIN_DOWN.PNG")
		keyword.KeywordType.ARMOR:
			sprite.texture = load("res://Assets/Effects/ARMOR.png")
		keyword.KeywordType.SPEED:
			if keyword.value>0:
				sprite.texture = load("res://Assets/Effects/SPEED_UP.PNG")
			else : sprite.texture = load("res://Assets/Effects/SPEED_DOWN.PNG")
			sprite.texture = load("res://Assets/Effects/white1.png")
		#keyword.KeywordType.MANA:
		#	sprite.texture = load("res://Assets/Effects/white1.png")
		#keyword.KeywordType.DRAW:
		#	sprite.texture = load("res://Assets/Effects/white1.png")
		
		
