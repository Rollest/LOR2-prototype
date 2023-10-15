extends Node3D

class_name Unit
@export var hp:int
@export var maxHP:int
@export var sp:int
@export var maxSP:int
@export var speed:Array[int]

@export var isSelected:bool

@export var slots:Array[Slot]

func add_slot(slot):
	slots.append(slot)

	# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


	# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

