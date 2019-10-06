extends KinematicBody2D

export var max_speed_default: = Vector2(120.0, 350.0) 	#speed clamp X & Y
export var acceleration_default: = Vector2(240, 1000.0)	#Acceleration & gravity
export var jump_impulse: = 350.0						#Jump force
export var friction_default: = 0.15						#Slipery stop

const FLOOR_NORMAL: = Vector2.UP

onready var anim_player: = $AnimationPlayer

var acceleration: = acceleration_default
var max_speed: = max_speed_default
var velocity: = Vector2.ZERO
var friction: = friction_default
var direction: = Vector2.DOWN

func get_move_direction(mult:Vector2 = Vector2(1,1)) -> void:
	direction = Vector2(
		(int(Buttons.p1 & Buttons.RIGHT) - int(Buttons.p1 & Buttons.LEFT))*mult.x,
		1.0 * mult.y
	)

func apply_velocity(delta)->bool:
	velocity = calculate_velocity(delta)
	if is_on_floor() && int(Buttons.p1 & Buttons.JUMP):
		velocity.y = -jump_impulse
		return true
	return false

func apply_physics(delta)->void:
	velocity = move_and_slide(velocity, FLOOR_NORMAL, false, 4, PI/4, false)

func calculate_velocity(delta: float) -> Vector2:
	var new_velocity: = velocity #Use temporary variable in case we want to manipulate the value later
	#HORIZONTAL
	if direction.x!=0:
		new_velocity.x += direction.x * acceleration.x * delta
		new_velocity.x = clamp(new_velocity.x, -max_speed.x, max_speed.x)
	else: #deaccelerate X
		new_velocity.x = approach(new_velocity.x, 0, abs(new_velocity.x*friction))
	
	#VERTICAL
	new_velocity.y += acceleration.y * delta
	new_velocity.y = clamp(new_velocity.y, -max_speed.y, max_speed.y)
	return new_velocity

static func approach(start: float, end: float, amount: float):
	if (start < end):
		return min(start + amount, end)
	else:
		return max(start - amount, end)
