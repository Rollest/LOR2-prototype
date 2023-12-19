extends Control

var endgameMenu: Node

func _ready():
	hide()
	endgameMenu = get_node("../EndgameMenu")

func _input(event: InputEvent):
	if event.is_action_pressed("ui_cancel") && endgameMenu.visible == false:
		var new_pause_state = not get_tree().paused
		get_tree().paused = new_pause_state
		visible = new_pause_state


func _on_unpause_btn_pressed():
	get_tree().paused = false
	visible = false


func _on_exit_pressed():
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
	pass # Replace with function body.
