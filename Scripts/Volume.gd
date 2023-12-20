extends HSlider

@export var bus_name:String
var global_save: Node

var label:Label
var bus_index:int
func _ready():
	global_save = get_node("/root/Save")
	bus_index=AudioServer.get_bus_index(bus_name)
	value_changed.connect(_on_value_changed)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"),linear_to_db(global_save.game_data["music_vol"]))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"),linear_to_db(global_save.game_data["sfx_vol"]))
	value=db_to_linear(AudioServer.get_bus_volume_db(bus_index))
	label=get_child(0)
	label.text=str(value*100)+"%"

func _on_value_changed(value:float):
	AudioServer.set_bus_volume_db(bus_index,linear_to_db(value))
	label=get_child(0)
	label.text=str(value*100)+"%"
