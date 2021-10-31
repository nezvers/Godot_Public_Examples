extends Node2D
class_name RaycastBullet

export (float) var speed: float = 120.0 *60
export (float) var speed_fall: float = 10.0
export (float) var fade_time: float = 0.5
export (float) var life_time:float = 0.3
export (int) var bounces: int = 6

var pos: Vector2
var dir: Vector2
var rot: float


var trace_line: Array
var time:float
var col1: = Color.white
var col2: = Color(0.0, 0.0, 0.0, 0.0)

func set_config(config:GunConfig)->void:
	speed = config.speed
	speed_fall = config.speed_fall
	fade_time = config.fade_time
	life_time = config.life_time
	bounces = config.bounces

func _draw()->void:
	if !trace_line.empty():
		for i in trace_line.size() -1:
			var t:float = (time - trace_line[i][1]) / fade_time
			if t <= 1.0:
				var c: = col2.linear_interpolate(col1, 1.0-t)
				var p1:Vector2 = trace_line[i][0]
				var p2:Vector2 = trace_line[i+1][0]
				var thic:float = clamp(4 * (1.0-t*5.0), 1.0, 10.0)
				draw_line(p1, p2, c, thic)

func _physics_process(delta:float)->void:
	if bounces > 0 && time < life_time && speed > 0.001:
		_bullet_process(delta)
		speed = lerp(speed, 0.0, speed_fall * delta)
	time += delta
	if time >= life_time + fade_time:
		queue_free()

# warning-ignore:unused_argument
func _process(delta:float)->void:
	update()

func _bullet_process(delta:float)->void:
	var spaceState: = get_world_2d().direct_space_state
	var remainLength: = speed * delta
	var end: Vector2
	trace_line.append([pos, time])
	var data:Dictionary
	while remainLength > 0.001 && bounces > 0:
		end = pos + dir * remainLength
		data = spaceState.intersect_ray(pos, end)
		if data:
			if data.collider is KinematicBody2D:
				# register hit
				
				data.collider.get_hit({dir = dir})
				end = data.position - (data.position - pos).normalized() * 0.01
				bounces = 0
			else:
				end = data.position - (data.position - pos).normalized() * 0.01
				dir = dir.bounce(data.normal).normalized()
				bounces -= 1
		remainLength -= (end - pos).length()
		pos = end
		trace_line.append([pos, time])
