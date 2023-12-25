extends Control


var sound: Node
var base_music_volume: float
var settings_menu: Node

func _ready():
	hide()
	get_tree().paused = false
	sound = get_node("/root/Sound")
	settings_menu = get_node("/root/MainMenu/SettingsMenu")
	base_music_volume = sound.music_player.volume_db

func _input(event: InputEvent):
	if event.is_action_pressed("ui_cancel") && settings_menu.visible == false:
		var new_pause_state = not get_tree().paused
		get_tree().paused = new_pause_state
		visible = new_pause_state
		if(visible == true):
			sound.music_player.volume_db -= 10
		else:
			sound.music_player.volume_db = base_music_volume
		sound.click_standart_player.play()


func _on_exit_button_pressed():
	get_tree().paused = true
	visible = true


func _on_no_pressed():
	get_tree().paused = false
	visible = false
	sound.click_standart_player.play()


func _on_yes_pressed():
	sound.click_standart_player.play()
	await sound.click_standart_player.finished
	get_tree().quit()
