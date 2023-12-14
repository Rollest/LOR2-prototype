class_name Enemy extends Unit


# Called when the node enters the scene tree for the first time.
func _enter_tree():
	super()

	for slot in find_children("EnemySlot"):
		slots.append(slot)

	
	
func _play_random():
	var root = get_parent()
	var targets=gameDirector.find_objects_of_type("Ally")
	print(basestats)
	for t in targets:
		print("t ",t)
	print(slots)
	for slot in slots:
		slot.card=hand[randi_range(0,hand.size()-1)]
		slot.target=targets[randi_range(0,targets.size()-1)]
		slot.evil_change_target(slot.target)
		print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
		print(slot.card,"  a  ",slot.target)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super(delta)

func get_type():
	return "Enemy"
