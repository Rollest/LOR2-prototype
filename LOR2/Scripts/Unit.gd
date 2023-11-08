extends Node2D

class_name Unit

@export var stats:UnitConfig
var healthBar:TextureProgressBar
var hpText:Label
@export var speed:Array[int]
var isSelected:bool
var slots:Array[Slot]
var gameDirector: GameDirector
var isMouseOn: bool = false
var isMouseSelected: bool = false

var baseScale:Vector2


func add_slot(slot):
	slots.append(slot)

	# Called when the node enters the scene tree for the first time.
func _ready():
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
	healthBar.value = float(stats.hp)/float(stats.maxHP)*100
	hpText.text = str(stats.hp)
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
