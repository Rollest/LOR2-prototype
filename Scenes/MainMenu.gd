extends Control


var click_sound: AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	click_sound = get_node("ClickSound")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_play_button_pressed():
	click_sound.play()
	await click_sound.finished


func _on_settings_button_pressed():
	click_sound.play()
	await click_sound.finished


func _on_exit_button_pressed():
	click_sound.play()
	await click_sound.finished
