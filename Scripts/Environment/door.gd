extends Node3D


@onready var rotation_point = $rotation_point


func _ready():
	rotation_point.set_rotation_degrees(Vector3(0, 0, 0))


func open():
	rotation_point.set_rotation_degrees(Vector3(0, 90, 0))
	

func close():
	rotation_point.set_rotation_degrees(Vector3(0, 0, 0))
	
