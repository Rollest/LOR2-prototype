extends Node

const SAVECONFIG = "user://SAVECONFIG.save"
const SAVE = "user://SAVE.save"

var game_data = {}
var save = {}

func _ready():
	_load_data_config()
	_load_data_save()

func _load_data_config():
	var file = FileAccess.open(SAVECONFIG,FileAccess.READ)
	if not FileAccess.file_exists(SAVECONFIG):
		game_data = {
			"fullscreen_on": false,
			"vsync_on": false,
			"display_fps": false,
			"max_fps": 0,
			"bloom_on": false,
			"brightness": 1,
			"master_vol": -10,
			"music_vol": -10,
			"sfx_vol": -10,
			"mouse_sens": .1,
		}
		_save_data_config()
	file.open(SAVECONFIG, FileAccess.READ)
	game_data = file.get_var()
	file.close()
	
func _save_data_config():
	var file = FileAccess.open(SAVECONFIG,FileAccess.WRITE)
	file.store_var(game_data)
	file.close()
	
	
func _load_data_save():
	var file = FileAccess.open(SAVE,FileAccess.READ)
	if not FileAccess.file_exists(SAVE):
		save = {
			"level1": false,
			"level2": false,
			"level3": false,
			"level4": false,
		}
		_save_data_save()
	file.open(SAVE, FileAccess.READ)
	save = file.get_var()
	file.close()
	
func _save_data_save():
	var file = FileAccess.open(SAVE,FileAccess.WRITE)
	file.store_var(save)
	file.close()
	
func _clear():
	var file = FileAccess.open(SAVE,FileAccess.WRITE)
	save = {
			"level1": false,
			"level2": false,
			"level3": false,
			"level4": false,
		}
	_save_data_save()
	_load_data_save()
	file.close()
		
