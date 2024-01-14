extends Node3D


@onready var couple_character_anti = $visuals/couple_character_anti/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	couple_character_anti.play("Movement")
	couple_character_anti.stop()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	look_at(GameManager.player.position)
	
