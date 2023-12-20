extends HSlider


var label:Label
func _ready():
	value_changed.connect(_on_value_changed)
	Engine.max_fps=60
	label=get_child(0)
	label.text=str(value)

func _on_value_changed(value:float):
	Engine.max_fps=value
	label.text=str(value)
