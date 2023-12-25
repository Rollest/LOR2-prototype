extends Button



func _on_unit_selected():
	visible=true
	
func _on_unit_unselected():
	visible=false

func _on_gui_show_deck():
	visible = true


func _on_gui_stop_showing_deck():
	visible=false
