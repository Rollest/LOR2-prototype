extends HSlider


var label:Label
var global_save: Node

func _ready():
	global_save = get_node("/root/Save")
	value_changed.connect(_on_value_changed)
	label=get_child(0)
	_on_value_changed(global_save.game_data["max_fps"])
	value = global_save.game_data["max_fps"]

func _on_value_changed(value:float):
	Engine.max_fps=value
	label.text=str(int(value))
