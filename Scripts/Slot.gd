extends Node2D

class_name Slot
	
var text:Label
@export var speed:int

@export var card:CardConfig
@export var source:Unit
@export var target:Unit
var isSelected:bool = false
var baseScale
var gameDirector: GameDirector
var arcs: Arcs


var RNG=RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	gameDirector = get_node("../../GameDirector")
	text=get_node("Speed")
	source = get_parent()
	arcs = get_node("../../ARCS")
	baseScale = transform.get_scale()
	#gameDirector.selectedUnit.connect(selected)
	gameDirector.unselect.connect(unselect)
	if(target && target.get_node("Slot")):
		arcs.dict_slot_A_B[self] = [global_position, target.get_node("Slot").global_position, false]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text.text=str(speed)
	source=get_parent()
	pass

func reset_speed(range:Array[int]):
	speed=RNG.randi_range(range[0],range[1])
	pass
	
func change_card(newcard:Card):
	card=newcard.cardConfig
	arcs.dict_slot_A_B[self] = [global_position]
	pass

func change_target(newTarget):
	if newTarget == null:
		target = null
	else:
		target = newTarget
	if(target != null):
		arcs.dict_slot_A_B[self] = [global_position, target.get_node("EnemySlot").global_position,false]
		#print(arcs.dict_slot_A_B)
	pass

func evil_change_target(newTarget):
	if newTarget == null:
		target = null
	else:
		target = newTarget
	if(target != null):
		arcs.dict_slot_A_B[self] = [global_position, target.get_node("Slot").global_position,false]
		#print(arcs.dict_slot_A_B)
	pass
	
func selected():
	isSelected = !isSelected
	print("SELECTED SLOT")
	if(isSelected):
		scale = baseScale * 1.2
		
	else:
		scale = baseScale
		
func unselect(id = 0, type = " "):
	isSelected = false
	print("UNSELECTED SLOT")
	scale = baseScale
	if arcs.dict_slot_A_B.has(self) && len(arcs.dict_slot_A_B.get(self))<2:
		arcs.dict_slot_A_B.erase(self)
	pass
		
func get_type():
	return "Slot"
