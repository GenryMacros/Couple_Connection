extends Area3D

@export var interaction_key = "";
@export var dialog_key = "";
@export var isPickUp = false;
var isAreaActive = false;

func _input(event):
	if event.is_action_pressed("item_pickup"):
		print("Fucking works")
	if isAreaActive and event.is_action_pressed("ui_accept"):
		if interaction_key != "":
			NotesAndInteractionService.display_interaction.emit(interaction_key);
		if dialog_key != "":
			NotesAndInteractionService.display_dialog.emit(dialog_key);
	elif isAreaActive and event.is_action_pressed("item_pickup") and isPickUp:
		NotesAndInteractionService.pickup_item.emit(get_parent());

func _on_area_entered(area):
	isAreaActive = true;


func _on_area_exited(area):
	isAreaActive = false;
