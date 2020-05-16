extends KinematicBody2D

export var max_speed_default: = Vector2(120.0, 350.0) 	#speed clamp X & Y
export var acceleration_default: = Vector2(240, 1000.0)	#Acceleration & gravity
export var jump_impulse: = 350.0						#Jump force
export var friction_default: = 0.15						#Slipery stop

const FLOOR_NORMAL: = Vector2.UP
const MAX_FLOOR_ANGLE: float = 25.0		#
const MAX_SLOPE_ANGLE: float = 45.0		#

onready var GroundCheck: = get_node("Rays/GroundCheck")		#
onready var SlopeCheck1 = get_node("Rays/SlopeCheck1")		#
onready var SlopeCheck2 = get_node("Rays/SlopeCheck2")		#

var acceleration: = acceleration_default
var max_speed: = max_speed_default
var velocity: = Vector2.ZERO
var friction: = friction_default
var direction: = Vector2.DOWN
var has_contact: = false		#
var gravity_ratio: float = 1	#

func _ready():
	GroundCheck.enabled = true	#
	SlopeCheck1.enabled = true	#
	SlopeCheck2.enabled = true	#

func _physics_process(delta):
	#Slope collision as Capsule
	if SlopeCheck1.is_colliding() && rad2deg(acos(SlopeCheck1.get_collision_normal().dot(Vector2(0,-1)))) > 0:
		$Rect.disabled = true
#		var n: Vector2 = SlopeCheck1.get_collision_normal()
#		var floor_angle: float = rad2deg(acos(n.dot(Vector2(0,-1))))
#		if floor_angle > 0:
#			rectangle.disabled = true
	elif SlopeCheck2.is_colliding() && rad2deg(acos(SlopeCheck2.get_collision_normal().dot(Vector2(0,-1)))) > 0:
		$Rect.disabled = true
	else:
		$Rect.disabled = false
	
	# Slope gravity
	if is_on_floor():
		has_contact = true
		var n: Vector2 = GroundCheck.get_collision_normal()
		var floor_angle: float = rad2deg(acos(n.dot(Vector2(0,-1))))
		if floor_angle > MAX_FLOOR_ANGLE:
			gravity_ratio = (floor_angle-MAX_FLOOR_ANGLE)/(MAX_SLOPE_ANGLE-MAX_FLOOR_ANGLE) *0.3 #multiplier depending on you default gravity acceleration
		else:
			gravity_ratio = 0.1
	else:
		if !GroundCheck.is_colliding():
			has_contact = false
		gravity_ratio = 1
	
	#Physics
	direction = get_move_direction()
	velocity = calculate_velocity(delta)
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = -jump_impulse
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
	new_velocity.y += acceleration.y * delta * gravity_ratio
	new_velocity.y = clamp(new_velocity.y, -max_speed.y, max_speed.y)
	return new_velocity

static func get_move_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		1.0
	)

static func approach(start: float, end: float, amount: float):
	if (start < end):
	    return min(start + amount, end)
	else:
	    return max(start - amount, end)
