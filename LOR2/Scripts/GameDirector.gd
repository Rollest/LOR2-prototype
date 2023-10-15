extends Node

class_name GameDirector

@export var units:Array[Unit]
@export var slots:Array[Slot]
@export var cards:Array[Card]
@export var scene:Node

var RNG=RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	var tmp
	tmp=find_objects_of_type(Slot)
	for item in tmp:
		item.reset_speed(item.source.speed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func Turn():
	print("new turn")
	var tmp
	tmp=find_objects_of_type(Slot)
	for item in tmp:
		slots.append(item)
		
	for item in slots:
		if (!item.target):
			slots.erase(item)
			
	slots.sort_custom(speedComparison)
	for slot in slots:
		slot.target.source.hp-=AttackDmg(slot.card)
	
	var tmp2
	tmp2=find_objects_of_type(Slot)
	for item in tmp2:
		item.reset_speed(item.source.speedRange)
	

func AttackDmg(card:Card)->int:
	var res = card.cardConfig.Base
	for i in range (0,card.cardConfig.Count):
		if (RNG.randi_range(0,1)==1):
			res+=card.cardConfig.Power
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
