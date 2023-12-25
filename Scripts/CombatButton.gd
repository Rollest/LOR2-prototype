extends Button

@export var combatConfig: CombatConfig

var closed_button: CompressedTexture2D
var open_button: CompressedTexture2D
var complete_button: CompressedTexture2D

signal combat_button_clicked(combatConfig:CombatConfig)

func _ready():
	closed_button = preload("res://Assets/Backgrounds/Menus/CombatMenu/LevelButtons/Closed.PNG")
	open_button = preload("res://Assets/Backgrounds/Menus/CombatMenu/LevelButtons/Open.PNG")
	complete_button = preload("res://Assets/Backgrounds/Menus/CombatMenu/LevelButtons/Complete.PNG")
	set("theme_override_colors/icon_disabled_color",Color(1, 1, 1, 1))

func _on_pressed():
	emit_signal("combat_button_clicked", combatConfig)

func _is_active(state: int):
	if state == 0:
		disabled = true
		icon = closed_button
	elif state == 1:
		disabled = false
		icon = open_button
	elif state == 2:
		disabled = false
		icon = complete_button
