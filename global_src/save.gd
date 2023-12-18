extends Node

const SAVEFILE = "res://global_src/SAVEFILE.json"

var game_data = {}

func _ready():
	load_data()

func load_data():
	var file = FileAccess.open(SAVEFILE,FileAccess.WRITE_READ)
	if not file.file_exists(SAVEFILE):
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
		save_data()
	file.open(SAVEFILE, FileAccess.WRITE_READ)
	game_data = file.get_var()
	file.close()
	
func save_data():
	var file = FileAccess.open(SAVEFILE,FileAccess.WRITE_READ)
	file.open(SAVEFILE, FileAccess.WRITE)
	file.store_var(game_data)
	file.close()
		
