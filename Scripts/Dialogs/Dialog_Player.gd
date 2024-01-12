extends Control

@export_file("*json")  var dialog_file
@onready var background = $CanvasLayer;
@onready var replica_audio_player = $CanvasLayer/VBoxContainer/HBoxContainer/VBoxContainer/DialogPanel/HBoxContainer/DialogText/VBoxContainer/Replica/VoicePlayer
@onready var replica_text_label =  $CanvasLayer/VBoxContainer/HBoxContainer/VBoxContainer/DialogPanel/HBoxContainer/DialogText/VBoxContainer/Replica
@onready var type_char_timer = $CanvasLayer/VBoxContainer/HBoxContainer/VBoxContainer/DialogPanel/HBoxContainer/DialogText/VBoxContainer/Replica/CharacterTyper
@onready var character_name_label = $CanvasLayer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/CharacterName/CharacterName
@onready var buttons_container = $CanvasLayer/VBoxContainer/HBoxContainer/VBoxContainer/DialogPanel/HBoxContainer/DialogText/VBoxContainer/Buttons
@onready var wait_timer = $PausePerNextDialog;

var dialog_key = ""
var dialogs = {};
var dialog_script = {};
var curr_replica : Dictionary = {};
var message_char_index = 0;
var curr_message = "";
var is_in_progress = false;
var is_rested = true;
var type_character_speed = .1;
var isChoiceReplicaTextTyped = false;
var isAllOptionShowed = false;
var isOptionChosen = false;
var chosenReplicaKey; 
var chosenOptions : Array = [];
var playedDialogs : Dictionary;
var caller : IDialogCaller;
signal change_dialog_key(from,to);
# Called when the node enters the scene tree for the first time.
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
		type_char_timer.stop();
		message_char_index = 0;
		if not curr_replica["nextReplica"] == "choice":
			curr_replica = dialog_script[curr_replica["nextReplica"]];
		else:
			isChoiceReplicaTextTyped = true;
			add_options();
	

func process_replica():
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

func process_option_replica():
	if not isChoiceReplicaTextTyped:
		process_replica();
	else:
		if isOptionChosen:
			on_choice_voice_finished();

var _focused_button_index = 0;
func add_options():
	if not isAllOptionShowed:	
		var options = curr_replica["optionReplicas"];
		for option in options:
			var button = Button.new();
			button.theme_type_variation = "DialogButton";
			button.text = tr(dialog_script[option]["text"]);
			button.name = option;
			button.disabled = true;
			button.focus_mode = Control.FOCUS_ALL;
			button.focus_entered.connect(on_option_focus_entered.bind(button));
			button.focus_exited.connect(on_option_focus_exited.bind(button))
			button.alignment = HORIZONTAL_ALIGNMENT_LEFT;
			button.pressed.connect(on_option_pressed.bind(button));
			buttons_container.add_child(button);
		var first = buttons_container.get_child(_focused_button_index) as Button;
		first.grab_focus();
		isAllOptionShowed = true;

func on_option_focus_entered(button : Button):
	button.disabled = false;
	
	
func on_option_focus_exited(button : Button):
	button.disabled = true;
	
func on_option_pressed(button: Button):
	if isAllOptionShowed:
		if  not isOptionChosen:
			isOptionChosen = true;
			chosenReplicaKey = button.name;
			var replica = dialog_script[chosenReplicaKey];
			if FileAccess.file_exists(replica["audioPath"]):
				replica_audio_player.stream = load(replica["audioPath"]);
				replica_audio_player.play();
				replica_audio_player.finished.connect(on_choice_voice_finished);
			else:
				finish_option_replica(chosenReplicaKey);

func on_choice_voice_finished():
	replica_audio_player.finished.disconnect(on_choice_voice_finished);
	finish_option_replica(chosenReplicaKey);
	
func finish_option_replica(replica_key):
	for child in buttons_container.get_children():
		if child is Button:
			child.pressed.disconnect(on_option_pressed);
			buttons_container.remove_child(child)
	chosenOptions.append(replica_key);
	curr_replica = dialog_script[dialog_script[replica_key]["nextReplica"]];
	isChoiceReplicaTextTyped = false;
	isAllOptionShowed = false;
	isOptionChosen = false;
	next_replica();
	
	
func next_replica():
	if curr_replica["nextReplica"] == "choice":
		process_option_replica();
	elif curr_replica["nextReplica"] != "stop":
		process_replica();
	else:
		finish_dialog()


func finish_dialog():
	type_char_timer.stop();
	curr_message = "";	
	message_char_index = 0;
	replica_text_label.text = "";
	character_name_label.text = "";
	replica_audio_player.stop();
	type_char_timer.set_wait_time(type_character_speed);
	background.visible = false;
	get_tree().paused = false
	if playedDialogs.has(dialog_key):
		playedDialogs[dialog_key] += 1;
	else:
		playedDialogs[dialog_key] = 1;
	caller.dialog_finished.emit(caller,chosenOptions);
	is_in_progress = false;
	is_rested = false;
	wait_timer.start();
		
func on_display_dialog(dialog_caller):
	if not is_rested:
		return;
	elif is_in_progress:
			next_replica()
	else:
		caller = dialog_caller
		dialog_key = caller.dialog_key;
		if not dialogs.has(dialog_key):
			caller.dialog_finished.emit(dialog_key,["invalid key"]);
		else:
			get_tree().paused = true;
			background.visible = true;
			is_in_progress = true;
			dialog_script = dialogs[dialog_key]["script"];
			curr_replica = dialog_script["start"];
			type_char_timer.set_wait_time(type_character_speed);
			TranslationServer.set_locale("ua");
			next_replica();


func _on_character_typer_timeout():
	show_replica();


func _on_pause_per_next_dialog_timeout():
	is_rested = true;



func _on_i_dialog_caller_dialog_finished(caller, chosenOptions):
	var plot : Dictionary = dialogs["plot"];
	var key = caller.dialog_key;
	if plot.has(key):
		var requiredDialogs : Array = plot[key]["requiredDialogKeys"];
		if playedDialogs.has_all(requiredDialogs):
			change_dialog_key.emit(plot[key]["changeKey"],plot[key]["changeTo"]);
