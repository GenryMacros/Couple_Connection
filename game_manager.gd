extends Node

var nextScene
var scenes = ["res://Game_levels/main.tscn",
			  "res://Game_Levels/dungeon.tscn"]
var player: Node
var is_game_paused = false


func _ready():
	nextScene = scenes[0]

func set_player(player_node):
	player = player_node

func set_new_scene():
	for scene in scenes:
		print(scene)
	scenes.pop_front()
	if !scenes.is_empty():
		nextScene = scenes[0]
 
