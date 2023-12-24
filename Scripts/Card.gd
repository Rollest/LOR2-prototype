extends Node2D
class_name Card

@export var countText:Label
@export var powerText:Label
@export var baseText:Label
@export var keyText:Label
@export var manaText:Label
@export var cardConfig : CardConfig
var isMouseOn: bool = false
var isMouseOnPress: bool = false
var anotherNodeIsMoving:bool = false
var baseScale:Vector2
var scaleMultiplier: float
var baseZ: int
var rayCast2D: RayCast2D
var gameDirector: GameDirector


# Called when the node enters the scene tree for the first time.
func _ready():
	countText.text = str(cardConfig.count)
	powerText.text = str(cardConfig.power)
	baseText.text = str(cardConfig.base)
	manaText.text=str(cardConfig.mana)
	var text=""
	for key in cardConfig.keywords:
		var format_string = "%s - %s %s for %s\n"
		var actual_string = format_string % [str(key.trigger), str(key.KeywordType.keys()[key.type]),str(key.value),str(key.duration)]
		text+=actual_string
	keyText.text=text
	
	if get_parent() is Slot:
		scale = transform.get_scale() * 0.3
		scaleMultiplier = 2
	else:
		scaleMultiplier = 1.5
	baseScale = transform.get_scale()
	
	baseZ = z_index
	get_node("Sprite3D").texture = cardConfig.texture
	rayCast2D = get_node("/root/root/RayCast2D")
	gameDirector = get_node("/root/root/GameDirector")

	gameDirector.selectedUnit.connect(_listener_select)
	gameDirector.unselect.connect(_listener_unselect)
	rayCast2D.selected.connect(_listener_selected)
	rayCast2D.unselected.connect(_listener_unselected)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (isMouseOn):
		scale = baseScale * scaleMultiplier
		z_index += 1
	elif(isMouseOnPress):
		scale = baseScale * scaleMultiplier
		z_index += 1
	else:
		if (transform.get_scale()!=baseScale):
			scale = baseScale
			z_index = baseZ
	
	


func _listener_selected(id,type):
	#print(id,"  ",get_instance_id())
	if(id == self):
		if(type == "motion"): 
			_mouse_on()
	elif(id != self && type == "press"):
		anotherNodeIsMoving = true
func _listener_unselected(id,type):
	#print(id,"  ",get_instance_id())
	if(id == self):
		if(type == "motion"):
			_mouse_off()
	elif(id != self && type == "press"):
		anotherNodeIsMoving = false
		
func _listener_select(id,type):
	#print(id,"  ",get_instance_id())
	if(id == self):
		if(type == "press"):
			_mouse_on_pressed()
	elif(id != self && type == "press"):
		anotherNodeIsMoving = true
func _listener_unselect(id = 0, type = " "):
	if(id == self || type == "all"):
		_mouse_on_unpressed()


func _mouse_on():
	isMouseOn = true
	
func _mouse_off():
	isMouseOn = false

func _mouse_on_pressed():
	isMouseOnPress = !isMouseOnPress
	print(isMouseOnPress)

func _mouse_on_unpressed():
	isMouseOnPress = false
	
func _get_class():
	return "Card"
