extends Control

var endgameMenu: Node
var sound: Node

func _ready():
	hide()
	endgameMenu = get_node("../EndgameMenu")
	sound = get_node("/root/Sound")
	

func _input(event: InputEvent):
	if event.is_action_pressed("ui_cancel") && endgameMenu.visible == false:
		var new_pause_state = not get_tree().paused
		get_tree().paused = new_pause_state
		visible = new_pause_state
		if get_tree().paused == true:
			sound.music_player.stream_paused = true
		else:
			sound.music_player.stream_paused = false


func _on_unpause_btn_pressed():
	get_tree().paused = false
	visible = false
	sound.music_player.stream_paused = false


func _on_exit_pressed():
	sound.music_player.stream = sound.music_menu
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
