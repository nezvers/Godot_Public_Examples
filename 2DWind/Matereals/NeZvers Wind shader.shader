shader_type canvas_item;
render_mode unshaded;

uniform vec3 u_strength = vec3(5.0, 2.5, 2.5);
uniform float u_speed = 1.0;
uniform vec2 u_offset = vec2(0.0, 0.0);

const float PI = 3.14159265;
const float x2y = 0.4;		//ratio of vertical movement when goes to sides

float value_percent(float _min, float _max, float value)
{
	return value-_min/_max-_min;
}

void vertex(){        //fragment shader
	float t = TIME * u_speed;
	float h = sin(t * PI);											//movement horizontal value - sin because in middle on speed = 0.0;
	float v = cos(t * 0.5 * PI);									//movement vertical value
	vec2 sig = sign(VERTEX);										//positive or negative vertex point
	float v_mult = sig.y-1.0;										//for disabling lower part movement
	
	float zScale = abs(u_offset.y) / abs(VERTEX.y)*2.0;
	float z_mult = zScale * -(sign(u_offset.y)*0.5+1.0);			//for scaling in and out of fake Z axis
    
	VERTEX.x += ((h * u_strength.x - u_offset.x) + (h * u_strength.x - u_offset.x) * z_mult)* v_mult;											//skewing on h movement
	VERTEX.y += (((-h * u_strength.x * x2y + u_offset.x * x2y) * sig.x) + ((-h * u_strength.x * x2y + u_offset.x * x2y) * sig.x) * z_mult) * v_mult;	//skewing on h movement + fake z axis movement from offset
	VERTEX.y +=  -abs(u_offset.y) * v_mult;		//Fake Z axis
} 