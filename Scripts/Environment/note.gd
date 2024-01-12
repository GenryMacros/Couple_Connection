extends Node3D


@onready var area_3d = $MeshInstance3D/Area3D


func _ready():
	area_3d.area_entered.connect(area_enter)


func area_enter(other_area: Area3D):
	print(other_area.name)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
