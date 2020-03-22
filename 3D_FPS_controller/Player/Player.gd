extends KinematicBody

export (float) var gravity = 0.5
export (float) var walk_speed = 5
export (float) var run_speed = 10
export (float) var acceleration = 25
export (float,1) var air_control = 0.6
export (float) var jump_power = 10
export (float) var walljump_power = 9
export (float) var climb_power = 15
export (float,1) var crouch_height = 0.4

export (float) var mouse_sensitivity = 0.3
#--------ABILITIES---------
export (float) var can_wallrun = true
export (float) var can_walljump: = true

const SNAP: = Vector3.DOWN * 0.2

onready var standShape: = $StandShape
onready var crouchShape: = $CrouchShape
onready var standCheck: = $StandCheck
onready var body: = $Body
onready var camera: = $Body/Camera
onready var rightRay: = $Body/RightRay
onready var leftRay: = $Body/LeftRay
onready var frontRay: = $Body/FrontRay
onready var tween: = $Tween

var velocity: = Vector3.ZERO
var snap: = Vector3.ZERO
var gravityMultiplier: = 1.0
var wallGravityMult: = 0.4
var camera_x_rotation: = 0.0
var mouseCaptured: = false

#-------STATES-----------
var is_wallrunning: = false
var is_running: = false
var is_crouching: = false setget set_crouching

#------FOR CROUCHING------
var height: float = 1 setget set_height
onready var camera_height:float = camera.translation.y
var solidAbove:int = 0

func _ready():
	toggle_mouse_capture()

func _unhandled_input(event):
	if event is InputEventMouseMotion && mouseCaptured:
		body.rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
	
		var x_delta = event.relative.y * mouse_sensitivity
		if camera_x_rotation + x_delta > -90 and camera_x_rotation + x_delta < 90: 
			camera.rotate_x(deg2rad(-x_delta))
			camera_x_rotation += x_delta
	
	elif event.is_action_pressed("ui_cancel"):
		toggle_mouse_capture()
	
	elif event.is_action_pressed("run"):
		is_running = !is_running
	
	elif event.is_action_pressed("crouch"):
		if is_crouching:
			return
		if tween.is_active():
			return
		tween.interpolate_method(self, "set_height", 1.0, crouch_height, 0.25, Tween.TRANS_QUAD,Tween.EASE_IN)
		tween.start()
		yield(tween, "tween_completed")
		set_crouching(true)
	elif event.is_action_released("crouch"):
		if !is_crouching:
			yield(tween, "tween_completed")
		if solidAbove > 0:
			return
		if tween.is_active():
			return
		tween.interpolate_method(self, "set_height", crouch_height, 1.0, 0.25, Tween.TRANS_QUAD,Tween.EASE_IN)
		tween.start()
		yield(tween, "tween_completed")
		set_crouching(false)

func _physics_process(delta)->void:
	var basis:Basis = body.global_transform.basis
	var direction: = Vector3.ZERO
	direction += (Input.get_action_strength("move_down") - Input.get_action_strength("move_up")) * basis.z
	direction += (Input.get_action_strength("move_right") - Input.get_action_strength("move_left")) * basis.x
	
	if is_running:
		direction = direction.normalized() * run_speed
	else:
		direction = direction.normalized() * walk_speed
	direction.y = velocity.y
	
	if is_on_floor():
		velocity = velocity.move_toward(direction, acceleration * delta)
		snap = SNAP
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_power
			snap = Vector3.ZERO
	else:
		velocity = velocity.move_toward(direction, acceleration * air_control * delta)
		snap = Vector3.ZERO
		if can_wallrun:		#ABILITY
			wallrun()
		if !Input.is_action_pressed("jump") && velocity.y > jump_power*0.5:	#shorten jump on release
			velocity.y = jump_power * 0.5
		velocity.y -= gravity * gravityMultiplier
		velocity.y = max(velocity.y, -jump_power)	#Clamping falling speed and leaving option to jump faster
		climb()				#ABILITY
	
	velocity = move_and_slide_with_snap(velocity, snap, Vector3.UP, true, 4, PI*0.25, false)

func toggle_mouse_capture()->void:
	if mouseCaptured:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		mouseCaptured = false
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		mouseCaptured = true

func wallrun()->void:
	var wallNormal: = Vector3()
	var rayNormal: = Vector3()
	
	if rightRay.is_colliding():
		wallNormal = rightRay.get_collision_normal()
		rayNormal = rightRay.global_transform.basis.x
	elif leftRay.is_colliding():
		wallNormal = leftRay.get_collision_normal()
		rayNormal = leftRay.global_transform.basis.x
	
	var dot:float = rayNormal.dot(wallNormal)	#use dot product for wall angle matching
	if dot < -0.8:								#treshold for wallrunning
		gravityMultiplier = wallGravityMult
		if Input.is_action_just_pressed("jump") && can_walljump:
			velocity.y = jump_power
			velocity += wallNormal * walljump_power
	else:
		gravityMultiplier = 1

func climb()->void:
	if Input.is_action_just_pressed("jump") && frontRay.is_colliding():
		var dist:float = (frontRay.get_collision_point() - frontRay.get_global_transform().origin).length()
		var fullLength:float = frontRay.cast_to.length()
		var multiplier:float = 1 - dist/fullLength
		velocity.y = climb_power * multiplier

func set_crouching(value: bool)->void:
	is_crouching = value
	standShape.disabled = value
	crouchShape.disabled = !value

func set_height(value:float)->void:
	height = value
	camera.translation.y = camera_height*value
	#lazy mesh ducking
	$Body/Scaler.scale.y = value

func _on_StandCheck_body_entered(body):
	solidAbove += 1

func _on_StandCheck_body_exited(body):
	solidAbove -= 1
	if solidAbove == 0 && !Input.is_action_pressed("crouch"):
		tween.interpolate_method(self, "set_height", crouch_height, 1.0, 0.25, Tween.TRANS_QUAD,Tween.EASE_IN)
		tween.start()
		yield(tween, "tween_completed")
		set_crouching(false)
