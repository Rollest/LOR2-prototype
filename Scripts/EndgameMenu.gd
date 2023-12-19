extends Control

var label: Label

func _ready():
	hide()
	label = get_node("TextureRect/Label")

func _input(event: InputEvent):
	if event.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://Scenes/CombatMenu.tscn")


func _on_exit_pressed():
	get_tree().change_scene_to_file("res://Scenes/CombatMenu.tscn")
	pass # Replace with function body.


func _win():
	visible = true
	get_tree().paused = true
	label.text = "YOU WIN!"
	
func _lose():
	visible = true
	get_tree().paused = true
	label.text = "YOU LOSE!"
	
