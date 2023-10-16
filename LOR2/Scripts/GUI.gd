extends CanvasLayer

# Notifies `Main` node that the button has been pressed
signal next_turn
# Called when the node enters the scene tree for the first time.


func _on_turn_button_pressed():
	emit_signal("next_turn")
	print("aaaa")
