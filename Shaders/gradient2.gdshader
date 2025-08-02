shader_type canvas_item;

uniform vec4 start_color : source_color = vec4(0, 0, 0, 1);
uniform vec4 end_color : source_color = vec4(1, 1, 1, 1);

uniform float gradient_start : hint_range(0, 0.999) = 0;
uniform float gradient_end : hint_range(0.001, 1) = 1;

void vertex() {
}

void fragment() {
	float lerp_total = gradient_end - gradient_start;
	float lerp_value = (UV.x - gradient_start) / lerp_total;
	
	COLOR = mix(start_color, end_color, lerp_value);
}
