shader_type canvas_item;

uniform float lerp_percent : hint_range(0.0, 1.0, 0.1);

void fragment() {
	vec4 texture_colour = texture(TEXTURE, UV);
	vec4 final_colour = mix(texture_colour, vec4(1.0, 1.0, 1.0, texture_colour.a), lerp_percent);
	COLOR = final_colour;
}
