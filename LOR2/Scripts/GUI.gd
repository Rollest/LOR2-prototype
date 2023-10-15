extends CanvasLayer

# Notifies `Main` node that the button has been pressed
signal next_turn
# Called when the node enters the scene tree for the first time.
func on_TurnButton_pressed():
	next_turn.emit()
	print("aaaa")

