extends CharacterBody3D

var item_placeholder: Node = null
var SPEED = ProjectSettings.get_setting("Player/speed")
var gravity = ProjectSettings.get_setting("World/gravity")
@onready var camera_point = $camera_point
@onready var couple_character = $visuals/couple_character/AnimationPlayer
@onready var visuals = $visuals


func _ready():
	GameManager.set_player(self)
	NotesAndInteractionService.pickup_item.connect(_on_item_pick_up)
	
func _physics_process(delta):

	if not is_on_floor():
		velocity.y -= gravity * delta
		
	var input_dir = Input.get_vector("backward", "forward", "left", "right")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		visuals.look_at(direction + position)
		
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

func _on_item_pick_up(item_node: Node):
	item_placeholder = get_node("item_placeholder")
	item_placeholder.add_child(item_node)
	item_node.position = item_placeholder.position
	item_node.gravity_scale = 0
	print("Works")
	print(item_placeholder.position)
	print(item_node.name)
