extends Control

var click_sound: AudioStreamPlayer

func _ready():
	hide()
	click_sound = get_node("../ClickSound")
	

func _input(event: InputEvent):
	if event.is_action_pressed("ui_cancel"):
		var new_pause_state = not get_tree().paused
		get_tree().paused = new_pause_state
		visible = new_pause_state


func _on_unpause_btn_pressed():
	click_sound.play()
	get_tree().paused = false
	visible = false


func _on_exit_pressed():
	click_sound.play()
	await click_sound.finished
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
	pass # Replace with function body.
