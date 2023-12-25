class_name Enemy extends Unit


# Called when the node enters the scene tree for the first time.
func _enter_tree():
	super()

	for slot in find_children("EnemySlot"):
		slots.append(slot)

	
func _play_random():
	for slot in slots:
		slot.target=null
		slot.card=null
		
	var root = get_parent()
	var targets=gameDirector.find_objects_of_type("Ally")
	var playable_cards:Array[CardConfig]
	for card in hand:
		if mana>card.mana:
			playable_cards.append(card.duplicate(true))
			
	if targets!=null && targets.size()>0 && playable_cards.size()>0:
		for slot in slots:
			slot.card=hand[randi_range(0,hand.size()-1)]
			slot.target=targets[randi_range(0,targets.size()-1)]
			slot.evil_change_target(slot.target)
			slot._slot_card()

func _process(delta):
	super(delta)

func get_type():
	return "Enemy"
