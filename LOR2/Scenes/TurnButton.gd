extends Button


# Called when the node enters the scene tree for the first time.
signal next_turn
func _pressed():
	print("buttoooooon pressssss")
	emit_signal("next_turn")
