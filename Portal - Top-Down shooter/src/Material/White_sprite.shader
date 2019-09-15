shader_type canvas_item;

uniform float colour_mix;
uniform vec4 color : hint_color = vec4(1,1,1,1);

void fragment() {
    vec4 texture_color = texture(TEXTURE, UV);
	vec3 MIX = mix(texture_color.rgb, color.rgb, colour_mix);
    COLOR = vec4(MIX, texture_color.a);
}