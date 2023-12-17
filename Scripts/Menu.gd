extends Control

func _ready():
	hide()

func _input(event: InputEvent):
	if event.is_action_pressed("ui_cancel"):
		var new_pause_state = not get_tree().paused
		get_tree().paused = new_pause_state
		visible = new_pause_state


func _on_unpause_btn_pressed():
	get_tree().paused = false
	visible = false


func _on_exit_pressed():
	get_tree().quit()
	pass # Replace with function body.
