extends Node

var nextScene
var scenes = ["res://main.tscn",
			  "res://dungeon.tscn",
			"res://UI/ending.tscn"]
var player: Node
var current_scene = 0
var is_game_paused = false
enum ENDING {GOOD, BAD, MIDDLE}
var ending = ENDING.BAD; 
func _ready():
	nextScene = scenes[0]

func set_player(player_node):
	player = player_node

func set_new_scene():
	current_scene += 1
	if current_scene >= len(scenes):
		current_scene = 0
	nextScene = scenes[current_scene]
 
