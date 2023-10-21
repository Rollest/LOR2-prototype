extends Node2D

class_name Slot
	
@export var text:Label
@export var speed:int

@export var card:CardConfig
@export var source:Unit
@export var target:Unit


var RNG=RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	text=get_node("Speed")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text.text=str(speed)
	pass

func reset_speed(range:Array[int]):
	speed=RNG.randi_range(range[0],range[1])
	
func change_card(newcard:Card):
	card=newcard.cardConfig
	

