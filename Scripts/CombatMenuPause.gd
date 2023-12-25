extends Control

var sound: Node

func _ready():
	hide()
	get_tree().paused = false
	sound = get_node("/root/Sound")
	

func _input(event: InputEvent):
	if event.is_action_pressed("ui_cancel"):
		var new_pause_state = not get_tree().paused
		get_tree().paused = new_pause_state
		visible = new_pause_state


func _on_unpause_btn_pressed():
	sound.click_standart_player.play()
	get_tree().paused = false
	visible = false


func _on_exit_pressed():
	sound.click_standart_player.play()
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
