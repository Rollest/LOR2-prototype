extends Node

@export var music_menu: AudioStreamMP3
@export var music_combat_menu: AudioStreamMP3
@export var music_combat: AudioStreamMP3
@export var click_standart: AudioStreamMP3
@export var click_start_game: AudioStreamMP3

var music_player: AudioStreamPlayer
var music_combat_menu_player: AudioStreamPlayer
var music_combat_player: AudioStreamPlayer
var click_standart_player: AudioStreamPlayer
var click_start_game_player: AudioStreamPlayer


func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	music_menu = preload("res://Assets/Audio/Music/Music_menu.mp3")
	music_combat_menu = preload("res://Assets/Audio/Music/Music_combat_menu.mp3")
	music_combat = preload("res://Assets/Audio/Music/Music_combat.mp3")
	click_standart = preload("res://Assets/Audio/Click_standart.mp3")
	click_start_game = preload("res://Assets/Audio/Click_start_game.mp3")
	
	music_player = get_node("MusicPlayer")
	click_standart_player = get_node("ClickStandartPlayer")
	click_start_game_player = get_node("ClickStartGamePlayer")
	
	music_player.stream = music_menu
	click_standart_player.stream = click_standart
	click_start_game_player.stream = click_start_game
	

