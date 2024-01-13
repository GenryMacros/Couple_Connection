extends Node3D

@onready var background_viewport = $base_camera/background_viewport_container/background_viewport
@onready var foreground_viewport = $base_camera/foreground_viewport_container2/foreground_viewport

@onready var background_camera = $base_camera/background_viewport_container/background_viewport/background_camera
@onready var foreground_camera = $base_camera/foreground_viewport_container2/foreground_viewport/foreground_camera

# Called when the node enters the scene tree for the first time.
func _ready():
	resize()


func setup_first_level_shaders():
	$pc/Cube_002.get_active_material(0).get_next_pass().set("shader_param/shine_color", Vector3(0, 0, 0));
	

func resize():
	background_viewport.size = DisplayServer.window_get_size()
	foreground_viewport.size = DisplayServer.window_get_size()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	background_camera.global_transform = GameManager.player.camera_point.global_transform
	foreground_camera.global_transform = GameManager.player.camera_point.global_transform
