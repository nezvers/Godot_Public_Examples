shader_type canvas_item;
uniform float percent: hint_range(0.0, 1.0) = 0.0;
uniform vec4 tint: hint_color = vec4(0.0,0.0,0.0,1.0);

void fragment(){
	float max_length = length (vec2(1.0))/2.0;				//Half of the diagonal size
	float dist_from_center = distance(UV.xy, vec2(0.5));	//Distance from center
	float value = dist_from_center/ max_length;				//Get distance percent from center
	float a = ceil((1.0-percent) - value);					//Get alpha
	
	COLOR = vec4(tint.rgb, 1.0 -a);
}