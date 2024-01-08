extends CanvasLayer

@export_file("*json")  var interactions_text_file
var interactions = {};
var selected_text = [];
var related_note_key = "";
var is_in_progress = false;

@onready var background = $Background;
@onready var label = $Background/Label;
@onready var voicePlayer = $Background/VoicePlayer;
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
	label.text = selected_text.pop_front();
	
func next_line():
	if selected_text.size() > 0:
		show_text()
	else:
		finish()

func finish():
	label.text = "";
	background.visible = false;
	is_in_progress = false;
	get_tree().paused = false
	NotesAndInteractionService.add_note.emit(related_note_key);
	voicePlayer.stop();
	
func on_display_iteraction(interaction_key):
	if is_in_progress:
			next_line()
	else:
		get_tree().paused = true;
		background.visible = true;
		is_in_progress = true;
		selected_text = [interactions[interaction_key]["messageText"]];
		related_note_key = interactions[interaction_key]["relatedNoteKey"];
		voicePlayer.stream = load(interactions[interaction_key]["messageAudio"]);
		voicePlayer.play();
		show_text();
