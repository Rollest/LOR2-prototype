extends TextureRect

var menu: Control
@export var basestats:UnitConfig
var stats:UnitConfig

signal selected_unit(stats)

# Called when the node enters the scene tree for the first time.
func _ready():
	menu = get_node("/root/CombatMenu")
	stats = basestats
	texture = stats.texture
	pass


func _on_button_pressed():
	emit_signal("selected_unit", stats)
	pass
