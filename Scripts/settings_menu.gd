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
	
	_on_display_option_item_selected(global_save.game_data["fullscreen_on"])
	get_node("TabContainer/Graphics/DisplayOption").selected = global_save.game_data["fullscreen_on"]
	Engine.max_fps = global_save.game_data["max_fps"]
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"),linear_to_db(global_save.game_data["music_vol"]))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"),linear_to_db(global_save.game_data["sfx_vol"]))
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
	
	global_save.game_data["max_fps"] = Engine.max_fps
	global_save.game_data["music_vol"] = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
	global_save.game_data["sfx_vol"] = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))
	global_save._save_data_config()
	global_save._load_data_config()
	visible=false
	pass # Replace with function body.


func _on_display_option_item_selected(index):
	match index:
		0: #Fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,false)
			global_save.game_data["fullscreen_on"] = 0
		1: #Windowed
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,false)
			global_save.game_data["fullscreen_on"] = 1
		2: #Borderless
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,true)
			global_save.game_data["fullscreen_on"] = 2
	pass # Replace with function body.
