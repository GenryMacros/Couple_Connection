extends CharacterBody3D


var item: Node
var SPEED = ProjectSettings.get_setting("Player/speed")
var gravity = ProjectSettings.get_setting("World/gravity")
var is_stopped = false
var has_item = false
var pickup_pressed = false
var is_first_person = false
var timer = null
var camera_switch_delay = .5
var can_switch = true
var can_walk = true
var players = []
@onready var item_placeholder: Node = get_node("visuals/item_placeholder")
@onready var camera_point = $camera_point
@onready var couple_character = $visuals/couple_character/AnimationPlayer
@onready var visuals = $visuals
@onready var player_interaction_area_position :Marker3D = $visuals/PlayerInteractionAreaPosition
@onready var camera_point_first = $camera_point_first
@onready var camera_3d = $camera_point_first/Camera3D
@onready var spot_light_3d: SpotLight3D= $visuals/SpotLight3D


	
func _ready():
	GameManager.set_player(self)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	NotesAndInteractionService.pickup_item.connect(_on_item_pick_up)
	
	var collisionDetectionArea = get_node("visuals/CollisionDetectionArea")
	collisionDetectionArea.body_entered_signal.connect(_on_collision_detection_entered)
	collisionDetectionArea.body_exited_signal.connect(_on_collision_detection_exited)
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(camera_switch_delay)
	timer.timeout.connect(_on_timeout_complete)
	add_child(timer)
	
	var player = get_parent().get_node("Player")
	#var player2 = get_parent().get_node("Player2")
	#if player and player2:
	#	players.append(player) 
	#	players.append(player2)

func activate_first_person():
	is_first_person = true
	spot_light_3d.spot_angle = 30
	spot_light_3d.light_energy = 10
	
func _on_timeout_complete():
	can_switch = true

func _start_switch_delay():
	can_switch = false
	timer.start()
	
func _physics_process(delta):
	if is_stopped:
		return
	
	if	Input.is_action_pressed("camera_switch") and can_switch and !players.is_empty():
		if GameManager.player == self:
			_start_switch_delay()
			for player in players:
				if player != self:
					GameManager.set_player(player)
					player._start_switch_delay()
	
	if has_item and Input.is_action_pressed("item_pickup") and !pickup_pressed:
		pickup_pressed = true
		var main_node = get_parent()
		item_placeholder.remove_child(item)
		item.position = item_placeholder.global_transform.origin
		item.gravity_scale = gravity
		has_item = false
		main_node.add_child(item)
		item = null
	elif !Input.is_action_pressed("item_pickup"):
		pickup_pressed = false
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	
	if is_first_person:
		#velocity.y += gravity * delta
		var desired_velocity = get_input_first_person() * SPEED

		velocity.x = desired_velocity.x
		velocity.z = desired_velocity.z
		if velocity.x != 0 or velocity.z != 0:
			couple_character.play("Movement")
		else:
			couple_character.stop()
		move_and_slide()
	else:
		var input_dir = Input.get_vector("backward", "forward", "left", "right")
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			#var new_position = position + direction * 1
			#if !is_collision(new_position, item_placeholder.global_transform.origin):
			visuals.look_at(direction + position)
			if can_walk || !has_item:
				velocity.x = direction.x * SPEED
				velocity.z = direction.z * SPEED
			else:
				velocity = Vector3(0,0,0)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
		
		if velocity.x != 0 or velocity.z != 0:
			couple_character.play("Movement")
		else:
			couple_character.stop()
		move_and_slide()

func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * 0.002)
		camera_3d.rotate_x(-event.relative.y * 0.002)
		camera_3d.rotation.x = clamp(camera_3d.rotation.x, -PI /2 , PI / 2)
		
			
func get_input_first_person():
	var input_dir = Vector3()
	# desired move in camera direction
	if Input.is_action_pressed("forward"):
		input_dir += -global_transform.basis.z
	if Input.is_action_pressed("backward"):
		input_dir += global_transform.basis.z
	if Input.is_action_pressed("left"):
		input_dir += -global_transform.basis.x
	if Input.is_action_pressed("right"):
		input_dir += global_transform.basis.x
	input_dir = input_dir.normalized()
	return input_dir
	
func _on_item_pick_up(item_node: Node):
	if !has_item:
		var main_node = get_parent()
		main_node.remove_child(item_node)
		item_placeholder.add_child(item_node)
		item_node.position = Vector3(0,0,0)
		item_node.linear_velocity = Vector3(0,0,0)
		item_node.gravity_scale = 0
		has_item = true
		item = item_node
		pickup_pressed = true

func _on_collision_detection_entered():
	can_walk = false

func _on_collision_detection_exited():
	can_walk = true

#func is_collision(start: Vector3, end: Vector3) -> bool:
	#var space_state = get_world_3d().direct_space_state
	#var query = PhysicsRayQueryParameters3D.create(start, end)
#
	#var result = space_state.intersect_ray(query)
	#print(result)
	#return result.collider != null
