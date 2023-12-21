extends Node

class_name GameDirector


signal selectedUnit(id,event_type)
signal unselect(id,event_type)


@export var units:Array[Unit]
@export var slots:Array[Slot]
@export var cards:Array[CardConfig]
@export var cardContainer:Node
@export var scene:Node
@export var combatConfig: CombatConfig
var endgameMenu: Node
var rayCast2D: RayCast2D
var arcs: Arcs
var changedSelection: bool = false
var pressBodyId
var selectedBody
var isCardSelected: bool = false
var global_config: Node
var sound: Node
var global_save: Node
var background: TextureRect


var RNG=RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	scene = get_node("/root/root")
	cardContainer = get_node("../CardContainer")
	arcs = get_node("../ARCS")
	rayCast2D = get_node("../RayCast2D")
	rayCast2D.selected.connect(_listener_selected)
	rayCast2D.unselected.connect(_listener_unselected)
	selectedBody = get_node("../Pustishka")
	endgameMenu = get_node("../CanvasLayer/EndgameMenu")
	global_config = get_node("/root/GlobalConfig")
	combatConfig = global_config.combatConfig
	background = get_node("../Background")
	sound = get_node("/root/Sound")
	global_save = get_node("/root/Save")
	background.texture = combatConfig.level_background
	sound.music_player.stream = sound.music_combat
	sound.music_player.play()
	
	_setup()
	
	await get_tree().process_frame
	
	var tmp
	tmp=find_objects_of_type("Slot")
	for item in tmp:
		#print(item)
		#print(item.source)
		#print("---------------------------------------------")
		item.reset_speed(item.source.speed)
	#tmp=find_objects_of_type("Unit")
	#for unit in tmp:
	#	units.append(unit)
	#	unit._on_hp_updated()
	tmp=find_objects_of_type("Slot")
	for slot in tmp:
		slots.append(slot)
		
	for enemy in find_objects_of_type("Enemy"):
		enemy._play_random()
	print("readyEnd")



func _listener_selected(id,type):
	if(id != pressBodyId):
		if(type == "motion"): 
			pass
		elif(type == "press"):
			pressBodyId = id
			pass
func _listener_unselected(id,type):
	if(id == pressBodyId && type == "press"):
		if (selectedBody != null && selectedBody.to_string().contains("Slot") && pressBodyId.to_string().contains("Card") && selectedBody.source.get_type() == "Ally" && selectedBody.source.mana>=pressBodyId.cardConfig.mana):
			#print(instance_from_id(selectedBody.get_instance_id()).card)
			var slot = instance_from_id(selectedBody.get_instance_id())
			slot.change_card(instance_from_id(pressBodyId.get_instance_id()))
			#print(instance_from_id(selectedBody.get_instance_id()).card)
			isCardSelected = true
			pass
		elif (selectedBody != null && selectedBody.to_string().contains("Slot") && pressBodyId.to_string().contains("EnemySlot") && isCardSelected == true):
			#print(instance_from_id(selectedBody.get_instance_id()).target)
			var enemy_slot = instance_from_id(pressBodyId.get_instance_id())
			enemy_slot.selected()
			instance_from_id(selectedBody.get_instance_id()).change_target(instance_from_id(pressBodyId.get_instance_id()).get_parent())
				
			#print(instance_from_id(selectedBody.get_instance_id()).target)
			isCardSelected = false
			pass
		else:
			if(selectedBody!=null && selectedBody.has_method("unselect")):
				selectedBody.unselect()
				isCardSelected = false
				pass
			
			selectedBody = pressBodyId
			
			if(selectedBody.to_string().contains("Pustishka")):
				emit_signal("unselect",id,"all")
				cardContainer.unselect()
				#print("unselect")
				pass
			if(selectedBody.has_method("selected")):
				selectedBody.selected()
				pass
			elif(selectedBody.has_method("get_type") && selectedBody.get_type()=="Ally"): 
				cardContainer.display_cards(selectedBody.hand)
				pass
			if(selectedBody.has_method("get_type") && selectedBody.get_type()=="Slot"):
				cardContainer.unselect()
				if(selectedBody.source is Ally):
					cardContainer.display_cards(selectedBody.source.hand)
				pass
			
		emit_signal("selectedUnit",id,type)





# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for slot in slots:
		if arcs.dict_slot_A_B.has(slot) and len(arcs.dict_slot_A_B[slot])>1:
			if slot != null && slot.source is Enemy:
				slot.evil_change_target(slot.target)
			elif slot != null && slot.source is Ally:
				slot.change_target(slot.target)
	pass

