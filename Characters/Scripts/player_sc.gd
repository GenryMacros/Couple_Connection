extends CharacterBody3D


var SPEED = ProjectSettings.get_setting("Player/speed")
var gravity = ProjectSettings.get_setting("World/gravity")


func _physics_process(delta):

	if not is_on_floor():
		velocity.y -= gravity * delta
		
	var input_dir = Input.get_vector("backward", "forward", "left", "right")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
