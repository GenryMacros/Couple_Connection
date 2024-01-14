extends Node3D

@onready var texture : TextureRect = $mirror/Sprite3D/SubViewport/Panel/TextureRect;

# Called when the node enters the scene tree for the first time.

func _ready():
	change_darkness(22);

func change_darkness(darkness:float):
	texture.material.set("shader_param/dark_coof",darkness);
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_i_dialog_caller_dialog_finished(caller : IDialogCaller, chosenOptions):
	if caller.dialog_key == "strangeMirror":
		if chosenOptions.has("success_1"):
			change_darkness(5);
