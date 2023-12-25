extends Control


var sound: Node
var allies: Array[Node]
var enemies: Array[Node]
var selected_ally: UnitConfig
var selected_enemy: UnitConfig
var ally_stats_page: Node
var enemy_stats_page: Node
var ally_cards: Array[CardConfig]
var enemy_cards: Array[CardConfig]
var map: Node
var cards_list: Node
var cards_list_container: Node
var map_buttons: Array[Button]
var allies_container: Node
var enemies_container: Node
var ally_cards_container: Node
var enemy_cards_container: Node
var global_config: Node
var global_save: Node
var new_card = preload("res://Scenes/card_combat_menu.tscn")


func _ready():
	sound = get_node("/root/Sound")
	global_save = get_node("/root/Save")
	allies_container = get_node("Menu/Allies/UnitsContainer/MarginContainer/HBoxContainer")
	enemies_container = get_node("Menu/Enemies/UnitsContainer/MarginContainer/HBoxContainer")
	ally_cards_container = get_node("Menu/Allies/CardsContainer/ScrollContainer/MarginContainer/GridContainerAlly")
	enemy_cards_container = get_node("Menu/Enemies/CardsContainer/ScrollContainer/MarginContainer/GridContainerEnemy")
	ally_stats_page = get_node("Menu/Allies/UnitStatsPage")
	enemy_stats_page = get_node("Menu/Enemies/UnitStatsPage")
	map = get_node("Menu/Center/Map")
	cards_list = get_node("Menu/CardsList")
	cards_list_container = get_node("Menu/CardsList/Panel/ScrollContainer/MarginContainer/GridContainerCardsList")
	global_config = get_node("/root/GlobalConfig")
	
	for button in map.get_children():
		button.combat_button_clicked.connect(_listener_combat_button)
		map_buttons.append(button)
	for card in ally_cards_container.get_children():
		ally_cards_container.remove_child(card)
		card.queue_free()
	for card in enemy_cards_container.get_children():
		enemy_cards_container.remove_child(card)
		card.queue_free()
	ally_stats_page.visible = false
	enemy_stats_page.visible = false

	_save_load()
	for i in range(len(map_buttons)-1,-1,-1):
		if global_save.save[map_buttons[i].combatConfig.level] != 0:
			_combat_button(map_buttons[i].combatConfig)
			break
	sound.music_player.stream = sound.music_combat_menu
	sound.music_player.play()


func _listener_combat_button(combatConfig: CombatConfig):
	sound.click_standart_player.play()
	_combat_button(combatConfig)
	
	
func _combat_button(combatConfig: CombatConfig):
	var tmp: Array[UnitConfig]
	for ally in combatConfig.allies:
		tmp.append(ally.duplicate(true))
	combatConfig.allies.clear()
	combatConfig.allies = tmp
	var tmp2: Array[UnitConfig]
	for enemy in combatConfig.enemies:
		tmp2.append(enemy.duplicate(true))
	combatConfig.enemies.clear()
	combatConfig.enemies = tmp2
	global_config.combatConfig = combatConfig
	for ally in allies_container.get_children():
		allies_container.remove_child(ally)
		ally.queue_free()
	for ally in combatConfig.allies:
		var new_node = preload("res://Scenes/unit_combat_menu.tscn").instantiate()
		new_node.selected_unit.connect(_listener_ally_unit_selected)
		new_node.basestats = ally
		new_node.name = new_node.basestats.unit_name
		new_node.get_node("Container").texture = preload("res://Assets/Backgrounds/Menus/CombatMenu/UnitContainer.PNG")
		allies_container.add_child(new_node)
		allies.clear()
		allies.append_array(allies_container.get_children())
		
	for enemy in enemies_container.get_children():
		enemies_container.remove_child(enemy)
		enemy.queue_free()
	for enemy in combatConfig.enemies:
		var new_node = preload("res://Scenes/unit_combat_menu.tscn").instantiate()
		new_node.selected_unit.connect(_listener_enemy_unit_selected)
		new_node.basestats = enemy
		new_node.name = new_node.basestats.unit_name
		new_node.get_node("Container").texture = preload("res://Assets/Backgrounds/Menus/CombatMenu/EnemyContainer.PNG")
		enemies_container.add_child(new_node)
		enemies.clear()
		enemies.append_array(enemies_container.get_children())
	_ally_unit_selected(allies[0].basestats)
	_enemy_unit_selected(enemies[0].basestats)


