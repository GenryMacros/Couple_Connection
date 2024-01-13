extends Node3D


var is_player_in_area = false
var is_usable = true
@export var connected_door: Node3D
@export var pc_display: CanvasLayer
@onready var area_3d = $pc/Area3D


func _ready():
	area_3d.body_entered.connect(body_entered)
	area_3d.body_exited.connect(body_exited)
	pc_display.correct_pass_entered.connect(pass_entered)
	

func body_entered(other_body: Node3D):
	if other_body.name == "Player":
		is_player_in_area = true
	

func body_exited(other_body: Node3D):
	if other_body.name == "Player":
		is_player_in_area = false
	

func pass_entered():
	$pc/Cube_002.get_active_material(0).get_next_pass().set("shader_param/shine_color", Vector3(0, 0, 0));
	is_usable = false
	connected_door.open()
	
	
func _input(event):
	if !GameManager.is_game_paused and event.is_action_pressed("ui_accept") and is_usable:
		if is_player_in_area:
			pc_display.activate()
