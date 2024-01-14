extends Control

@onready var progress_bar = $CanvasLayer/HBoxContainer/VBoxContainer/ProgressBar;
var progress = [];
var sceneName;
var scene_load_status;


# Called when the node enters the scene tree for the first time.
func _ready( ):
	sceneName = "res://Game_Levels/main.tscn";
	ResourceLoader.load_threaded_request(sceneName);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	scene_load_status = ResourceLoader.load_threaded_get_status(sceneName,progress);
	progress_bar.value = floor(progress[0]*100);
	if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED:
		var newScene = ResourceLoader.load_threaded_get(sceneName);
		get_tree().change_scene_to_packed(newScene);


