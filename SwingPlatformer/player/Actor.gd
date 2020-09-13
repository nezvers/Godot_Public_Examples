extends KinematicBody2D
class_name Actor

export (float) var speed: 			= 1.0 * 60.0
export (float) var acceleration:	= 300.0
export (float) var gravity:			= 4.8 * 60
export (float) var jump_impulse:	= -180.0


var move_right:		= 0.0
var move_left:		= 0.0
var move_up:		= 0.0
var move_down:		= 0.0
var direction:		= Vector2.ZERO
var velocity:		= Vector2.ZERO
var jump_release:	= jump_impulse * 0.2
var jump:			= false
var is_jumping:		= false
var is_grounded:	= false
const SNAP: 		= Vector2.DOWN * 1
var snap:			= Vector2.ZERO

var max_jump:int	= 0
var jump_count:int	= 0

onready var body: = $Body						#Parent node for Sprite and RayCast2D
onready var JumpBuffer:Timer = $JumpBuffer		#timer


func direction_logic()->void:
	direction.x = move_right - move_left
	direction.y = move_down - move_up

func velocity_logic(delta:float)->void:
	velocity = velocity.move_toward(Vector2(direction.x * speed, velocity.y), acceleration * delta)

func gravity_logic(delta:float)->void:
	if is_grounded:
		if is_jumping:								#landed the jump
			jump = false							#force release jump button
			is_jumping = false
			snap = SNAP
		elif !is_jumping && jump:					#works also when re-pressed before ground for jump buffer (pre-landing)
			velocity.y = jump_impulse
			is_jumping = true
			is_grounded = false
			snap = Vector2.ZERO
			jumping()
			JumpBuffer.stop()
	else:
		if is_jumping:
			if !jump:								#released jump button mid-air
				is_jumping = false
				if velocity.y < jump_release:
					velocity.y = jump_release
		else:
			if jump:
				if !JumpBuffer.is_stopped():
					JumpBuffer.stop()
					velocity.y = jump_impulse
					is_jumping = true
					is_grounded = false
					snap = Vector2.ZERO
					jumping()
#----------This works for moving platforms but slides down the slopes
#			else:
#				velocity.y += gravity * delta
#		else:
#			velocity.y += gravity * delta
#----------This stops sliding down the slopes but doesn't stick to moving platforms
	velocity.y += gravity * delta	# <---
	
	velocity.y = max(velocity.y, jump_impulse)	#Limit fall speed to same as Jumping, but allow get faster to go up

func ground_gravity_logic(delta:float)->void:
	if is_grounded:
		if is_jumping:								#landed the jump
			jump = false							#force release jump button
			is_jumping = false
			snap = SNAP
		elif !is_jumping && jump:					#works also when re-pressed before ground for jump buffer (pre-landing)
			velocity.y = jump_impulse
			is_jumping = true
			is_grounded = false
			snap = Vector2.ZERO
			jumping()
	velocity.y += gravity * delta
	velocity.y = max(velocity.y, jump_impulse)

func air_gravity_logic(delta:float)->void:
	if is_jumping:
		if !jump:								#released jump button mid-air
			is_jumping = false
			if velocity.y < jump_release:
				velocity.y = jump_release
	elif jump && !JumpBuffer.is_stopped():
		JumpBuffer.stop()
		velocity.y = jump_impulse
		is_jumping = true
		is_grounded = false
		jumping()
	velocity.y += gravity * delta
	velocity.y = max(velocity.y, jump_impulse)

func collision_logic()->void:
	velocity = move_and_slide_with_snap(velocity, snap, Vector2.UP, true)

func ground_update_logic()->void:
	var temp_grounded: = is_on_floor()
	if is_grounded && !temp_grounded:					#just lost ground
		snap = Vector2.ZERO
		if !jump:
			JumpBuffer.start()
	elif !is_grounded && temp_grounded:					#just landed
		snap = SNAP
		jump_count = 0									#resets double jump count
		land()
	
	is_grounded = temp_grounded

func physics_process(delta:float)->void:
	direction_logic()
	velocity_logic(delta)
	gravity_logic(delta)
	collision_logic()
	ground_update_logic()

func ground_physics_process(delta:float)->void:
	direction_logic()
	velocity_logic(delta)
	gravity_logic(delta)
	collision_logic()
	ground_update_logic()

func air_physics_process(delta:float)->void:
	direction_logic()
	velocity_logic(delta)
	gravity_logic(delta)
	collision_logic()
	ground_update_logic()

func process(_delta:float)->void:
	if abs(direction.x)>= 0.001:
		body.scale.x = direction.x

func damage()->void:
	pass

func jumping()->void:
	pass

func land()->void:
	pass




















