extends Control


var click_sound: AudioStreamPlayer
var music: AudioStreamPlayer
var base_volume: int

func _ready():
	hide()
	get_tree().paused = false
	click_sound = get_parent().get_node("ClickSound")
	music = get_parent().get_node("Music")
	base_volume = music.volume_db

func _input(event: InputEvent):
	if event.is_action_pressed("ui_cancel"):
		var new_pause_state = not get_tree().paused
		get_tree().paused = new_pause_state
		visible = new_pause_state
		if(visible == true):
			music.volume_db -= 10
		else:
			music.volume_db = base_volume
		click_sound.play()
		await click_sound.finished


func _on_exit_button_pressed():
	get_tree().paused = true
	visible = true


func _on_no_pressed():
	get_tree().paused = false
	visible = false
	click_sound.play()
	pass # Replace with function body.


func _on_yes_pressed():
	click_sound.play()
	await click_sound.finished
	get_tree().quit()
	pass # Replace with function body.
