extends Node

var combatConfig: CombatConfig
@export var list_cards: Array[CardConfig]

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
