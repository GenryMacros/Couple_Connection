extends Control

@onready var resolution : OptionButton = $CanvasLayer/HBoxContainer/MarginContainer/VBoxContainer/VideoSettings/ScreenResolutionOptions;
@onready var window_mode : OptionButton = $CanvasLayer/HBoxContainer/MarginContainer/VBoxContainer/VideoSettings/WindowModeOptions;
@onready var language : OptionButton = $CanvasLayer/HBoxContainer/MarginContainer/VBoxContainer/LanguageSettings/LanguageOptions;
@onready var master_volume_label  = $CanvasLayer/HBoxContainer/MarginContainer/VBoxContainer/VolumeSettings/HBoxContainer/MasterVolumeValueValue
@onready var master_volume_slider : HSlider = $CanvasLayer/HBoxContainer/MarginContainer/VBoxContainer/VolumeSettings/HBoxContainer/MasterVolume
@onready var music_volume_slider : HSlider = $CanvasLayer/HBoxContainer/MarginContainer/VBoxContainer/VolumeSettings/HBoxContainer3/MusicVolume;
@onready var music_volume_label  = $CanvasLayer/HBoxContainer/MarginContainer/VBoxContainer/VolumeSettings/HBoxContainer3/MusicVolumeValue
@onready var sfx_volume_slider : HSlider = $CanvasLayer/HBoxContainer/MarginContainer/VBoxContainer/VolumeSettings/HBoxContainer4/SoundEffectsVolume;
@onready var sfx_volume_label  = $CanvasLayer/HBoxContainer/MarginContainer/VBoxContainer/VolumeSettings/HBoxContainer4/SFXVolumeValue;
@onready var dialog_volume_label  = $CanvasLayer/HBoxContainer/MarginContainer/VBoxContainer/VolumeSettings/HBoxContainer2/DialogVolumeValue
@onready var dialog_volume_slider : HSlider = $CanvasLayer/HBoxContainer/MarginContainer/VBoxContainer/VolumeSettings/HBoxContainer2/DialogVolume


# Called when the node enters the scene tree for the first time.
func _ready():
	set_up_settings();
	resolution.grab_focus();
	
	
func _on_exit_button_focus_entered():
	var button = $CanvasLayer/HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/ExitButton
	button.disabled = false;

func _on_exit_button_focus_exited():
	var button = $CanvasLayer/HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/ExitButton
	button.disabled = true;


func _on_exit_button_pressed():
	var main_screen = load("res://UI/main_menu.tscn"); 
	get_tree().change_scene_to_packed(main_screen);


func _on_screen_resolution_options_focus_entered():
	var button = $CanvasLayer/HBoxContainer/MarginContainer/VBoxContainer/VideoSettings/ScreenResolutionOptions;
	button.disabled = false;


func _on_screen_resolution_options_focus_exited():
	var button = $CanvasLayer/HBoxContainer/MarginContainer/VBoxContainer/VideoSettings/ScreenResolutionOptions;
	button.disabled = true;


func _on_language_options_focus_entered():
	var button = $CanvasLayer/HBoxContainer/MarginContainer/VBoxContainer/LanguageSettings/LanguageOptions;
	button.disabled = false;


func _on_language_options_focus_exited():
	var button = $CanvasLayer/HBoxContainer/MarginContainer/VBoxContainer/LanguageSettings/LanguageOptions;
	button.disabled = true;


func _on_language_options_item_selected(index):
	SettingService.set_up_language(index);

func _on_screen_resolution_options_item_selected(index):
	SettingService.set_up_resolution(index);

func _on_window_mode_options_item_selected(index):
	SettingService.set_up_window_mode(index);
	
		
func _on_window_mode_options_focus_entered():
	var button = $CanvasLayer/HBoxContainer/MarginContainer/VBoxContainer/VideoSettings/WindowModeOptions
	button.disabled = false;
	

func _on_window_mode_options_focus_exited():
	var button = $CanvasLayer/HBoxContainer/MarginContainer/VBoxContainer/VideoSettings/WindowModeOptions
	button.disabled = true;
	
func _on_master_volume_value_changed(value):
	master_volume_label.text =  str(floor(value));
	SettingService.set_up_volume(0,int(master_volume_slider.value));
	
func _on_music_volume_value_changed(value):
	music_volume_label.text = str(floor(value));
	SettingService.set_up_volume(3,int(music_volume_slider.value));

func _on_sound_effects_volume_value_changed(value):
	sfx_volume_label.text = str(floor(value));
	SettingService.set_up_volume(1,int(sfx_volume_slider.value));
func _on_dialog_volume_value_changed(value):
	dialog_volume_label.text = str(floor(value));
	SettingService.set_up_volume(2,int(dialog_volume_slider.value));
	

func set_up_settings():
		resolution.selected = SettingService.settings["window_size"];
		window_mode.selected = SettingService.settings["window_mode"];
		master_volume_label.text = str(SettingService.settings["Master"]);
		master_volume_slider.value = SettingService.settings["Master"]
		dialog_volume_label.text = str(SettingService.settings["Dialogs"]);
		dialog_volume_slider.value = SettingService.settings["Dialogs"];
		music_volume_label.text = str(SettingService.settings["Music"]);
		music_volume_slider.value = SettingService.settings["Music"];
		sfx_volume_label.text = str(SettingService.settings["SoundEfects"]);
		sfx_volume_slider.value = SettingService.settings["SoundEfects"];
		language.selected = SettingService.settings["language"];
