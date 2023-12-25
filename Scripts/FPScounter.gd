extends Label



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text="FPS:"+str(int(1.0/delta))
	pass
