shader_type canvas_item;
render_mode unshaded;
uniform float percent: hint_range(0.0, 1.0);	//Progress percent value
uniform vec2 pos = vec2(0.5, 0.5);			//Set fade out circle center on screen (percents like UV)
uniform vec2 tex_size = vec2(320.0, 180.0);	//Set screen resolution

void fragment(){
	float longest_side = max(tex_size.x, tex_size.y);
	vec2 aspect_multiplier = vec2(tex_size.x/longest_side, tex_size.y/longest_side);
	//Consistent size
	//float longest_distance = distance(vec2(0.0), aspect_multiplier);
	//Consistent timing (start & end)
	float d1 = distance(pos, vec2(1.0, 0.0));
	float d2 = distance(pos, vec2(0.0 , 1.0));
	float d3 = distance(pos, vec2(1.0 , 1.0));
	float d4 = distance(pos, vec2(0.0 , 0.0));
	float d12 = max(d1,d2);
	float d34 = max(d3,d4);
	float longest_distance = max(d12,d34);
	
	
	float dist_to_center = distance(vec2(pos)*aspect_multiplier, UV*aspect_multiplier);
	float a = step(1.0 -dist_to_center/longest_distance, percent);
	COLOR = vec4(0.0, 0.0, 0.0, a);
}
