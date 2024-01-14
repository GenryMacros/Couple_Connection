extends CanvasLayer

signal correct_pass_entered();
signal pc_exit();

var correct_pass = "1987"
var is_active = false
@onready var pass_slots: Array[Label] = [
	$PcDisplay/Control/TextEdit1,
	$PcDisplay/Control/TextEdit2,
	$PcDisplay/Control/TextEdit3,
	$PcDisplay/Control/TextEdit4
]
@onready var pass_caretts: Array[ColorRect] = [
	$PcDisplay/Control/TextEdit1/ColorRect,
	$PcDisplay/Control/TextEdit2/ColorRect,
	$PcDisplay/Control/TextEdit3/ColorRect,
	$PcDisplay/Control/TextEdit4/ColorRect
]

@onready var timer = $Timer

var current_pass_slot = 0


func _ready():
	timer.timeout.connect(carett_visibility_change)
	timer.wait_time = 0.4


func carett_visibility_change():
	if !GameManager.is_game_paused:
		for i in range(len(pass_caretts)):
			if i != current_pass_slot:
				pass_caretts[i].visible = false
		
		var index = current_pass_slot if current_pass_slot < len(pass_caretts) else len(pass_caretts) - 1
		pass_caretts[index].visible = !pass_caretts[index].visible
	
	
func _input(event):
	if is_active and !GameManager.is_game_paused:
		if event.is_pressed():
			if event.is_action("Exit"):
				pc_exit.emit()
				is_active = false
				visible = false
				timer.stop()
				return
				
			var event_as_test: String = event.as_text()
			if event_as_test.is_valid_int():
				fill_next_pass_slot(event_as_test)
		

func fill_next_pass_slot(content: String):
	pass_slots[current_pass_slot].text = content
	current_pass_slot += 1
	carett_visibility_change()
	if current_pass_slot == len(pass_slots):
		check_entered_pass()
		return


func check_entered_pass():
	var entered_pass = ''
	for slot in pass_slots:
		entered_pass += slot.text
	if entered_pass == correct_pass:
		correct_pass_entered.emit()
		visible = false
		timer.stop()
		make_slots_empty()
	else:
		make_slots_empty()
		

func make_slots_empty():
	for slot in pass_slots:
		slot.text = "0"
	current_pass_slot = 0
	carett_visibility_change()
	

func activate():
	timer.start()
	is_active = true
	visible = true
