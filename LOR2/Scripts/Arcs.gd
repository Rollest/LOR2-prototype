extends Node2D

@export var raycast:RayCast2D
var prevPos = Vector2(0,0)
var vector_from: Vector2 = Vector2(0,0)
var vector_to: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(raycast.position != prevPos):
		vector_to = raycast.position
		queue_redraw()
	pass

func _draw():
	var width = 2.0
	var antialiased = true
	var resolution = 1
	var radius
	var color = Color(1.0,0.0,0.0)
		
	var A = vector_from
	draw_circle(A,3,color)
	var B = vector_to
	draw_circle(B,10,color)
	var D = Vector2((A.x+B.x)/2,(A.y+B.y)/2)
	print("D: ", D)
	draw_circle(D,7,color)
	radius = A.distance_to(B) * 1
	var CD = sqrt(radius**2 - (A.distance_to(B)/2)**2)
	print("CD: ", CD)
	var C = D + (D-A).normalized().rotated(deg_to_rad(90)) * CD
	print("C: ", C)
	draw_circle(C,14,color)
	print(A.distance_to(C))
	
	var angle = rad_to_deg(asin(A.distance_to(D)/radius))
	var draw_counter = 1
	var line_origin = Vector2()
	var line_end = Vector2()
	line_origin = A

	while draw_counter <= angle*2:
		line_end = (A-C).rotated(deg_to_rad(draw_counter)) + C
		draw_line(line_origin, line_end, color, width, antialiased)
		draw_counter += 1 / resolution
		line_origin = line_end
