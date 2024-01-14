extends "res://Scripts/NotesAndInteractions/InteractionArea.gd"
@onready var model : Node3D = $".."
#StartSHiza
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_i_dialog_caller_dialog_finished(caller, chosenOptions):
	var c = caller as IDialogCaller;
	if dialog_caller.dialog_key == c.dialog_key:
		model.queue_free();
