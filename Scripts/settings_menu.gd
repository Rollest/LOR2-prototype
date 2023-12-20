extends Control

var global_save: Node
var sound: Node

const WINDOW_MODE_ARRAY: Array[String]=[
	"Full-Screen",
	"Windowed",
	"Borderless-Windowed"
]

# Called when the node enters the scene tree for the first time.
func _ready():
	global_save = get_node("/root/Save")
	sound = get_node("/root/Sound")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_delete_save_pressed():
	global_save = get_node("/root/Save")
	print ("savefile gone")
	global_save._clear()
	pass # Replace with function body.


func _on_exit_settings_pressed():
	sound = get_node("/root/Sound")
	sound.click_standart_player.play()
	visible=false
	pass # Replace with function body.


func _on_display_option_item_selected(index):
	match index:
		0: #Fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,false)
		1: #Windowed
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,false)
		2: #Borderless
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,true)
	pass # Replace with function body.
