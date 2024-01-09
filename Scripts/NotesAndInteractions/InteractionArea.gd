extends Area3D

@export var interaction_key = "";
@export var dialog_key = "";
var isAreaActive = false;

func _input(event):
	if isAreaActive and event.is_action_pressed("ui_accept"):
		if interaction_key != "":
			NotesAndInteractionService.display_interaction.emit(interaction_key);
		if dialog_key != "":
			NotesAndInteractionService.display_dialog.emit(dialog_key);

func _on_area_entered(area):
	isAreaActive = true;


func _on_area_exited(area):
	isAreaActive = false;
