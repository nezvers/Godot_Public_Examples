extends Node2D

enum {IDLE, FLY, STICK}
export (float) var throw_speed = 2 * 60
onready var parent: = get_parent()
var state: int = IDLE
var velocity: = Vector2.ZERO
var pos: = Vector2.ZERO
var spin_speed: float = 4*360

func _ready()->void:
	idle_position()

func _physics_process(delta):
	match state:
		IDLE:
			idle()
		FLY:
			fly(delta)
		STICK:
			stick(delta)

func idle()->void:
	look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("click"):
		throw()

func fly(delta:float)->void:
	pos += velocity*delta #variable for disconnecting from parent movement
	global_position = pos
	#spin
	rotation_degrees += spin_speed*delta

func stick(delta:float)->void:
	#place for your solution
	var target: = get_target()
	var dist = global_position.distance_to(target)
	if dist < throw_speed * delta:
		idle_position()
	else:
		pos = pos.linear_interpolate(target, (throw_speed * delta)/dist)
	global_position = pos
	#spin
	rotation_degrees += spin_speed*delta

func throw()->void:
	state = FLY
	$Timer.start()
	velocity = (get_global_mouse_position() - global_position).normalized() * throw_speed
	pos = global_position #variable for disconnecting from parent movement

func idle_position()->void:
	state = IDLE
	global_position = get_target()

func get_target()->Vector2:
	return parent.global_position + Vector2(0,-2)

func _on_Timer_timeout()->void:
	state = STICK
