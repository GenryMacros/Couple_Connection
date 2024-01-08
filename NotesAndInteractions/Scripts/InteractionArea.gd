extends Area3D

@export var interaction_key = "";
var isAreaActive = false;

func _input(event):
	if isAreaActive and event.is_action_pressed("ui_accept"):
		NotesAndInteractionService.emit_signal("display_interaction", interaction_key);

func _on_area_entered(area):
	isAreaActive = true;


func _on_area_exited(area):
	isAreaActive = false;