func Turn():
	#print("######################################")
	#print("new turn")
	#print("######################################\n")
	#setup
	CheckForDeadUnits(units)
	for unit in units:
		unit.tempHp = int(unit.hp)
	
	for item in units:    #card draws
		#print(item.name)
		#print(item.statuses)
		
		if item.hand.size()<5:
			item.draw_card()
		
	var combat_slots:Array[Slot]=[]
	for slot in slots:
		if !(!slot.target||!slot.card):
			slot.source.mana-=slot.card.mana
			combat_slots.append(slot)
			
	combat_slots.sort_custom(speedComparison)
	
	#combat
	while true: 
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
				#print (str(slot.source)+" attacks "+str(slot.target))
				if !slot.source.isdead:
					slot.source.deal_damage(slot.card,slot.target)
					Discard(slot)
				#print(slot.target.hp)
			break
		for unit in units:
			unit._update_effects()
		
	#prepare next turn
	for item in units:    #status turn down
		if FindKeyword(KeywordType.BURN,item)!=null:
			for burn in FindKeyword(KeywordType.BURN,item): #process burns
				item.hp-=burn.value
		
		#print(item," oiuytr")
		var removethemkeywords:Array[Keyword]
		#print(item.statuses," poiuytrs")
		#for i in item.statuses:
			#print(i.type," ",i.duration)
			
		for keyword in item.statuses: #status decrement
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
		unit.regen_mana()
	
	for ally in find_objects_of_type("Ally"):
		for slot in ally.slots:
			slot.target=null
			slot.card=null
			
	for unit in units:
		unit._on_hp_updated()
		if unit is Enemy:
			unit._play_random()
			#print("random target set")
	
	await get_tree().process_frame
	CheckForDeadUnits(units)
	print(units)
	await get_tree().process_frame
	if len(find_objects_of_type("Ally")) == 0:
		endgameMenu._lose()
	if len(find_objects_of_type("Enemy")) == 0:
		global_save.save[global_config.combatConfig.level] = 2
		var level = global_config.combatConfig.level
		var levelnum = level[len(level)-1]
		var nextlevel = "level" + str(int(levelnum)+1)
		if global_save.save[nextlevel] != null:
			global_save.save[nextlevel] = 1
		global_save._save_data_save()
		endgameMenu._win()




func _setup():
	print("setupStart " , units)
	
	arcs.dict_slot_A_B.clear()
	
	for unit in find_objects_of_type("Unit"):
		print(unit)
		get_parent().remove_child(unit)
		unit.queue_free()
		print(is_instance_valid(unit))
		
	await get_tree().process_frame
	var allies_spawns = get_node("../SpawnPoints/Allies").get_children()
	var enemies_spawns = get_node("../SpawnPoints/Enemies").get_children()
	
	var new_node = preload("res://Scenes/unit_2d.tscn")
	for i in range(0, len(combatConfig.allies)):
		var new_node2 = new_node.duplicate(true).instantiate()
		new_node2.basestats = combatConfig.allies[i].duplicate(true)
		new_node2.name = "Ally" + str(i+1)
		get_parent().add_child(new_node2)
		new_node2.global_position = allies_spawns[i].global_position
		print("Ally" , new_node2)
		
	for i in range(0, len(combatConfig.enemies)):
		var new_node2 = preload("res://Scenes/enemy_2d.tscn").instantiate()
		new_node2.basestats = combatConfig.enemies[i].duplicate(true)
		new_node2.name = "Enemy" + str(i+1)
		
		get_parent().add_child(new_node2)
		new_node2.global_position = enemies_spawns[i].global_position
		print("Enemy" , new_node2)
		
	units.clear()
	for unit in find_objects_of_type("Unit"):
		units.append(unit)
		unit._on_hp_updated()
	print(find_objects_of_type("Unit"))
	print("setupEnd " , units)



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
	#print("############################")
	#print(str(slot1.source) +" vs "+str(slot2.source))
	#print("clash "+str(slot1)+" "+str(slot2)) ############create card buffers to modify during clash

	var first = slot1.card.duplicate(true)
	#first.setvalues(slot1.card.count,slot1.card.power,slot1.card.base)
	var second = slot2.card.duplicate(true)
	#second.setvalues(slot2.card.count,slot2.card.power,slot2.card.base)

	while (first.count>0 && second.count>0):  #######calculate clash results
		var total_base_power1=0
		var total_coin_power1=0
		var damage1=0
		if FindKeyword(KeywordType.FINAL_POWER,slot1.source)!=null:
			for base in FindKeyword(KeywordType.FINAL_POWER,slot1.source):
				total_base_power1+=base.value
		if FindKeyword(KeywordType.COIN_POWER,slot1.source)!=null:
			for coin in FindKeyword(KeywordType.COIN_POWER,slot1.source):
				total_coin_power1+=coin.value
		damage1=first.base+total_base_power1
		for i in range(0,first.count):
			damage1=damage1+(first.power + total_coin_power1)*RNG.randi_range(0,1)
		
		var total_base_power2=0
		var total_coin_power2=0
		var damage2=0
		if FindKeyword(KeywordType.FINAL_POWER,slot2.source)!=null:
			for base in FindKeyword(KeywordType.FINAL_POWER,slot2.source):
				total_base_power2+=base.value
		if FindKeyword(KeywordType.COIN_POWER,slot2.source)!=null:
			for coin in FindKeyword(KeywordType.COIN_POWER,slot2.source):
				total_coin_power2+=coin.value
		damage2=second.base+total_base_power2
		for i in range(0,second.count):
			damage2=damage2+(second.power + total_coin_power2)*RNG.randi_range(0,1)

		if damage1>damage2: 
			second.count-=1
		if damage2>damage1: 
			first.count-=1
	if first.count>0: 
		if slot1.target!=null:
			slot1.source.deal_damage(first,slot1.target)
	else: 
		if slot2.target!=null:
			slot2.source.deal_damage(second,slot2.target)

	#print(slot1.target.hp)
	#print(slot2.target.hp)


func CheckForDeadUnits(units:Array[Unit]):
	var res:Array[Unit]
	for unit in units:
		if unit.hp>0:
			res.append(unit)
		else: 
			units.erase(unit)
			unit.die()
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
	#print("button pressed")
	sound.click_standart_player.play()
	Turn()


enum KeywordType{
	BURN,
	POISON,
	SHRED,
	FINAL_POWER,
	COIN_POWER,
	ARMOR,
	SPEED,
	MANA,
	DRAW,
}


		