func _listener_ally_unit_selected(ally):
	sound.click_standart_player.play()
	cards_list.visible = true
	_ally_unit_selected(ally)
	
	
func _ally_unit_selected(ally):
	selected_ally = ally
	ally_stats_page.visible = true
	ally_stats_page.get_node("UnitAvatar").texture = ally.texture
	ally_stats_page.get_node("PageLabel").text = ally.unit_name
	ally_stats_page.get_node("Stat").text = str(ally.maxHP)
	ally_stats_page.get_node("Stat3").text = str(ally.mana_max)
	
	
	for card in ally_cards_container.get_children():
		ally_cards_container.remove_child(card)
		card.queue_free()
	ally_cards.clear()
	ally_cards.append_array(ally.deck)
	var counter = 0
	if len(ally_cards) > 0:
		for card in ally_cards:
			counter += 1
			if len(ally_cards_container.get_children()) < 15:
				var new_node = new_card.duplicate(true).instantiate()
				new_node.selected_card.connect(_listener_ally_card_selected)
				new_node.cardConfig = card.duplicate(true)
				new_node.name = "ally_card" + str(counter)
				ally_cards_container.add_child(new_node)
			else:
				break


func _listener_enemy_unit_selected(enemy):
	sound.click_standart_player.play()
	_enemy_unit_selected(enemy)
	
func _enemy_unit_selected(enemy):
	selected_enemy = enemy
	enemy = enemy
	enemy_stats_page.visible = true
	enemy_stats_page.get_node("UnitAvatar").texture = enemy.texture
	enemy_stats_page.get_node("PageLabel").text = enemy.unit_name
	enemy_stats_page.get_node("Stat").text = str(enemy.maxHP)
	enemy_stats_page.get_node("Stat3").text = str(enemy.mana_max)
	
	for card in enemy_cards_container.get_children():
		enemy_cards_container.remove_child(card)
		card.queue_free()
	enemy_cards.clear()
	enemy_cards.append_array(enemy.deck)
	var counter = 0
	if len(enemy_cards) > 0:
		for card in enemy_cards:
			counter += 1
			if enemy_cards_container.get_child_count() < 15:
				var new_node = new_card.duplicate(true).instantiate()
				new_node.selected_card.connect(_listener_enemy_card_selected)
				new_node.cardConfig = card.duplicate(true)
				new_node.name = "enemy_card" + str(counter)
				enemy_cards_container.add_child(new_node)
			else:
				break


func _add_ally_card(card:Node):
	if ally_cards_container.get_child_count() < 15:
		ally_cards_container.add_child(card.duplicate(true))
		card.selected_card.connect(_listener_ally_card_selected)
		selected_ally.deck.append(card.cardConfig.duplicate(true))
		return true
	else:
		return false
		
func _remove_ally_card(card:Node):
	ally_cards_container.remove_child(card)
	card.selected_card.disconnect(_listener_ally_card_selected)
	_listener_ally_card_selected(card.cardConfig)
	var tmp: int
	for c in range(len(selected_ally.deck)-1):
		if _compare_cards(card.cardConfig,selected_ally.deck[c]) == true:
			tmp = c
	if tmp != null:
		selected_ally.deck.remove_at(tmp)
	
func _compare_cards(card1: CardConfig, card2: CardConfig):
	if card1.count == card2.count && card1.power == card2.power && card1.keywords == card2.keywords && card1.base == card2.base:
		return true
	return false
	
func _listener_ally_card_selected(cardConfig):
	print("ally_card_selected")
	sound.click_standart_player.play()


func _listener_enemy_card_selected(cardConfig):
	print("enemy_card_selected")
	sound.click_standart_player.play()


func _save_load():
	for i in range(min(len(map_buttons),len(global_save.save))):
		map_buttons[i]._is_active(global_save.save[map_buttons[i].combatConfig.level])

func _on_play_pressed():
	sound.click_start_game_player.play()
	get_tree().change_scene_to_file("res://Scenes/root.tscn")
