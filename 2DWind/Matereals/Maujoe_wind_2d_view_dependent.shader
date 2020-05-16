shader_type canvas_item;
render_mode blend_mix, skip_vertex_transform;

// Wind settings.
uniform float speed = 1.0;
uniform float minStrength : hint_range(0.0, 1.0);
uniform float maxStrength : hint_range(0.0, 1.0);
uniform float strengthScale = 100.0;
uniform float interval = 3.5;
uniform float detail = 1.0;
uniform float distortion : hint_range(0.0, 1.0);
uniform float heightOffset = 0.0;

vec2 getWind(mat4 worldMatrix, vec2 vertex, vec2 uv, float timer){
	vec2 pos = (worldMatrix * mix(vec4(1.0), vec4(vertex, 0.0, 1.0), distortion)).xy;
	float time = timer * speed + pos.x * pos.y;
	float diff = pow(maxStrength - minStrength, 2.0);
	float strength = clamp(minStrength + diff + sin(time / interval) * diff, minStrength, maxStrength) * strengthScale;
	float wind = (sin(time) + cos(time * detail)) * strength * max(0.0, (1.0-uv.y) - heightOffset);

	return vec2(wind, wind);
	}

void vertex() {
	vec4 worldPos = WORLD_MATRIX * vec4(VERTEX, 0.0, 1.0);
	worldPos.x += getWind(WORLD_MATRIX, VERTEX, UV, TIME).x;
    VERTEX = (EXTRA_MATRIX * worldPos).xy;
}
