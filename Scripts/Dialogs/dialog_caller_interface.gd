extends Node
class_name IDialogCaller;

@export var dialog_key : String:
	set(new_key):
		if new_key != "":
			has_valid_key = true;
		else:
			has_valid_key = false;
		key_changed.emit(self);
		dialog_key = new_key;
@export var is_autoplayed : bool = false;
var has_valid_key : bool;
signal dialog_finished(caller : IDialogCaller, chosenOptions : Array);
signal key_changed(caller : IDialogCaller);


func _on_dialog_player_change_dialog_key(from, to):
	if dialog_key == from :
		dialog_key = to;
