extends Node3D


@onready var player = $Player
@onready var canvas_layer = $Settins/CanvasLayer
@onready var settins = $Settins
@onready var settings_button = $Settins/CanvasLayer/HBoxContainer/MarginContainer/VBoxContainer/VideoSettings/ScreenResolutionOptions


func _ready():
	player.activate_first_person()
	canvas_layer.visible = false

func _input(event):
	if event.is_action_pressed("Exit"):
		if not GameManager.is_game_paused:
			canvas_layer.visible = true
			GameManager.is_game_paused = true
			settings_button.grab_focus();
		else:
			canvas_layer.visible = false
			GameManager.is_game_paused = false
