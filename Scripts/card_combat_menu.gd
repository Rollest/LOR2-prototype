extends TextureRect

var menu: Control
@export var cardConfig: CardConfig
var countLabel: Label
var powerLabel: Label
var baseLabel: Label
var keyLabel:Label
var manaLabel:Label

signal selected_card(cardConfig)
# Called when the node enters the scene tree for the first time.
func _ready():
	menu = get_node("/root/CombatMenu")
	texture = cardConfig.texture
	countLabel = get_node("Count")
	powerLabel = get_node("Power")
	baseLabel = get_node("Base")
	keyLabel = get_node("Keywords")
	manaLabel = get_node("Mana")
	countLabel.text = str(cardConfig.count)
	powerLabel.text = str(cardConfig.power)
	baseLabel.text = str(cardConfig.base)
	var text=""
	for key in cardConfig.keywords:
		var format_string = "%s - %s %s for %s\n"
		var actual_string = format_string % [str(key.trigger), str(key.KeywordType.keys()[key.type]),str(key.value),str(key.duration)]
		text+=actual_string
	keyLabel.text=text
	manaLabel.text = str(cardConfig.mana)
	pass # Replace with function body.



func _on_button_pressed():
	if get_parent().name == "GridContainerAlly":
		#list_of_cards.append(cardConfig)
		if menu._remove_ally_card(self) == true:
			get_parent().remove_child(self)
	elif get_parent().name == "GridContainerCardsList":
		#list_of_cards.remove(cardConfig)
		menu._add_ally_card(self)
	emit_signal("selected_card", cardConfig)
