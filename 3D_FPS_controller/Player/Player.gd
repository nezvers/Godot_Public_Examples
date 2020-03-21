extends KinematicBody

export (float) var gravity = 0.5
export (float) var speed = 10
export (float) var acceleration = 15
export (float,1) var air_control = 0.6
export (float) var jump_power = 10
export (float) var walljump_power = 9
export (float) var climb_power = 15

export (float) var mouse_sensitivity = 0.3
#--------ABILITIES---------
export (float) var can_wallrun = true

const SNAP: = Vector3.DOWN * 0.2

onready var body: = $Body
onready var camera: = $Body/Camera
onready var rightRay: = $Body/RightRay
onready var leftRay: = $Body/LeftRay
onready var frontRay: = $Body/FrontRay

var velocity: = Vector3.ZERO
var snap: = Vector3.ZERO
var gravityMultiplier = 1
var wallGravityMult = 0.4
var camera_x_rotation = 0
var mouseCaptured: = false

#-------STATES-----------
var is_wallrunning: = false

#-------TOGGLES----------
var can_walljump: = true

func _ready():
	toggle_mouse_capture()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		toggle_mouse_capture()
	if mouseCaptured && event is InputEventMouseMotion:
		body.rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))

		var x_delta = event.relative.y * mouse_sensitivity
		if camera_x_rotation + x_delta > -90 and camera_x_rotation + x_delta < 90: 
			camera.rotate_x(deg2rad(-x_delta))
			camera_x_rotation += x_delta

func _physics_process(delta)->void:
	var basis:Basis = body.get_global_transform().basis
	var direction: = Vector3.ZERO
	direction += (Input.get_action_strength("move_down") - Input.get_action_strength("move_up")) * basis.z
	direction += (Input.get_action_strength("move_right") - Input.get_action_strength("move_left")) * basis.x
	direction = direction.normalized() * speed
	direction.y = velocity.y
	
	
	if is_on_floor():
		velocity = velocity.move_toward(direction, acceleration * delta)
		snap = SNAP
		#can_walljump = true
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_power
			snap = Vector3.ZERO
	else:
		velocity = velocity.move_toward(direction, acceleration * air_control * delta)
		snap = Vector3.ZERO
		if can_wallrun:
			wallrun()
		if !Input.is_action_pressed("jump") && velocity.y > jump_power*0.5:	#shorten jump on release
			velocity.y = jump_power * 0.5
		velocity.y -= gravity * gravityMultiplier
		climb()
	
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
		rayNormal = rightRay.get_global_transform().basis.x
	elif leftRay.is_colliding():
		wallNormal = leftRay.get_collision_normal()
		rayNormal = leftRay.get_global_transform().basis.x
	
	var dot:float = rayNormal.dot(wallNormal)	#use dot product for wall angle matching
	if dot < -0.8:								#treshold for wallrunning
		gravityMultiplier = wallGravityMult
		if Input.is_action_just_pressed("jump") && can_walljump:
			velocity.y = jump_power
			velocity += wallNormal * walljump_power
			#can_walljump = false
	else:
		gravityMultiplier = 1

func climb()->void:
	if Input.is_action_just_pressed("jump") && frontRay.is_colliding():
		var dist:float = (frontRay.get_collision_point() - frontRay.get_global_transform().origin).length()
		var fullLength:float = frontRay.cast_to.length()
		var multiplier:float = 1 - dist/fullLength
		velocity.y = climb_power * multiplier
