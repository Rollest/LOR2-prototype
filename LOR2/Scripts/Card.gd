extends Node2D
class_name Card

@export var countText:Label
@export var powerText:Label
@export var baseText:Label
@export var cardConfig : CardConfig
var isMouseOn: bool = false
var isMouseOnPress: bool = false
var anotherNodeIsMoving:bool = false
var baseScale:Vector2
var rayCast2D: RayCast2D
var cardBody2D:CharacterBody2D
# Called when the node enters the scene tree for the first time.
func _ready():
	countText.text = str(cardConfig.count)
	powerText.text = str(cardConfig.power)
	baseText.text = str(cardConfig.base)
	baseScale = transform.get_scale()
	cardBody2D = get_node("Sprite3D/CardCharachterBody2D")
	rayCast2D = get_node("../RayCast2D")
	print(rayCast2D)
	rayCast2D.selected.connect(_listener_selected)
	rayCast2D.unselected.connect(_listener_unselected)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(isMouseOn)
	#print(isMouseOnPress)
	if (isMouseOn):
		scale = baseScale * 1.5
		if(isMouseOnPress):
			position = get_viewport().get_mouse_position()
	else:
		if (transform.get_scale()!=baseScale): scale = baseScale
	
	


func _listener_selected(id,type):
	#print(id,"  ",cardBody2D.get_instance_id())
	if(id == cardBody2D.get_instance_id() && !anotherNodeIsMoving):
		if(type == "motion"): 
			_mouse_on()
		elif(type == "press"):
			_mouse_on_pressed()
	elif(id != cardBody2D.get_instance_id() && type == "press"):
		anotherNodeIsMoving = true
func _listener_unselected(id,type):
	#print(id,"  ",cardBody2D.get_instance_id())
	if(id == cardBody2D.get_instance_id()):
		if(type == "motion" && !isMouseOnPress): 
			_mouse_off()
		elif(type == "press"):
			_mouse_on_unpressed()
	elif(id != cardBody2D.get_instance_id() && type == "press"):
		anotherNodeIsMoving = false



func _mouse_on():
	isMouseOn = true
	#print("mouse_on")
	
func _mouse_off():
	isMouseOn = false
	#print("mouse_off")

func _mouse_on_pressed():
	#isMouseOn = true
	isMouseOnPress = true
	#print("mouse_on_press")

func _mouse_on_unpressed():
	#isMouseOn = true
	isMouseOnPress = false
	#print("mouse_on_unpress")
