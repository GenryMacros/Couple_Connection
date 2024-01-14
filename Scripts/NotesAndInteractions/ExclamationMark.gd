extends Sprite3D
@onready var view_port =  $SubViewport;
@onready var label : Label  = $SubViewport/Label
@onready var labelPos : Marker3D =  $"..";
# Called when the node enters the scene tree for the first time.
func _ready():
	self.texture = view_port.get_texture();
	var camera_pos = GameManager.player.camera_point.global_position;
	var pos = labelPos.global_position - camera_pos;  
	var dw = max(abs(pos.x), absf(pos.z))/8;
	pixel_size *= 1 + (dw);

		
