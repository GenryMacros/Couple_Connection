extends "res://Scripts/NotesAndInteractions/InteractionArea.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
		


func _on_dialog_player_change_dialog_key(from, to):
	if(dialog_caller.dialog_key == from):
		dialog_caller.dialog_key = to;
