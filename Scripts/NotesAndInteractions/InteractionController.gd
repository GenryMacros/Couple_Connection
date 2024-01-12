extends Node

@export_file("*json")  var interactions_text_file
var interactions = {};

func _ready():
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

func on_display_iteraction(interaction_key):
	print(interaction_key);

