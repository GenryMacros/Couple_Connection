extends Node
class_name IDialogCaller;

@export var dialog_key : String:
	set(new_key):
		if new_key != "":
			has_valid_key = true;
		else:
			has_valid_key = false;
		dialog_key = new_key;
		
var has_valid_key : bool;
signal dialog_finished(caller : IDialogCaller, chosenOptions : Array);
	


func _on_dialog_player_change_dialog_key(from, to):
	if dialog_key == from :
		dialog_key = to;