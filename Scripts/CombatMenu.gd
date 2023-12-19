extends Control


var click_sound: AudioStreamPlayer
var allies: Array[Node]
var enemies: Array[Node]
var ally_stats_page: Node
var enemy_stats_page: Node
var ally_cards: Array[CardConfig]
var enemy_cards: Array[CardConfig]
var ally_cards_rows: Array[Node]
var enemy_cards_rows: Array[Node]

# Called when the node enters the scene tree for the first time.
func _ready():
	click_sound = get_node("ClickSound")
	allies = get_node("Menu/Allies/UnitsContainer/MarginContainer/HBoxContainer").get_children()
	enemies = get_node("Menu/Enemies/UnitsContainer/MarginContainer/HBoxContainer").get_children()
	ally_stats_page = get_node("Menu/Allies/UnitStatsPage")
	enemy_stats_page = get_node("Menu/Enemies/UnitStatsPage")
	for row in get_node("Menu/Allies/CardsContainer").get_children():
		ally_cards_rows.append(row.get_node("MarginContainer/HBoxContainer"))
	for row in get_node("Menu/Enemies/CardsContainer").get_children():
		enemy_cards_rows.append(row.get_node("MarginContainer/HBoxContainer"))
	for row in ally_cards_rows:
		#ally_cards.append_array(row.get_children())
		for child in row.get_children():
			row.remove_child(child)
			child.queue_free()
	for row in enemy_cards_rows:
		#enemy_cards.append_array(row.get_children())
		for child in row.get_children():
			row.remove_child(child)
			child.queue_free()
	ally_stats_page.visible = false
	enemy_stats_page.visible = false
	
	#for card in ally_cards:
	#	card.selected_card.connect(_listener_ally_card_selected)
	#	for row in ally_cards_rows:
	#		if row.get_child_count() < 5:
	#			row.add_child(card)
	#			break
	#for card in enemy_cards:
	#	card.selected_card.connect(_listener_enemy_card_selected)
	#	for row in enemy_cards_rows:
	#		if row.get_child_count() < 5:
	#			row.add_child(card)
	#			break
				
	
	for ally in allies:
		ally.selected_unit.connect(_listener_ally_unit_selected)
	for enemy in enemies:
		enemy.selected_unit.connect(_listener_enemy_unit_selected)
	_listener_ally_unit_selected(allies[0].basestats)
	_listener_enemy_unit_selected(enemies[0].basestats)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _listener_ally_unit_selected(ally):
	click_sound.play()
	ally = ally.duplicate(true)
	ally_stats_page.visible = true
	ally_stats_page.get_node("UnitAvatar").texture = ally.texture
	ally_stats_page.get_node("PageLabel").text = ally.unit_name
	ally_stats_page.get_node("Stat").text = str(ally.maxHP)
	ally_stats_page.get_node("Stat2").text = str(ally.maxSP)
	ally_stats_page.get_node("Stat3").text = str(ally.mana_max)
	
	
	for row in ally_cards_rows:
		for child in row.get_children():
			row.remove_child(child)
			child.queue_free()
	ally_cards.clear()
	ally_cards.append_array(ally.deck)
	var counter = 0
	for card in ally_cards:
		counter += 1
		for row in ally_cards_rows:
			if len(row.get_children()) < 5:
				var new_node = preload("res://Scenes/card_combat_menu.tscn").instantiate()
				new_node.selected_card.connect(_listener_ally_card_selected)
				new_node.cardConfig = card.duplicate(true)
				new_node.name = "ally_card" + str(counter)
				row.add_child(new_node)
				break
	pass


func _listener_enemy_unit_selected(enemy):
	click_sound.play()
	enemy = enemy.duplicate(true)
	enemy_stats_page.visible = true
	enemy_stats_page.get_node("UnitAvatar").texture = enemy.texture
	enemy_stats_page.get_node("PageLabel").text = enemy.unit_name
	enemy_stats_page.get_node("Stat").text = str(enemy.maxHP)
	enemy_stats_page.get_node("Stat2").text = str(enemy.maxSP)
	enemy_stats_page.get_node("Stat3").text = str(enemy.mana_max)
	
	for row in enemy_cards_rows:
		for child in row.get_children():
			row.remove_child(child)
			child.queue_free()
	enemy_cards.clear()
	enemy_cards.append_array(enemy.deck)
	var counter = 0
	for card in enemy_cards:
		counter += 1
		for row in enemy_cards_rows:
			if row.get_child_count() < 5:
				var new_node = preload("res://Scenes/card_combat_menu.tscn").instantiate()
				new_node.selected_card.connect(_listener_enemy_card_selected)
				new_node.cardConfig = card.duplicate(true)
				new_node.name = "enemy_card" + str(counter)
				row.add_child(new_node)
				break
	pass
	
	
	
func _listener_ally_card_selected(cardConfig):
	print("ally_card_selected")
	click_sound.play()
	pass


func _listener_enemy_card_selected(cardConfig):
	print("enemy_card_selected")
	click_sound.play()
	pass


func _on_play_pressed():
	click_sound.play()
	await click_sound.finished
	get_tree().change_scene_to_file("res://Scenes/root.tscn")
