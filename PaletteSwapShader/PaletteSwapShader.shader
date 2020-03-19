shader_type canvas_item;
render_mode unshaded;

uniform sampler2D palette;      //Use pallete collection in rows
uniform float paletteCount = 38;   //row count
uniform float previous = 0.0;        //for blending option
uniform float next = 0.0;
uniform float blend = 1.0;

void fragment(){
	float color = texture(TEXTURE, UV).r;					//Original grayscale color as collumn index
	
	float dist = 1.0 / paletteCount;			//between rows
	
	float oldRow = dist * previous + dist*0.5;	//row for old color + imprecision buffer
	vec4 oldColor = texture(palette, vec2(color, oldRow));
	
	float newRow = dist * next + dist*0.5;		//row for new 
	vec4 newColor = texture(palette, vec2(color, newRow));
	
	COLOR = mix(oldColor, newColor, blend);						//if blending not needed set to new color
}