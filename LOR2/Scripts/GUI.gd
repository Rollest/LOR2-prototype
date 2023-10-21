extends CanvasLayer

# Notifies `Main` node that the button has been pressed
signal next_turn
# Called when the node enters the scene tree for the first time.


func _on_turn_button_pressed():
	emit_signal("next_turn")
	#print("aaaa")

#func _process(delta):
	#mouse raycasting
	#if Input.is_action_just_pressed("mouse_click"):
	#	var mousePos = get_global_mouse_position()
	#	var space = get_world_2d().direct_space_state
	#	var collision_objects = space.intersect_point(mousePos, 1)
	#	if collision_objects:
	#		print(collision_objects[0].collider.name)
	#	else:
	#		print("no hit")
	#pass

