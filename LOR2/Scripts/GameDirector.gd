extends Node

class_name GameDirector

signal selectedUnit(id,event_type)


@export var units:Array[Unit]
@export var slots:Array[Slot]
@export var cards:Array[CardConfig]
@export var scene:Node
var rayCast2D: RayCast2D
var changedSelection: bool = false
var pressBodyId
var selectedBody


var RNG=RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	rayCast2D = get_node("../RayCast2D")
	rayCast2D.selected.connect(_listener_selected)
	rayCast2D.unselected.connect(_listener_unselected)
	selectedBody = get_node("../CharacterBody2D")
	var tmp
	tmp=find_objects_of_type(Slot)
	for item in tmp:
		item.reset_speed(item.source.speed)



func _listener_selected(id,type):
	#print(id,"  ",cardBody2D.get_instance_id())
	if(id != pressBodyId):
		if(type == "motion"): 
			#selectBodyId = id
			pass
		elif(type == "press"):
			pressBodyId = id
func _listener_unselected(id,type):
	#print(id,"  ",cardBody2D.get_instance_id())
	if(id == pressBodyId && type == "press"):
		if (selectedBody != null && selectedBody.to_string().contains("Slot") && pressBodyId.to_string().contains("Card")):
			print(instance_from_id(selectedBody.get_instance_id()).card)
			instance_from_id(selectedBody.get_instance_id()).change_card(instance_from_id(pressBodyId.get_instance_id()))
			print(instance_from_id(selectedBody.get_instance_id()).card)
		elif (selectedBody != null && selectedBody.to_string().contains("Slot") && pressBodyId.to_string().contains("EnemySlot")):
			print(instance_from_id(selectedBody.get_instance_id()).target)
			instance_from_id(selectedBody.get_instance_id()).target = instance_from_id(pressBodyId.get_instance_id()).get_parent()
			print(instance_from_id(selectedBody.get_instance_id()).target)
		else:
			selectedBody = pressBodyId
		emit_signal("selectedUnit",id,type)





# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func Turn():
	print("new turn")
	var tmp
	tmp=find_objects_of_type(Slot)
	for item in tmp:
		if(item not in slots):
			slots.append(item)
		
	for item in slots:
		if (!item.target):
			slots.erase(item)
			
	slots.sort_custom(speedComparison)
	for slot in slots:
		#print(slot.card, "SLOT _______________________________________________________________")
		slot.target.hp-=AttackDmg(slot.card)
		print(slot.target.hp)
	
	var tmp2
	tmp2=find_objects_of_type(Slot)
	for item in tmp2:
		item.reset_speed(item.source.speed)
	

func AttackDmg(card:CardConfig)->int:
	var res = card.base
	for i in range (0,card.count):
		if (RNG.randi_range(0,1)==1):
			res+=card.power
	#print(res)
	return res

func get_all_children(node)->Array:
	var nodes : Array = []
	for N in node.get_children():
		if N.get_child_count() > 0:
			nodes.append(N)
			nodes.append_array(get_all_children(N))
		else:
			nodes.append(N)
	return nodes

func find_objects_of_type(type)->Array:
	var tmp:Array
	var res:Array
	tmp=get_all_children(scene)
	for i in tmp:
		if (i is Slot):
			res.append(i)
	return res
	
func speedComparison(a, b):
	if a.speed>b.speed:
		return true
	return false


func _on_gui_next_turn():
	print("button pressed")
	Turn()
