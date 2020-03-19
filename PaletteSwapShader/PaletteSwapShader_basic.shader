shader_type canvas_item;
render_mode unshaded;

uniform sampler2D palette;			//Use palletes in collum with colors in rows
uniform float paletteCount = 38;	//row count
uniform float next = 0.0;

void fragment(){
	float color = texture(TEXTURE, UV).r;		//Original grayscale color as collumn index
	
	float dist = 1.0 / paletteCount;			//between rows
		
	float newRow = dist * next + dist*0.5;		//row for new  + imprecision buffer
	vec4 newColor = texture(palette, vec2(color, newRow));	//get color from palette
	
	COLOR = newColor;
}