extends KinematicBody

#This controller is pulled out of different project just for demonstration purposes



export (float) var gravity = 0.5
export (float) var walk_speed = 8
export (float) var crouch_speed = 2
export (float) var acceleration = 25
export (float,1) var air_control = 0.6
export (float) var jump_power = 10

export (float) var mouse_sensitivity = 0.5

const SNAP: = Vector3.DOWN * 0.2

onready var body: = $Body
onready var camera: = $Body/Camera

var velocity: = Vector3.ZERO
var snap: = Vector3.ZERO
var gravityMultiplier: = 1.0
var wallGravityMult: = 0.4
var camera_x_rotation: = 0.0
var mouseCaptured: = false


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

func _physics_process(delta)->void:
	var basis:Basis = body.global_transform.basis
	var direction: = Vector3.ZERO
	direction += (Input.get_action_strength("move_down") - Input.get_action_strength("move_up")) * basis.z
	direction += (Input.get_action_strength("move_right") - Input.get_action_strength("move_left")) * basis.x
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
		if !Input.is_action_pressed("jump") && velocity.y > jump_power*0.5:	#shorten jump on release
			velocity.y = jump_power * 0.5
		velocity.y -= gravity * gravityMultiplier
		velocity.y = max(velocity.y, -jump_power)	#Clamping falling speed and leaving option to jump faster
	
	velocity = move_and_slide_with_snap(velocity, snap, Vector3.UP, true, 4, PI*0.25, false)

func toggle_mouse_capture()->void:
	if mouseCaptured:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		mouseCaptured = false
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		mouseCaptured = true
