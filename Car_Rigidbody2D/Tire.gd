extends RigidBody2D

const DEG2RAD = 0.0174532925199432957

var steering_com = 0.0
var force_com = 0.0
const add_steering = 20
const max_steering = 150
const add_force = 1
const max_force = 12
const TDC_LEFT = 0x1
const TDC_RIGHT = 0x2
const TDC_UP = 0x4
const TDC_DOWN = 0x8
var m_controlState = 0

func get_input():
	if Input.is_action_just_pressed("left"):
		m_controlState |= TDC_LEFT
	if Input.is_action_just_pressed("right"):
		m_controlState |= TDC_RIGHT
	if Input.is_action_just_pressed("up"):
		m_controlState |= TDC_UP
	if Input.is_action_just_pressed("down"):
		m_controlState |= TDC_DOWN
	if Input.is_action_just_released("left"):
		m_controlState &= ~TDC_LEFT
	if Input.is_action_just_released("right"):
		m_controlState &= ~TDC_RIGHT
	if Input.is_action_just_released("up"):
		m_controlState &= ~TDC_UP
	if Input.is_action_just_released("down"):
		m_controlState &= ~TDC_DOWN

func apply_input():
	match (m_controlState & (TDC_UP|TDC_DOWN)):
		TDC_UP:
			force_com += add_force
		TDC_DOWN:
			force_com += -add_force
		_:
			force_com = lerp(force_com, 0, 0.1)
	force_com = clamp(force_com, -max_force, max_force)
	print(force_com)
	match (m_controlState & (TDC_RIGHT|TDC_LEFT)):
		TDC_RIGHT:
			steering_com += add_steering
		TDC_LEFT:
			steering_com -= add_steering
		_:
			steering_com = lerp(steering_com, 0, 0.1)
	steering_com = clamp(steering_com, -max_steering, max_steering)

func update_drive():
	var tf = get_global_transform()
	var vel = get_linear_velocity()
	#   get the orthogonal velocity vector
	var right_vel = tf.x * tf.x.dot(vel)
	#   decrease the force in proportion to the velocity to stop endless acceleration
	var force = force_com - force_com * clamp(vel.length() / 400.0, 0.0, 1.0)
	var steering_torque = steering_com
	if tf.y.dot(vel) < 0.0:
	#   if reversing, reverse the steering
		steering_torque = -steering_com
	#   make reversing much slower
		if force_com <= 0.0:
			force *= 0.3
	#   apply the side force, the lower this is the more the car slides
	#   make the sliding depend on the power command somewhat
	if force!=0:
		apply_impulse(Vector2(), -right_vel * 0.15 * clamp(1.0 / abs(force), 0.01, 1.0))
	#  
	apply_impulse(Vector2(), tf.basis_xform(Vector2(0, force)))
	#   scale the steering torque with velocity to prevent turning the car when not moving
	set_applied_torque(steering_torque * vel.length() / 200.0)

func _physics_process(delta):
	get_input()
	apply_input()
	update_drive()
