extends Control

signal correct_pass_entered();
signal pc_exit();

var correct_pass = "1987"
var is_active = false
@onready var pass_slots: Array[TextEdit] = [
	$PcDisplay/Control/TextEdit1,
	$PcDisplay/Control/TextEdit2,
	$PcDisplay/Control/TextEdit3,
	$PcDisplay/Control/TextEdit4
]
var current_pass_slot = 0


func _input(event):
	if is_active:
		if event.is_pressed():
			if event.is_action("Exit"):
				pc_exit.emit()
				is_active = false
				visible = false
				return
				
			var event_as_test: String = event.as_text()
			if event_as_test.is_valid_int():
				fill_next_pass_slot(event_as_test)
		

func fill_next_pass_slot(content: String):
	pass_slots[current_pass_slot].text = content
	current_pass_slot += 1
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
		make_slots_empty()
	else:
		make_slots_empty()
		

func make_slots_empty():
	for slot in pass_slots:
		slot.text = "0"
	current_pass_slot = 0
					

func activate():
	is_active = true
	visible = true
