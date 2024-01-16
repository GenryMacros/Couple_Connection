extends Area3D


@export var music_player: AudioStreamPlayer3D


func _ready():
	music_player.playing = false
	
	
func _on_area_entered(area):
	music_player.playing = !music_player.playing
