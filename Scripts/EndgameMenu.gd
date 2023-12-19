extends Control

var label: Label
var is_active: bool = false

func _ready():
	visible = false
	hide()
	label = get_node("TextureRect/Label")

func _input(event: InputEvent):
	if event.is_action_pressed("ui_cancel") && is_active:
		get_tree().change_scene_to_file("res://Scenes/CombatMenu.tscn")
	pass

func _on_exit_pressed():
	get_tree().change_scene_to_file("res://Scenes/CombatMenu.tscn")
	pass # Replace with function body.


func _win():
	is_active = true
	visible = true
	get_tree().paused = true
	label.text = "YOU WIN!"
	
func _lose():
	is_active = true
	visible = true
	get_tree().paused = true
	label.text = "YOU LOSE!"
	
