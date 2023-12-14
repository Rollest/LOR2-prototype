extends Node

class_name GameDirector


signal selectedUnit(id,event_type)
signal unselect(id,event_type)


@export var units:Array[Unit]
@export var slots:Array[Slot]
@export var cards:Array[CardConfig]
@export var cardContainer:Node
@export var scene:Node
var rayCast2D: RayCast2D
var arcs: Arcs
var changedSelection: bool = false
var pressBodyId
var selectedBody


var RNG=RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	arcs = get_node("../ARCS")
	rayCast2D = get_node("../RayCast2D")
	rayCast2D.selected.connect(_listener_selected)
	rayCast2D.unselected.connect(_listener_unselected)
	selectedBody = get_node("../Pustishka")
	var tmp
	tmp=find_objects_of_type("Slot")
	for item in tmp:
		print(item)
		print(item.source)
		print("---------------------------------------------")
		item.reset_speed(item.source.speed)
	tmp=find_objects_of_type("Unit")
	for unit in tmp:
		units.append(unit)
		unit._on_hp_updated()
	tmp=find_objects_of_type("Slot")
	for slot in tmp:
		slots.append(slot)



func _listener_selected(id,type):
	if(id != pressBodyId):
		if(type == "motion"): 
			pass
		elif(type == "press"):
			pressBodyId = id
			pass
func _listener_unselected(id,type):
	if(id == pressBodyId && type == "press"):
		if (selectedBody != null && selectedBody.to_string().contains("Slot") && pressBodyId.to_string().contains("Card") && selectedBody.source.get_type() == "Ally"):
			print(instance_from_id(selectedBody.get_instance_id()).card)
			var slot = instance_from_id(selectedBody.get_instance_id())
			slot.change_card(instance_from_id(pressBodyId.get_instance_id()))
			print(instance_from_id(selectedBody.get_instance_id()).card)
			pass
		elif (selectedBody != null && selectedBody.to_string().contains("Slot") && pressBodyId.to_string().contains("EnemySlot")):
			print(instance_from_id(selectedBody.get_instance_id()).target)
			var enemy_slot = instance_from_id(pressBodyId.get_instance_id())
			enemy_slot.selected()
			instance_from_id(selectedBody.get_instance_id()).change_target(instance_from_id(pressBodyId.get_instance_id()).get_parent())
				
			print(instance_from_id(selectedBody.get_instance_id()).target)
			pass
		else:
			if(selectedBody.has_method("unselect")):
				selectedBody.unselect()
				pass
			
			selectedBody = pressBodyId
			
			if(selectedBody.to_string().contains("Pustishka")):
				emit_signal("unselect",id,"all")
				cardContainer.unselect()
				print("unselect")
				pass
			if(selectedBody.has_method("selected")):
				selectedBody.selected()
				pass
			elif(selectedBody.has_method("get_type") && selectedBody.get_type()=="Unit"): 
				cardContainer.display_cards(selectedBody.hand)
				pass
			if(selectedBody.has_method("get_type") && selectedBody.get_type()=="Slot"):
				cardContainer.unselect() 
				cardContainer.display_cards(selectedBody.source.hand)
				pass
		emit_signal("selectedUnit",id,type)





# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for slot in slots:
		if arcs.dict_slot_A_B.has(slot) and len(arcs.dict_slot_A_B[slot])>1:
			if slot.source is Enemy:
				slot.evil_change_target(slot.target)
			elif slot.source is Ally:
				slot.change_target(slot.target)
	pass

func Turn():
	print("new turn")
	
	for unit in units:
		unit.tempHp = int(unit.hp)
	
	for item in units:    #card draws
		print(item.name)
		print(item.statuses)
		
		if item.hand.size()<5:
			item.draw_card()
			
		var speedtmp=0
		for key in FindKeyword(KeywordType.SPEED,item):
			speedtmp+=key.value
		for slot in item.slots:
			slot.speed+=speedtmp
			slot.text.text=str(slot.speed)
				
		
		
	#units=CheckForDeadUnits(units)
	var combat_slots:Array[Slot]=[]
	for slot in slots:
		if !(!slot.target||!slot.card):
			combat_slots.append(slot)
			
	combat_slots.sort_custom(speedComparison)
	
	
	while true: #combat
		var flag=false;
		for i in range(0,combat_slots.size()-1):   # clash detection
			for j in range(i+1,combat_slots.size()):
				
				if (combat_slots[i].target==combat_slots[j].source && combat_slots[j].target==combat_slots[i].source):
					Clash(combat_slots[i],combat_slots[j])
					Discard(combat_slots[i])
					Discard(combat_slots[j])
					combat_slots.remove_at(j)
					combat_slots.remove_at(i)
					flag=true;
					break
			break
		if flag==false:   # onesided damage at the end
			for slot in combat_slots:
				var base=0
				var coin=0
				for key in FindKeyword(KeywordType.COIN_POWER,slot.source):
					coin+=key.value
				for key in FindKeyword(KeywordType.FINAL_POWER,slot.source):
					base+=key.value
				slot.target.hp-=AttackDmg(slot.card,base,coin)
				for key in slot.card.keywords:
					slot.target.statuses.append(key.duplicate(true))
					slot.target._update_effects()
				Discard(slot)
				print(slot.target.hp)
			break
		
	
	for item in units:    #status turn down
		for burn in FindKeyword(KeywordType.BURN,item): #process burns
			item.hp-=burn.value
		
		print(item," oiuytr")
		var removethemkeywords:Array[Keyword]
		print(item.statuses," poiuytrs")
		for i in item.statuses:
			print(i.type," ",i.duration)
			
		for keyword in item.statuses: #status decrement
			#print(keyword.type," asdfgh")
			if ((keyword.type!=1) and (keyword.type!=2)):
				keyword.duration-=1
			if keyword.duration<=0:
				removethemkeywords.append(keyword)
		for keyword in removethemkeywords:
			item.statuses.erase(keyword)
	

	for item in slots:
		item.reset_speed(item.source.speed)
	
	for unit in units:
		unit._update_effects()
	
	for ally in find_objects_of_type("Ally"):
		for slot in ally.slots:
			slot.target=null
			slot.card=null
			
	for unit in units:
		unit._on_hp_updated()
		if unit is Enemy:
			unit._play_random()
			print("random target set")


