extends KinematicBody2D
class_name Actor

export (float) var speed: 			= 1.0 * 60.0
export (float) var acceleration:	= 300.0
export (float) var gravity:			= 500.0
export (float) var jump_impulse:	= -250.0

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

onready var body: = $Body
onready var JumpBuffer:Timer = $JumpBuffer

func _ready()->void:
	pass


func direction_logic()->void:
	pass

func velocity_logic(delta:float)->void:
	velocity = velocity.move_toward(Vector2(direction.x * speed, velocity.y), acceleration * delta)
	#velocity.x = direction.x * speed

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
			jump()
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
					jump()
			
#			else:
#				velocity.y += gravity * delta
#		else:
#			velocity.y += gravity * delta
	velocity.y += gravity * delta
	velocity.y = clamp(velocity.y, jump_impulse, velocity.y)

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
	
	is_grounded = temp_grounded

func _physics_process(delta)->void:
	direction_logic()
	velocity_logic(delta)
	gravity_logic(delta)
	collision_logic()
	ground_update_logic()

func _process(delta)->void:
	if abs(direction.x)>= 0.001:
		body.scale.x = direction.x

func damage()->void:
	pass

func jump()->void:
	pass

func land()->void:
	pass




















