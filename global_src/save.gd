extends Node

const SAVECONFIG = "user://SAVECONFIG.save"
const SAVE = "user://SAVE.save"

var game_data = {}
var save = {}

func _ready():
	_load_data_config()
	_load_data_save()

func _load_data_config():
	var file = FileAccess.open(SAVECONFIG,FileAccess.READ_WRITE)
	if not FileAccess.file_exists(SAVECONFIG):
		game_data = {
			"fullscreen_on": 1,
			"max_fps": 60,
			"music_vol": 1,
			"sfx_vol": 1,
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
	var file = FileAccess.open(SAVE,FileAccess.READ_WRITE)
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
	
	
	file = FileAccess.open(SAVECONFIG,FileAccess.WRITE)
	game_data = {
			"fullscreen_on": 1,
			"max_fps": 60,
			"music_vol": 1,
			"sfx_vol": 1,
		}
	_save_data_config()
	_load_data_config()
	file.close()
		
