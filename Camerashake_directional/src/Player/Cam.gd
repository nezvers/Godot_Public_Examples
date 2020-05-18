extends Node2D

onready var cam: = $Camera2D
onready var cam_pos: Vector2 = cam.get_offset()
onready var shake: = $Shake
onready var start_time = OS.get_ticks_msec()
const DEG2RAD = 0.017453
var shoot_strength: float = 32.0
var shake_strength: float = 8.0
var offset: = Vector2.ZERO
var shoot_off: = Vector2.ZERO
var shake_off: = Vector2.ZERO
var mouse_pos: = Vector2.ZERO
var facing: float = 1.0
var shoot: = false
var shaking: = false
var time: float = 0

func _ready():
	pass

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		mouse_pos = event.position
	elif event.is_action_pressed("right_click"):
		shake.start()
		shaking = true
		offset = Vector2(randf(),randf())

func _process(delta):
	var dir: float = owner.get_move_direction().x
	if dir != 0 :
		facing = dir
	
	#Shoot impulse
	if Input.is_action_just_pressed("click"):
		#Facing direction
		#shoot_off = Vector2(32*facing,0)
		
		#Mouse direction
		shoot_off = owner.position.direction_to(get_global_mouse_position()) * shoot_strength
		shoot = true
		
	if shoot:
		var dist: float = Vector2.ZERO.distance_to(shoot_off)
		if dist > 0.1:
			#shoot_off = shoot_off.linear_interpolate(Vector2.ZERO, (shoot_strength*4*delta)/dist)
			shoot_off = shoot_off.linear_interpolate(Vector2.ZERO, 0.1)
		else:
			shoot_off = Vector2.ZERO
			shoot = false
	#Shake
	if shaking:
		if shake.time_left > 0:
			time += delta
			var base: float = PI*20
			var multiply: float = shake_strength*(shake.time_left/shake.wait_time)
			shake_off = Vector2.ZERO + Vector2(cos(time*base+PI*offset.x)*multiply,cos(time*base+PI*offset.y)*multiply)
		else:
			shake_off = Vector2.ZERO
			shaking = false
			time = 0
	#Set position
	if cam_pos+shoot_off+shake_off != cam_pos:
		cam.set_offset(cam_pos+shoot_off+shake_off)
