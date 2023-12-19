extends Button

@export var combatConfig: CombatConfig

signal combat_button_clicked(combatConfig:CombatConfig)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	emit_signal("combat_button_clicked", combatConfig)
	pass # Replace with function body.
