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
var statuses:Array[Keyword]

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
	
func draw_card():
	print("drawing------------------------------------")
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

	# Called when the node enters the scene tree for the first time.
func _enter_tree():
	stats=UnitConfig.new()
	stats.values(basestats)
	print(stats)
	hp= stats.hp
	tempHp = hp
	maxHP=stats.maxHP
	sp=stats.sp
	maxSP=stats.maxSP
	speed=stats.speed
	deck=stats.deck
	hand=stats.hand
	mana=stats.mana
	statuses=stats.status
	
	
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
	
	shader = get_node("CollisionShape2D").get_node("Sprite2D").material
	gameDirector.selectedUnit.connect(_listener_selected)
	gameDirector.unselect.connect(_listener_unselected)
	#gameDirector.unselected.connect(_listener_unselected)
	#tween.tween_property(healthBar,"value",hp,0.4)
	print(self)
	print(slots)


	# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#healthBar.value = float(hp)/float(maxHP)*100
	#hpText.text = str(hp)
	pass
	
	
	
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
	#shader.set_shader_parameter("width", 2.4)
	scale = baseScale * 1.5 
	#print("mouse_on_press")

func _mouse_on_unpressed():
	#isMouseOn = true
	scale = baseScale
	#shader.set_shader_parameter("width", 0.0)
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
