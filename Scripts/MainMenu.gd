extends Control


var sound: Node
var global_save: Node

# Called when the node enters the scene tree for the first time.
func _ready():
	sound = get_node("/root/Sound")
	sound.music_player.stream = sound.music_menu
	sound.music_player.play()
	global_save = get_node("/root/Save")


func _on_play_button_pressed():
	sound.click_standart_player.play()
	get_tree().change_scene_to_file("res://Scenes/CombatMenu.tscn")


func _on_settings_button_pressed():
	sound.click_standart_player.play()
	find_child("SettingsMenu").visible=true
	



func _on_exit_button_pressed():
	sound.click_standart_player.play()
