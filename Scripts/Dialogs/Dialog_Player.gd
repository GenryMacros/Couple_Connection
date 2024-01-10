extends Control

@export_file("*json")  var dialog_file
@onready var background =  $CanvasLayer/VBoxContainer/PanelContainer;
@onready var replica_audio_player = $CanvasLayer/VBoxContainer/PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/Replica/AudioStreamPlayer;
@onready var replica_text_label =  $CanvasLayer/VBoxContainer/PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/Replica
@onready var type_char_timer = $CanvasLayer/VBoxContainer/PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/Replica/CharacterTyper
@onready var character_name_label = $CanvasLayer/VBoxContainer/PanelContainer/VBoxContainer/HBoxContainer2/CharacterName


var dialogs = {};
var dialog_script = {};
var curr_replica : Dictionary = {};
var message_char_index = 0;
var curr_message = "";
var is_in_progress = false;
var type_character_speed = .1;


func _ready():
	background.visible = false;
	dialogs = load_dialogs();
	NotesAndInteractionService.display_dialog.connect(on_display_dialog);
	

func load_dialogs():
	if FileAccess.file_exists(dialog_file):
		var dataFile = FileAccess.open(dialog_file, FileAccess.READ);
		var parsedResult = JSON.parse_string(dataFile.get_as_text());
		if parsedResult is Dictionary:
			return parsedResult;
		else:
			print("Error reading file!");
	else:
		print("File doesn't exist!");

func show_replica():
	replica_text_label.text += curr_message[message_char_index];
	message_char_index+=1;
	if message_char_index >= curr_message.length():
		message_char_index = 0;
		type_char_timer.stop();
		curr_replica = dialog_script[curr_replica["nextReplica"]];
	
	
func next_replica():
	if curr_replica["nextReplica"] != "stop":
		if type_char_timer.is_stopped():
			if message_char_index == 0:
				curr_message = tr(curr_replica["text"]);
			replica_text_label.text = "";
			character_name_label.text = tr(curr_replica["visibleName"]);
			replica_audio_player.stream = load(curr_replica["audioPath"]);
			replica_audio_player.play();
			type_char_timer.set_wait_time(type_character_speed);
			type_char_timer.start();
		else:
			type_char_timer.wait_time /=1.5;
	else:
		finish_replica()


func finish_replica():
	type_char_timer.stop();
	curr_message = "";	
	message_char_index = 0;
	replica_text_label.text = "";
	character_name_label.text = "";
	background.visible = false;
	is_in_progress = false;
	get_tree().paused = false
	replica_audio_player.stop();
	type_char_timer.set_wait_time(type_character_speed);
		
		
func on_display_dialog(dialog_key):
	if is_in_progress:
			next_replica()
	else:
		get_tree().paused = true;
		background.visible = true;
		is_in_progress = true;
		dialog_script = dialogs[dialog_key]["script"];
		curr_replica = dialog_script["replica1"];
		type_char_timer.set_wait_time(type_character_speed);
		TranslationServer.set_locale("en");
		next_replica();


func _on_character_typer_timeout():
	show_replica();
