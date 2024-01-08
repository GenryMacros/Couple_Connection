extends Node
@export_file("*json")  var notes_file

var openedNotes : Dictionary = {} 
var notes = {}

func _ready():
	notes = load_notes();
	NotesAndInteractionService.add_note.connect(on_add_note);
	
func load_notes():
	if FileAccess.file_exists(notes_file):
		var dataFile = FileAccess.open(notes_file, FileAccess.READ);
		var parsedResult = JSON.parse_string(dataFile.get_as_text());
		if parsedResult is Dictionary:
			return parsedResult;
		else:
			print("Error reading file!");
	else:
		print("File doesn't exist!");
		
		
func on_add_note(note_key):
	if not openedNotes.has(note_key):
		var selected_note = notes[note_key];
		var requiredNotes : Array = notes[note_key]["requireNotesToOpen"];
		var pathTo : Array = notes[note_key]["pathToNotes"];
		var isAllNotesOpen = true;
		if requiredNotes.size() > 0:
			if not openedNotes.has_all(requiredNotes):
				isAllNotesOpen = false;
		if isAllNotesOpen:
			openedNotes[note_key] = 0;
			print(selected_note);
			for note in pathTo:
				NotesAndInteractionService.add_note.emit(note);
	
