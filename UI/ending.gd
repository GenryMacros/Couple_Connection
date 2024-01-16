extends Control
@onready var label : Label = $CanvasLayer/HBoxContainer/EndingTexet;
@onready var type_char_timer  : Timer = $CanvasLayer/HBoxContainer/EndingTexet/CharacterTimer
@export var type_character_time_in_seconds = .0005;
@onready var string_change_timer : Timer = $CanvasLayer/HBoxContainer/EndingTexet/Timer
var printed_str = "";
var char_index = 0;
var str_index = 0;
var strArr = []
var i_var = false
# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.ending = GameManager.ENDING.GOOD;
	if(GameManager.ending == GameManager.ENDING.GOOD):
		strArr.append(tr("GOOD_ENDING"));
	if(GameManager.ending == GameManager.ENDING.MIDDLE):
		strArr.append(tr("MIDDLE_ENDING"));
	strArr.append(tr("LAST_WORD"));
	type_char_timer.set_wait_time(type_character_time_in_seconds);
	type_char_timer.start();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if type_char_timer.is_stopped() and Input.is_action_pressed("Exit"):
		var loading_screen = load("res://UI/main_menu.tscn");
		get_tree().change_scene_to_packed(loading_screen);
	

func _on_character_timer_timeout():
	if str_index < strArr.size():
		if char_index < len(strArr[str_index]):		
			printed_str += strArr[str_index][char_index];
			label.text = printed_str; 
			char_index+=1;
		else:
			if not  i_var:
				string_change_timer.set_wait_time(1);
				string_change_timer.start();
				i_var = true;
			
	else:
		type_char_timer.stop();



func _on_timer_timeout():
	printed_str = "";
	label.text = "";
	char_index = 0;
	str_index+=1;
	string_change_timer.stop();
