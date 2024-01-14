extends "res://Scripts/NotesAndInteractions/InteractionArea.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_i_dialog_caller_dialog_finished(caller, chosenOptions):
	dialog_caller.dialog_key = "photo";


func _on_dialog_player_change_dialog_key(from, to):
	if dialog_caller.dialog_key == from:
		dialog_caller.dialog_key = to;
		var jail1 : Node3D = $"../../Photo/Jail/jail_door2"
		var jail2 : Node3D = $"../../Photo/Jail/jail_door2"
		var jail3 : Node3D = $"../../Photo/Jail/jail_door2"
		var jail4 : Node3D = $"../../Photo/Jail/jail_door2"
		jail1.queue_free();
		jail2.queue_free();
		jail3.queue_free();
		jail4.queue_free();

