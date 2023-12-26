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
	for n in effect_container.get_children():
		effect_container.remove_child(n)
		n.queue_free()
	for status in statuses:
		var new_effect = preload("res://Scenes/effect.tscn").instantiate()
		new_effect.name = status.KeywordType.keys()[status.KeywordType.keys().find(status.type)]
		effect_container.add_child(new_effect)
		new_effect._add_timer(status.duration,status.value)
		new_effect._set_effect(status)
		
	var counter = 0
	print(effect_container.get_children())
	for effect in effect_container.get_children():
		if(len(effect_container.get_children())==1):
			effect.global_position = Vector2(effect_container.global_position.x, effect_container.global_position.y)
		elif(len(effect_container.get_children())%2==0):
			effect.global_position = Vector2((effect_container.global_position.x - (effect_offset * len(effect_container.get_children())/2)) + counter * effect_offset,effect_container.global_position.y)
		elif(len(effect_container.get_children())%2==1):
			effect.global_position = Vector2((effect_container.global_position.x - (effect_offset * len(effect_container.get_children())/2)) + counter * effect_offset,effect_container.global_position.y)
		counter += 1


func add_slot(slot):
	slots.append(slot)

func die():
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

func take_damage(damage:int):
	if !isdead:
		var total_armor:float=0.0
		var total_shred:int=0
		if FindKeyword(KeywordType.SHRED)!=null:
			total_shred+=FindKeyword(KeywordType.SHRED).value
			FindKeyword(KeywordType.SHRED).duration-=1
			if (FindKeyword(KeywordType.SHRED).duration<=0):
				FindKeyword(KeywordType.SHRED).value=0
		if FindKeyword(KeywordType.ARMOR)!=null:
			total_armor+=FindKeyword(KeywordType.ARMOR).value*0.1
			
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
				total_base_power+=FindKeyword(KeywordType.FINAL_POWER).value
			if FindKeyword(KeywordType.COIN_POWER)!=null:
				total_coin_power+=FindKeyword(KeywordType.COIN_POWER).value
		#damage calculations
			damage=card.base+total_base_power
			for i in range(0,card.count):
				damage=damage+(card.power + total_coin_power)*random.randi_range(0,1)
				target.take_damage(damage)
			
				for effect in card.keywords:
					if effect.trigger == i:
						target.take_status(effect)
						
		else: die()

func draw_card():
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
	
func regen_mana():
	var mana_num=mana_recovery
	var mana_keyword = FindKeyword(KeywordType.MANA)
	if mana_keyword!=null:
		mana_num+=mana_keyword.value
		mana_keyword.duration-=1
		if mana_keyword.duration<=0:
			DeleteKeyword(KeywordType.MANA)
	mana+=mana_num
	if (mana<0):mana=0
	if (mana>mana_max):mana=mana_max


func _enter_tree():
	stats=basestats.duplicate(true)
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


func _process(delta):
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
	if(id == self || type == "all"):
		if(type == "motion"): 
			_mouse_off()
		elif(type == "press"):
			_mouse_on_unpressed()
		
		
		
func _mouse_on():
	isMouseOn = true
	
func _mouse_off():
	isMouseOn = false

func _mouse_on_pressed():
	isMouseSelected = true
	shader.set_shader_parameter("width", 13)
	scale = baseScale * 1.2

func _mouse_on_unpressed():
	scale = baseScale
	shader.set_shader_parameter("width", 0.0)
	isMouseSelected = false
	
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


func get_type():
	return "Unit"
