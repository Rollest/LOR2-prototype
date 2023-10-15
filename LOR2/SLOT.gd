extends Sprite3D

var speed
var card
var target
var min
var max
var unit

# Called when the node enters the scene tree for the first time.
func _ready():
	self.unit=get_owner()
	self.min=unit.speed[0]
	self.max=unit.speed[1]
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _new_speed():
	self.speed=randi_range(min,max)
	
