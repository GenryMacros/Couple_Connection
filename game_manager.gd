extends Node

var nextScene
var scenes = ["res://Game_levels/main.tscn",
			  "res://Game_Levels/dungeon.tscn"]
var player: Node
var current_scene = 0
var is_game_paused = false


func _ready():
	nextScene = scenes[0]

func set_player(player_node):
	player = player_node

func set_new_scene():
	current_scene += 1
	if current_scene >= len(scenes):
		current_scene = 0
	nextScene = scenes[current_scene]
 
