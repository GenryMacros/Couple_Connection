extends CharacterBody3D


var SPEED = ProjectSettings.get_setting("Player/speed")
var gravity = ProjectSettings.get_setting("World/gravity")
var is_stopped = false
@onready var camera_point = $camera_point
@onready var couple_character = $visuals/couple_character/AnimationPlayer
@onready var visuals = $visuals
@onready var player_interaction_area_position = $PlayerInteractionAreaPosition


func _ready():
	GameManager.set_player(self)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	
func _physics_process(delta):
	if is_stopped:
		return
		
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	var input_dir = Input.get_vector("backward", "forward", "left", "right")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		visuals.look_at(direction + position)
		player_interaction_area_position.look_at(direction + position)
		
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if velocity.x != 0 or velocity.z != 0:
		couple_character.play("Movement")
	else:
		couple_character.stop()
	move_and_slide()
