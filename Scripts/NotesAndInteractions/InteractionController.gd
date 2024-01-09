extends CanvasLayer

@export_file("*json")  var interactions_text_file
var interactions = {};
var messages = [];
var message_char_index = 0;
var curr_message = "";
var is_in_progress = false;
var type_character_speed = .1;
@onready var background = $VBoxContainer/Background;
@onready var label = $VBoxContainer/Background/HBoxContainer/Label;
@onready var voicePlayer = $VBoxContainer/Background/VoicePlayer;
@onready var nextCharTimer = $VBoxContainer/Background/HBoxContainer/Label/next_char;


func _ready():
	background.visible = false;
	interactions = load_interactions_text();
	NotesAndInteractionService.display_interaction.connect(on_display_iteraction);
	


func load_interactions_text():
	if FileAccess.file_exists(interactions_text_file):
		var dataFile = FileAccess.open(interactions_text_file, FileAccess.READ);
		var parsedResult = JSON.parse_string(dataFile.get_as_text());
		if parsedResult is Dictionary:
			return parsedResult;
		else:
			print("Error reading file!");
	else:
		print("File doesn't exist!");

func show_text():
	label.text += curr_message[message_char_index];
	message_char_index+=1;
	if message_char_index >= curr_message.length():
		message_char_index = 0;
		nextCharTimer.stop();
	
func next_line():
	if messages.size() > 0:
		if message_char_index == 0:
			curr_message = tr(messages.pop_front());
		nextCharTimer.start();
	else:
		finish()

func finish():
	nextCharTimer.stop();
	curr_message = "";
	message_char_index = 0;
	label.text = "";
	background.visible = false;
	is_in_progress = false;
	get_tree().paused = false
	voicePlayer.stop();
	
	
	
func on_display_iteraction(interaction_key):
	if is_in_progress:
			next_line()
	else:
		get_tree().paused = true;
		background.visible = true;
		is_in_progress = true;
		messages = [interactions[interaction_key]["messageText"]];
		voicePlayer.stream = load(interactions[interaction_key]["messageAudio"]);
		voicePlayer.play();
		nextCharTimer.set_wait_time(type_character_speed);
		next_line();


func _on_next_char_timeout():
	show_text()
