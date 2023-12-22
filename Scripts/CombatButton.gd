extends Button

@export var combatConfig: CombatConfig

var closed_button: CompressedTexture2D
var open_button: CompressedTexture2D
var complete_button: CompressedTexture2D

signal combat_button_clicked(combatConfig:CombatConfig)
# Called when the node enters the scene tree for the first time.
func _ready():
	closed_button = preload("res://Assets/Backgrounds/Menus/CombatMenu/LevelButtons/Closed.PNG")
	open_button = preload("res://Assets/Backgrounds/Menus/CombatMenu/LevelButtons/Open.PNG")
	complete_button = preload("res://Assets/Backgrounds/Menus/CombatMenu/LevelButtons/Complete.PNG")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	emit_signal("combat_button_clicked", combatConfig)
	pass # Replace with function body.

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
