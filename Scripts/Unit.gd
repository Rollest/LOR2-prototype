extends Node2D

class_name Unit

@export var basestats:UnitConfig
var stats:UnitConfig
var hp:int
var tempHp:int
var maxHP:int
var sp:int
var maxSP:int
var speed:Array[int]
var deck:Array[CardConfig]
var hand:Array[CardConfig]
var mana:int
var mana_max:int
var mana_recovery:int
var card_draw:int
var statuses:Array[Keyword]

var texture: CompressedTexture2D
var unit_name: String

var isdead:bool

var draw_pile:Array[CardConfig]

var healthBar:TextureProgressBar
var easedHealthBar:TextureProgressBar
var shader: ShaderMaterial
var tween: Tween
var hpText:Label
var damageText:Label
var isSelected:bool
var slots:Array[Slot]
var gameDirector: GameDirector
var isMouseOn: bool = false
var isMouseSelected: bool = false

var baseScale:Vector2
var random:RandomNumberGenerator = RandomNumberGenerator.new()

var effect_container: Node2D
@export var effect_offset: int = 100


func _update_effects():
	print("UPDATED EFFECTS")
	for n in effect_container.get_children():
		effect_container.remove_child(n)
		n.queue_free()
	print(statuses)
	for status in statuses:
		print(statuses)
		print("statusessss")
		if !effect_container.has_node(status.KeywordType.keys()[status.KeywordType.keys().find(status.type)]):
			var new_effect = preload("res://Scenes/effect.tscn").instantiate()
			new_effect.name = status.KeywordType.keys()[status.KeywordType.keys().find(status.type)]
			effect_container.add_child(new_effect)
			new_effect._add_timer(status.duration)
			new_effect._set_effect(status)
		else:
			var effect = effect_container.get_node(status.KeywordType.keys()[status.KeywordType.keys().find(status.type)])
			effect._add_timer(status.duration)
	var counter = 0
	for effect in effect_container.get_children():
		if(len(effect_container.get_children())%2==0):
			effect.global_position = Vector2((effect_container.global_position.x - (effect_offset * len(effect_container.get_children())/2)) + counter * effect_offset,effect_container.global_position.y)
		if(len(effect_container.get_children())==1):
			effect.global_position = Vector2(effect_container.global_position.x, effect_container.global_position.y)
		counter += 1


func add_slot(slot):
	slots.append(slot)

func die():
	print (str(self)+" is ded ---------------------------------------------------------------------------------------------------")
	isdead=true
	hp=0
	var new_node = preload("res://Scenes/grave.tscn").instantiate()
	if get_parent() != null:
		get_parent().add_child(new_node)
	new_node.global_position = global_position
	for slot in slots:
		gameDirector.slots.erase(slot)
		gameDirector.arcs.dict_slot_A_B.erase(slot)
	gameDirector.units.erase(self)
	if get_parent() != null:
		get_parent().remove_child(self)
	self.queue_free()
	
	#_on_hp_updated()

func take_damage(damage:int):
	if !isdead:
		print (str(self)+" took damage")
		var total_armor:float=0.0
		var total_shred:int=0
		if FindKeyword(KeywordType.SHRED)!=null:
			for shred in FindKeyword(KeywordType.SHRED):
				total_shred+=shred.value
				shred.duration-=1
				if (shred.duration<=0):
					shred.value=0
		if FindKeyword(KeywordType.ARMOR)!=null:
			for armor in FindKeyword(KeywordType.ARMOR):
				total_armor+=armor.value*0.1
			
		hp-=round((1.0-total_armor)*(damage+total_shred))
		if  hp<=0:
			hp=0
			die()
	
func take_status(base_status:Keyword):
	var status:Keyword = base_status.duplicate(true)
	var flag=false
	for keyword in statuses:
		if status.type==keyword.type:
			keyword.value+=status.value
			keyword.duration+=status.duration
			flag=true
	if !flag:
		statuses.append(status)
		

func deal_damage(cardStats:CardConfig,target:Unit):
	if !isdead:
		print (str(self)+" damaged "+str(target)+" with "+str(cardStats))
		var card = cardStats.duplicate(true)
		var total_base_power:int = 0
		var total_coin_power:int = 0
		var damage:int = 0
		#apply status to self on turn start
		for effect in card.keywords:
				if effect.trigger == -1:
					self.take_status(effect)
		#POISON DAMAGE
		var poison = FindKeyword(KeywordType.POISON)
		if poison!=null:
			hp-=poison.value
			for status in statuses:
				if status.type==KeywordType.POISON:
					status.duration-=1
		
		if hp>0:	
		#combine status effects
			if FindKeyword(KeywordType.FINAL_POWER)!=null:
				for base in FindKeyword(KeywordType.FINAL_POWER):
					total_base_power+=base.value
			if FindKeyword(KeywordType.COIN_POWER)!=null:
				for coin in FindKeyword(KeywordType.COIN_POWER):
					total_coin_power+=coin.value
		#damage calculations
			damage=card.base+total_base_power
			for i in range(0,card.count):
				damage=damage+(card.power + total_coin_power)*random.randi_range(0,1)
				target.take_damage(damage)
			
				for effect in card.keywords:
					if effect.trigger == i+1:
						target.take_status(effect)
						
		else: die()

