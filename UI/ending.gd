extends Control
@onready var label : Label = $CanvasLayer/PanelContainer/HBoxContainer/VBoxContainer/EndingTexet;
@onready var type_char_timer  : Timer = $CanvasLayer/PanelContainer/HBoxContainer/VBoxContainer/EndingTexet/CharacterTimer
@export var type_character_time_in_seconds = .005;
@onready var next_page_button : Button = $CanvasLayer/PanelContainer/HBoxContainer/VBoxContainer/NextPageButton
var printed_str = "";
var char_index = 0;
var str_index = 0;
var strArr = [];
var is_scene_played = false;
# Called when the node enters the scene tree for the first time.
func _ready():
	if(GameManager.ending == GameManager.ENDING.GOOD):
		strArr.append(tr("GOOD_ENDING"));
	if(GameManager.ending == GameManager.ENDING.MIDDLE):
		strArr.append(tr("MIDDLE_ENDING"));
	strArr.append(tr("LAST_WORD"));
	strArr.append(tr("LAST_WORD"));
	type_char_timer.set_wait_time(type_character_time_in_seconds);
	type_char_timer.start();
	next_page_button.visible = false;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_scene_played:
		var loading_screen = load("res://UI/main_menu.tscn");
		get_tree().change_scene_to_packed(loading_screen);

func _on_character_timer_timeout():
	if str_index < strArr.size():
		if char_index < len(strArr[str_index]):		
			printed_str += strArr[str_index][char_index];
			label.text = printed_str; 
			char_index+=1;
		else:
			if not next_page_button.visible:
				next_page_button.visible = true;
				next_page_button.grab_focus();
			
	else:
		type_char_timer.stop();
		is_scene_played = true;


func _on_next_page_button_pressed():
	printed_str = "";
	label.text = "";
	char_index = 0;
	str_index+=1;
	next_page_button.visible = false;


func _on_next_page_button_focus_entered():
	next_page_button.disabled = false;


func _on_next_page_button_focus_exited():
	next_page_button.disabled = true;
