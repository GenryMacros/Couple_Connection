extends Control
@onready var play_button : Button = $CanvasLayer/HBoxContainer/VBoxContainer/Play;
@onready var settings_button : Button = $CanvasLayer/HBoxContainer/VBoxContainer/Settings;
@onready var exit_button : Button = $CanvasLayer/HBoxContainer/VBoxContainer/Exit;

# Called when the node enters the scene tree for the first time.
func _ready():
	play_button.focus_entered.connect(_on_focus_entered.bind(play_button));
	settings_button.focus_entered.connect(_on_focus_entered.bind(settings_button));
	exit_button.focus_entered.connect(_on_focus_entered.bind(exit_button));
	play_button.focus_exited.connect(_on_focus_exited.bind(play_button));
	settings_button.focus_exited.connect(_on_focus_exited.bind(settings_button));
	exit_button.focus_exited.connect(_on_focus_exited.bind(exit_button));
	play_button.grab_focus();



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_focus_entered(button: Button):
	button.disabled = false;

func _on_focus_exited(button: Button):
	button.disabled = true;

func _on_play_pressed():
	var loading_screen = load("res://UI/loading_scene.tscn"); 
	get_tree().change_scene_to_packed(loading_screen);


func _on_settings_pressed():
	var settings_screen = load("res://UI/settins.tscn");
	get_tree().change_scene_to_packed(settings_screen);

func _on_exit_pressed():
	get_tree().quit();
	


	

