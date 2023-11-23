extends Node2D

class_name Unit

@export var basestats:UnitConfig
var stats:UnitConfig
var hp:int
var maxHP:int
var sp:int
var maxSP:int
var speed:Array[int]
var deck:Array[CardConfig]
var hand:Array[CardConfig]
var mana:int
var status:Array[Keyword]

var draw_pile:Array[CardConfig]

var healthBar:TextureProgressBar
var hpText:Label
var isSelected:bool
var slots:Array[Slot]
var gameDirector: GameDirector
var isMouseOn: bool = false
var isMouseSelected: bool = false

var baseScale:Vector2
var random:RandomNumberGenerator = RandomNumberGenerator.new()

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
	print ("draw pile size "+str(draw_pile.size()))
	print ("deck size"+str(deck.size()))
	print ("hand size"+str(hand.size()))
	print ("hand size in config"+str(stats.hand.size()))
	print ("hand size in base config"+str(basestats.hand.size()))

	# Called when the node enters the scene tree for the first time.
func _enter_tree():
	stats=UnitConfig.new()
	stats.values(basestats)
	print(stats)
	hp= stats.hp
	maxHP=stats.maxHP
	sp=stats.sp
	maxSP=stats.maxSP
	speed=stats.speed
	deck=stats.deck
	hand=stats.hand
	mana=stats.mana
	status=stats.status
	
	for card in deck:
		draw_pile.append(card)
	
	for slot in find_children("Slot"):
		#slot.source = self
		add_slot(slot)
	healthBar = get_node("CollisionShape2D/Sprite2D/TextureProgressBar")
	baseScale = transform.get_scale()
	hpText=healthBar.get_node("HP")
	gameDirector = get_node("../GameDirector")
	gameDirector.selectedUnit.connect(_listener_selected)
	gameDirector.unselect.connect(_listener_unselected)
	#gameDirector.unselected.connect(_listener_unselected)
	#tween.tween_property(healthBar,"value",hp,0.4)


	# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	healthBar.value = float(hp)/float(maxHP)*100
	hpText.text = str(hp)
	pass
	
	
	
func _listener_selected(id,type):
	#print(id,"  ",get_instance_id(), "  ", type)
	if(id == self):
		if(type == "motion"): 
			_mouse_on()
		elif(type == "press"):
			_mouse_on_pressed()
	elif(id != self):
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
	scale = baseScale * 1.5 
	#print("mouse_on_press")

func _mouse_on_unpressed():
	#isMouseOn = true
	scale = baseScale
	isMouseSelected = false
	#print("mouse_on_unpress")
	
func _on_hp_updated():
	pass

func get_type():
	return "Unit"
