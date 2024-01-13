extends Node3D


@onready var player = $Player


func _ready():
	player.activate_first_person()

func _process(delta):
	pass
