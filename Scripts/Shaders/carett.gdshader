shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, repeat_disable, filter_linear;

void fragment( )
{
	vec3 color = texture(SCREEN_TEXTURE, SCREEN_UV).rgb;	
	COLOR = vec4(color, 0.5);
}