func FindKeyword(type:KeywordType,unit:Unit):
	var res: Array[Keyword]
	for keyword in unit.statuses:
		if keyword.type==type:
			res.append(keyword)
	return res

func Discard(slot:Slot):
	slot.source.hand.erase(slot.card)
	if arcs.dict_slot_A_B.has(slot):
		arcs.dict_slot_A_B.erase(slot)

func Clash(slot1:Slot,slot2:Slot):
	print("############################")
	print("clash "+str(slot1)+" "+str(slot2)) ############create card buffers to modify during clash

	var first = slot1.card.duplicate(true)
	#first.setvalues(slot1.card.count,slot1.card.power,slot1.card.base)
	var second = slot2.card.duplicate(true)
	#second.setvalues(slot2.card.count,slot2.card.power,slot2.card.base)

	while (first.count>0 && second.count>0):  #######calculate clash results
		var base1=0
		var coin1=0
		for key in FindKeyword(KeywordType.COIN_POWER,slot1.source):
			coin1+=key.value
		for key in FindKeyword(KeywordType.FINAL_POWER,slot1.source):
			base1+=key.value
			
		var a = AttackDmg(first,base1,coin1)
		
		var base2=0
		var coin2=0
		for key in FindKeyword(KeywordType.COIN_POWER,slot2.source):
			coin2+=key.value
		for key in FindKeyword(KeywordType.FINAL_POWER,slot2.source):
			base2+=key.value
		var b = AttackDmg(second,base2,coin2)
		print("inclash "+str(first.count) +" "+ str(a)+" "+str(second.count) +" "+ str(b))
		if a>b: 
			second.count-=1
		if b>a: 
			first.count-=1
	if first.count>0: 
		var base1=0
		var coin1=0
		for key in FindKeyword(KeywordType.COIN_POWER,slot1.source):
			coin1+=key.value
		for key in FindKeyword(KeywordType.FINAL_POWER,slot1.source):
			base1+=key.value
		slot1.target.hp-=AttackDmg(first,base1,coin1)
		for keyword in slot1.card.keywords:
			if first.count>=keyword.trigger:
				slot1.target.statuses.append(keyword.duplicate())
	else: 
		var base2=0
		var coin2=0
		for key in FindKeyword(KeywordType.COIN_POWER,slot2.source):
			coin2+=key.value
		for key in FindKeyword(KeywordType.FINAL_POWER,slot2.source):
			base2+=key.value
		slot2.target.hp-=AttackDmg(second,base2,coin2)
		for keyword in slot2.card.keywords:
			if second.count>=keyword.trigger:
				slot2.target.statuses.append(keyword.duplicate())

	print(slot1.target.hp)
	print(slot2.target.hp)

func AttackDmg(card:CardConfig,basePOW:int=0,coinPOW:int=0)->int:
	var res = card.base+basePOW
	for i in range (0,card.count):
		if (RNG.randi_range(0,1)==1):
			res+=card.power+coinPOW
	#print(res)
	return res

func CheckForDeadUnits(units:Array[Unit]):
	var res:Array[Unit]
	for unit in units:
		if unit.hp>0:
			res.append(unit)
		else: unit.queue_free()
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
		if (type == "Slot"):
			if (i is Slot):
				res.append(i)
		if (type == "Unit"):
			if (i is Unit):
				res.append(i)
		if (type == "Ally"):
			if (i is Ally):
				res.append(i)
		if (type == "Enemy"):
			if (i is Enemy):
				res.append(i)
	return res
	
func speedComparison(a, b):
	if a.speed>b.speed:
		return true
	return false


func _on_gui_next_turn():
	print("button pressed")
	Turn()


enum KeywordType{
	BURN,
	POISON,
	SHRED,
	FINAL_POWER,
	COIN_POWER,
	ARMOR,
	SPEED,
}


		
