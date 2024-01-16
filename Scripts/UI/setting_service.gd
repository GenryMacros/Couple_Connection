extends Node

var settings_json = "res://UI/settings.json";

var screenResolutions : Dictionary = {
	0: Vector2i(1920,1080),
	1: Vector2i(1280,720),
	2: Vector2i(3440,1440),
	3: Vector2i(1440,1080),
	4: Vector2i(1924,768),
	5: Vector2i(800,600)
}
var windowMode : Dictionary = {
	0: Window.MODE_WINDOWED,
	1: Window.MODE_EXCLUSIVE_FULLSCREEN
}
var settings: Dictionary = {
	"window_size":0,
	"window_mode":0,
	"language": 0
}
var audio_busses:Dictionary;

var languages : Dictionary = {
	0:"en",
	1:"ua"
}


func _ready():
	for bus_index in AudioServer.bus_count:
		audio_busses[bus_index]  = AudioServer.get_bus_name(bus_index);
		settings[audio_busses[bus_index]] = 20;
	read_from_settings();
	set_up_resolution(settings["window_size"]);
	set_up_window_mode(settings["window_mode"]);
	set_up_language(settings["language"]);
	for bus in audio_busses.keys():
		set_up_volume(bus,settings[audio_busses[bus]]);
	

func set_up_language(language_index):
	if languages.has(language_index):
		TranslationServer.set_locale(languages[language_index]);
		settings["language"] = language_index;
		
		
func set_up_resolution(resolution_index):
	if screenResolutions.has(resolution_index):
		var resolution = screenResolutions[resolution_index];
		var window = get_window();
		window.size  = resolution;
		settings["window_size"] = resolution_index

func set_up_window_mode(window_mode_index):
	if windowMode.has(window_mode_index):
		var window = get_window();
		window.mode = windowMode[window_mode_index];
		settings["window_mode"] = window_mode_index;
	
	
func set_up_volume(audio_bus_index, volume_in_percent):
	if audio_busses.has(audio_bus_index):
		var volume = volume_in_percent / 100.0;
		AudioServer.set_bus_volume_db(audio_bus_index,linear_to_db(volume))
		var bus_name = audio_busses[audio_bus_index];
		settings[bus_name] = volume_in_percent;


func read_from_settings():
	if FileAccess.file_exists(settings_json):
		var dataFile = FileAccess.open(settings_json, FileAccess.READ);
		var parsedResult = JSON.parse_string(dataFile.get_as_text());
		if parsedResult is Dictionary:
			for key in parsedResult.keys():
				settings[key] = int(parsedResult[key]);
		else:
			print("Error reading file!");
	else:
		print("File doesn't exist!");


func write_to_settings():
	var data = JSON.stringify(settings);
	var file = FileAccess.open(settings_json,FileAccess.WRITE);
	file.store_string(data);
	file.close();
	
	
func _exit_tree():
	write_to_settings();
