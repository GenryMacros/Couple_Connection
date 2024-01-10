extends Node3D


@export var connected_door: Node3D

@onready var area_3d = $MeshInstance3D/Area3D

func _ready():
	area_3d.body_entered.connect(open_connected_door)
	area_3d.body_exited.connect(try_close_connected_door)
	

func open_connected_door(_body: Node3D):
		if _body.name == "GridMap":
			return
		connected_door.open()
	
func try_close_connected_door(_body: Node3D):
	if len(area_3d.get_overlapping_areas()) == 0:
		connected_door.close()
	
	
func _process(delta):
	pass
