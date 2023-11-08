extends Node2D

class_name Arcs
@export var raycast:RayCast2D
var prevPos = Vector2(0,0)
var vector_from: Vector2 = Vector2(0,0)
var vector_to: Vector2
var list_from = Array()
var list_to = Array()
var dict_slot_A_B = {}
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(raycast.position != prevPos):
		queue_redraw()
	pass

func _draw():
	var stop = false
	for i in dict_slot_A_B.values():
		if(stop):
			break
		print(i)
		var width = 2.0
		var antialiased = true
		var resolution = 1
		var radius
		var color = Color(1.0,0.0,0.0)
		var A = i[0]
		#draw_circle(A,3,color)
		var B
		if(len(i)>1):
			B = i[1]
		else:
			B = raycast.position
			#stop = true
		#draw_circle(B,10,color)
		var D = Vector2((A.x+B.x)/2,(A.y+B.y)/2)
		#print("D: ", D)
		#draw_circle(D,7,color)
		radius = A.distance_to(B) * 1
		var CD = sqrt(radius**2 - (A.distance_to(B)/2)**2)
		#print("CD: ", CD)
		var angle = rad_to_deg(asin(A.distance_to(D)/radius))
		var C
		if(A.x > B.x):
			angle *= -1
			C = D + (D-A).normalized().rotated(deg_to_rad(-90)) * CD
		else:
			C = D + (D-A).normalized().rotated(deg_to_rad(90)) * CD
		#print("C: ", C)
		#draw_circle(C,14,color)
		#print(A.distance_to(C))
		
		
		
		var draw_counter = 1
		var line_origin = Vector2()
		var line_end = Vector2()
		var prev_origin = Vector2()
		line_origin = A
		
		if(angle >= 0):
			while draw_counter <= angle*2:
				prev_origin = line_origin
				line_end = (A-C).rotated(deg_to_rad(draw_counter)) + C
				draw_line(line_origin, line_end, color, width, antialiased)
				draw_counter += 1 / resolution
				line_origin = line_end
		else:
			draw_counter = -1
			while draw_counter >= angle*2:
				prev_origin = line_origin
				line_end = (A-C).rotated(deg_to_rad(draw_counter)) + C
				draw_line(line_origin, line_end, color, width, antialiased)
				draw_counter -= 1 / resolution
				line_origin = line_end
		draw_line(line_origin, line_origin + (line_origin - prev_origin).normalized().rotated(deg_to_rad(150)) * 20,color,width,antialiased)
		draw_line(line_origin, line_origin + (line_origin - prev_origin).normalized().rotated(deg_to_rad(-150)) * 20,color,width,antialiased)
	
