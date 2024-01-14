extends Area3D


func _on_area_entered(_area):
	var loading_screen = load("res://UI/loading_scene.tscn"); 
	get_tree().change_scene_to_packed(loading_screen);
