extends Area3D


func _on_area_entered(area):
	var loading_screen = load("res://UI/loading_scene.tscn"); 
	get_tree().change_scene_to_packed(loading_screen);


func _on_i_dialog_caller_dialog_finished(caller : IDialogCaller, chosenOptions : Array):
	if caller.dialog_key == "finalShiza":
		if chosenOptions.has("badEnding"):
			var loading_screen = load("res://UI/loading_scene.tscn"); 
			GameManager.ending = GameManager.ENDING.BAD;
			get_tree().change_scene_to_packed(loading_screen);
		elif chosenOptions.has("rpl16"):
			var loading_screen = load("res://UI/loading_scene.tscn"); 
			GameManager.ending = GameManager.ENDING.MIDDLE;
			get_tree().change_scene_to_packed(loading_screen);
		elif  chosenOptions.has("rpl17"):
			var loading_screen = load("res://UI/loading_scene.tscn"); 
			GameManager.ending = GameManager.ENDING.GOOD;
			get_tree().change_scene_to_packed(loading_screen);
