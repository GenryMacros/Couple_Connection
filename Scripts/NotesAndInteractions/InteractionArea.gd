extends Area3D

@export var interaction_key = "";
@onready var dialog_caller : IDialogCaller = $IDialogCaller;
var isAreaActive = false;

func _input(event):
	if isAreaActive and event.is_action_pressed("ui_accept"):
		if interaction_key != "":
			NotesAndInteractionService.display_interaction.emit(interaction_key);
		if dialog_caller.has_valid_key:
			NotesAndInteractionService.display_dialog.emit(dialog_caller);

func _on_area_entered(area):
	isAreaActive = true;


func _on_area_exited(area):
	isAreaActive = false;


func _on_dialog_player_dialog_finished():
	pass # Replace with function body.