func draw_card():
	print("drawing------------------------------------")
	var draw_num=card_draw
	var draw_keyword = FindKeyword(KeywordType.DRAW)
	if draw_keyword!=null:
		draw_num+=draw_keyword.value
		draw_keyword.duration-=1
		if draw_keyword.duration<=0:
			DeleteKeyword(KeywordType.DRAW)
	
	for i in range (0,draw_num)	:
		if draw_pile.size()>0:
			var index:int = random.randi_range(0,draw_pile.size()-1)
			hand.append(draw_pile[index])
			draw_pile.pop_at(index)
		else:
			for card in deck:
				draw_pile.append(card)
			var index:int = random.randi_range(0,draw_pile.size()-1)
			hand.append(draw_pile[index])
			draw_pile.pop_at(index)
	
	print ("getting mana-----------------------------------")
	var mana_num=mana_recovery
	var mana_keyword = FindKeyword(KeywordType.MANA)
	if mana_keyword!=null:
		mana_num+=draw_keyword.value
		mana_keyword.duration-=1
		if mana_keyword.duration<=0:
			DeleteKeyword(KeywordType.MANA)
	mana+=mana_num
	if (mana<0):mana=0
	if (mana>mana_max):mana=mana_max

	# Called when the node enters the scene tree for the first time.
func _enter_tree():
	stats=basestats.duplicate(true)
	print(stats)
	hp= stats.hp
	tempHp = hp
	maxHP=stats.maxHP
	sp=stats.sp
	maxSP=stats.maxSP
	speed=stats.speed
	deck=stats.deck
	hand=stats.hand
	mana_max=stats.mana_max
	mana=mana_max
	mana_recovery=stats.mana_recovery
	card_draw=stats.card_draw
	statuses=stats.status
	texture=stats.texture
	unit_name=stats.unit_name
	isdead=false
	
	
	for card in deck:
		draw_pile.append(card)
	
	for slot in find_children("Slot"):
		#slot.source = self
		add_slot(slot)
	healthBar = get_node("CollisionShape2D/Sprite2D/ProgressBar")
	easedHealthBar = get_node("CollisionShape2D/Sprite2D/EasedProgressBar")
	baseScale = transform.get_scale()
	hpText=healthBar.get_node("HP")
	damageText = healthBar.get_node("Damage")
	gameDirector = get_node("../GameDirector")
	effect_container = get_node("EffectContainer")
	shader = preload("res://Resourses/shaders/units_shader.tres").duplicate(true)
	get_node("CollisionShape2D").get_node("Sprite2D").material = shader
	get_node("CollisionShape2D").get_node("Sprite2D").texture = texture
	gameDirector.selectedUnit.connect(_listener_selected)
	gameDirector.unselect.connect(_listener_unselected)
	#gameDirector.unselected.connect(_listener_unselected)
	#tween.tween_property(healthBar,"value",hp,0.4)
	print(self)
	print(slots)


	# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#healthBar.value = float(hp)/float(maxHP)*100
	if hp <=0:
		await die()
	pass
	
func FindKeyword(type:KeywordType):
	var res: Keyword
	for keyword in self.statuses:
		if keyword.type==type:
			res = keyword
	return res

func DeleteKeyword(type:KeywordType):
	var temp=null
	for i in range(0,statuses.size()):
		if statuses[i].type==type:
			temp=i
			break
	if temp!=null:
		statuses.remove_at(temp)
			

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
	
func _listener_selected(id,type):
	#print(id,"  ",get_instance_id(), "  ", type)
	if(id == self):
		if(type == "motion"): 
			_mouse_on()
		elif(type == "press"):
			_mouse_on_pressed()
	elif(id in get_children()):
		if(type == "motion"): 
			_mouse_on()
		elif(type == "press"):
			_mouse_on_pressed()
	else:
		if(type == "motion"): 
			_mouse_off()
		elif(type == "press"):
			_mouse_on_unpressed()
func _listener_unselected(id,type):
	#print(id,"  ",cardBody2D.get_instance_id())
	if(id == self || type == "all"):
		if(type == "motion"): 
			_mouse_off()
		elif(type == "press"):
			_mouse_on_unpressed()
		
		
		
func _mouse_on():
	isMouseOn = true
	#print("mouse_on")
	
func _mouse_off():
	isMouseOn = false
	#print("mouse_off")

func _mouse_on_pressed():
	#isMouseOn = true
	isMouseSelected = true
	shader.set_shader_parameter("width", 13)
	scale = baseScale * 1.2
	#print("mouse_on_press")

func _mouse_on_unpressed():
	#isMouseOn = true
	scale = baseScale
	shader.set_shader_parameter("width", 0.0)
	isMouseSelected = false
	#print("mouse_on_unpress")
	
func _on_hp_updated():
	healthBar.value = float(hp)/float(maxHP)*100
	hpText.text = str(hp)
	tween = create_tween()
	tween.tween_property(easedHealthBar, "value", healthBar.value, 1.0)
	if hp != tempHp:
		damageText.text = str(hp - tempHp)
		damageText.set("theme_override_colors/font_color", Color(255,0,0,255))
		damageText.set("theme_override_colors/font_shadow_color", Color(0,0,0,255))
		tween.parallel().tween_property(damageText, "theme_override_colors/font_color", Color(255,0,0,0), 1.5)
		tween.parallel().tween_property(damageText, "theme_override_colors/font_shadow_color", Color(0,0,0,0), 1.5)
	else:
		damageText.set("theme_override_colors/font_color", Color(255,0,0,0))
		damageText.set("theme_override_colors/font_shadow_color", Color(0,0,0,0))
	
	pass

func get_type():
	return "Unit"
