extends Node2D
class_name RaycastBullet

export (float) var speed: float = 120.0 *60
export (float) var speedFall: float = 10.0
export (float) var fadeTime: float = 0.5
export (float) var lifeTime:float = 0.3
export (int) var bounces: int = 6

var pos: Vector2
var dir: Vector2
var rot: float

var traceLine: Array
var time:float
var col: = Color.white

func _draw()->void:
	if !traceLine.empty():
		for i in traceLine.size() -1:
			var t:float = (time - traceLine[i][1]) / fadeTime
			if t <= 1.0:
				var c: = col
				c.a = 1.0 - t
				var p1:Vector2 = traceLine[i][0]
				var p2:Vector2 = traceLine[i+1][0]
				draw_line(p1, p2, c)

func _physics_process(delta:float)->void:
	if bounces > 0 && time < lifeTime && speed > 0.001:
		_bullet_process(delta)
		speed = lerp(speed, 0.0, speedFall * delta)
	time += delta
	if time >= lifeTime + fadeTime:
		queue_free()

# warning-ignore:unused_argument
func _process(delta:float)->void:
	update()

func _bullet_process(delta:float)->void:
	var spaceState: = get_world_2d().direct_space_state
	var remainLength: = speed * delta
	var end: Vector2
	traceLine.append([pos, time])
	var data:Dictionary
	while remainLength > 0.001 && bounces > 0:
		end = pos + dir * remainLength
		data = spaceState.intersect_ray(pos, end)
		if data:
			end = data.position - (data.position - pos).normalized() * 0.01
			dir = dir.bounce(data.normal).normalized()
			bounces -= 1
			#data.collider
		remainLength -= (end - pos).length()
		pos = end
		traceLine.append([pos, time])
