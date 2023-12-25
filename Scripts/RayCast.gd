extends RayCast2D


var prevCollider: CharacterBody2D
var collider: CharacterBody2D

signal selected(id,event_type)
signal unselected(id,event_type)


	
func _input(event):
	if	(event is InputEventMouseMotion):
		var cursor_pos = get_viewport().get_mouse_position()
		position = cursor_pos
		force_raycast_update()
		collider = get_collider()
		if (collider == null): collider = get_node("../Pustishka")
		if (prevCollider == null): prevCollider = get_node("../Pustishka")
		if (collider != prevCollider):
			emit_signal("unselected", prevCollider,"motion")
		elif (collider != null):
			emit_signal("selected", collider,"motion")
			
	if (event is InputEventMouseButton):
		var cursor_pos = get_viewport().get_mouse_position()
		position = cursor_pos
		force_raycast_update()
		collider = get_collider()
		if (collider == null): collider = get_node("../Pustishka")
		if (prevCollider == null): prevCollider = get_node("../Pustishka")
		if (event.is_pressed()==true && event.button_index == 1):
			emit_signal("selected", collider,"press")
		elif (collider != null && event.is_pressed()==false):
			emit_signal("unselected", collider,"press")
	prevCollider = collider
	
