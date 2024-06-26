extends Area3D
@export var interaction_key = "";
@onready var dialog_caller : IDialogCaller = $IDialogCaller;
@onready var exclamation_mark = $LabelPos/ExclamationMark;
@export var isPickUp = false;
var isAreaActive = false;

func _input(event):
	if isAreaActive and event.is_action_pressed("interact"):
		if interaction_key != "":
			NotesAndInteractionService.display_interaction.emit(interaction_key);
		if dialog_caller.has_valid_key:
			NotesAndInteractionService.display_dialog.emit(dialog_caller);
	elif isAreaActive and event.is_action_pressed("item_pickup") and isPickUp:
		NotesAndInteractionService.pickup_item.emit(get_parent());
	

func _on_area_entered(area):
	if area.name != "PlayerInteractionArea":
		return
	isAreaActive = true;
	exclamation_mark.visible = true;
	if dialog_caller.is_autoplayed:
		NotesAndInteractionService.display_dialog.emit(dialog_caller);

func _on_area_exited(area):
	if area.name != "PlayerInteractionArea":
		return
	isAreaActive = false;
	exclamation_mark.visible = false;


func _on_dialog_player_dialog_finished():
	pass # Replace with function body.



func _on_i_dialog_caller_dialog_finished(caller, chosenOptions):
	pass # Replace with function body.
