extends TextureRect

var menu: Control
@export var cardConfig: CardConfig
var countLabel: Label
var powerLabel: Label
var baseLabel: Label

signal selected_card(cardConfig)
# Called when the node enters the scene tree for the first time.
func _ready():
	menu = get_node("/root/CombatMenu")
	texture = cardConfig.texture
	countLabel = get_node("Count")
	powerLabel = get_node("Power")
	baseLabel = get_node("Base")
	countLabel.text = str(cardConfig.count)
	powerLabel.text = str(cardConfig.power)
	baseLabel.text = str(cardConfig.base)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	emit_signal("selected_card", cardConfig)
	pass # Replace with function body.
