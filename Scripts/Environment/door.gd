extends Node3D


@onready var rotation_point = $rotation_point
var is_school_completed = false;
var is_forest_completed = false;
var is_mirror_completed = false;

func _ready():
	rotation_point.set_rotation_degrees(Vector3(0, 0, 0))


func open():
	rotation_point.set_rotation_degrees(Vector3(0, 90, 0))
	

func close():
	rotation_point.set_rotation_degrees(Vector3(0, 0, 0))
	

func _process(delta):
	pass


func _on_i_dialog_caller_dialog_finished(caller : IDialogCaller, chosenOptions: Array):
		if(caller.dialog_key == "photo"):
			is_school_completed = true
		if caller.dialog_key == "strangeMirror" and (chosenOptions.has("success_1") or chosenOptions.has("success_2")):
			is_mirror_completed = true
		if caller.dialog_key == "forrestNote":
			is_forest_completed = true
		if is_forest_completed and is_mirror_completed and is_school_completed:
			open()
