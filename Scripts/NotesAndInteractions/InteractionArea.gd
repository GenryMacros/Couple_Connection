extends Area3D
@export var interaction_key = "";
@onready var dialog_caller : IDialogCaller = $IDialogCaller;
@export var isPickUp = false;
var isAreaActive = false;


func _input(event):
	if isAreaActive and event.is_action_pressed("Interact"):
		if interaction_key != "":
			NotesAndInteractionService.display_interaction.emit(interaction_key);
		if dialog_caller.has_valid_key:
			NotesAndInteractionService.display_dialog.emit(dialog_caller);
	elif isAreaActive and event.is_action_pressed("item_pickup") and isPickUp:
		NotesAndInteractionService.pickup_item.emit(get_parent());

func _on_area_entered(area):
	isAreaActive = true;


func _on_area_exited(area):
	isAreaActive = false;


func _on_dialog_player_dialog_finished():
	pass # Replace with function body.
