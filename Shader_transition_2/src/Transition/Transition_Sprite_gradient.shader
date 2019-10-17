shader_type canvas_item;
uniform float percent: hint_range(0.0, 1.0) = 0.0;
uniform vec4 tint: hint_color = vec4(0.0,0.0,0.0,1.0);

/*
Create Transition sprite with gradient using all vec4 floats.
Recommended to start with transparent black.
*/

void fragment(){
	vec4 px = texture(TEXTURE, UV);						//Pixel color
	float value = (px.r + px.g + px.b + px.a) / 4.0;	//Normalized sum
	float alpha = step(value, percent);
	COLOR = vec4(tint.r, tint.g, tint.b, alpha);
}