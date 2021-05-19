extends KinematicBody

export (float) var grav:float = 20.0
export (float) var runSpd:float = 8.0
export (float) var walkSpd:float = 4.0
export (float) var crouchSpd:float = 2.0
export (float) var accDefault:float = 8.0
export (float,1) var airControl:float = 0.6
export (float) var jumpPower:float = 10.0

export (float) var mouseSensitivity:float = 0.3


onready var standShape: = $StandShape
onready var crouchShape: = $CrouchShape
onready var headCheck: = $HeadCheck
onready var body: = $Body
onready var cam: = $Body/Camera
onready var rRay: = $Body/RightRay
onready var lRay: = $Body/LeftRay
onready var frontRay: = $Body/FrontRay
onready var jumpBuffer: = $JumpBuffer
onready var tween: = $Tween
onready var sm: = $StateMachine

const snapLength: = 0.2
const vecH: = Vector3(1.0,0.0,1.0)
var snap: = Vector3.ZERO

var acc: = accDefault
var velocity: = Vector3.ZERO
var spd: = runSpd
var gravMult: = 1.0
var wallGravMult: = 0.4
var dir: = Vector3.ZERO
var floorNormal: = Vector3.UP
var jumpRelease:float = jumpPower *0.5
var extraJumps: = 1	# extras jumps
var jumpCount: = 0
var camRotX: = 0.0
var mouseCaptured: = false

var isGrounded: = false
var isJumping: = false


var btnRight:float
var btnLeft:float
var btnUp:float
var btnDown:float
var btnJump: = false
var btnRun: = false
var btnCrouch: = false

func _ready():
# warning-ignore:return_value_discarded
	Events.connect("mouse_capture", self, "mouse_capture")
	Events.mouseCaptured = true
	sm.start("Idle")

func input(event:InputEvent):
	if event is InputEventMouseMotion:
		if mouseCaptured:
			rotate_y(deg2rad(-event.relative.x * mouseSensitivity))
		
			var xDelta = event.relative.y * mouseSensitivity
			if camRotX + xDelta > -90 and camRotX + xDelta < 90: 
				cam.rotate_x(deg2rad(-xDelta))
				camRotX += xDelta
	elif event.is_action("move_up"):
		btnUp = Input.get_action_strength("move_up")
	elif event.is_action("move_right"):
		btnRight = Input.get_action_strength("move_right")
	elif event.is_action("move_left"):
		btnLeft = Input.get_action_strength("move_left")
	elif event.is_action("move_down"):
		btnDown = Input.get_action_strength("move_down")
	elif event.is_action_pressed("jump"):
		btnJump = true
	elif event.is_action_released("jump"):
		btnJump = false
	elif event.is_action("run") && !event.is_echo():
		btnRun = event.is_action_pressed("run")
	elif event.is_action("crouch") && !event.is_echo():
		btnCrouch = event.is_action_pressed("crouch")



func physics(delta:float)->void:
	get_dir()
	get_movement(delta)
	get_gravity(delta)
	apply_movement()
	ground_check()

func physics_ground(delta:float)->void:
	get_dir()
	get_movement(delta)
	get_gravity_ground(delta)
	apply_movement()
	ground_check()

func physics_air(delta:float)->void:
	get_dir()
	get_movement_air(delta)
	get_gravity_air(delta)
	velocity = move_and_slide_with_snap(velocity, snap, Vector3.UP)
	ground_check()


func mouse_capture()->void:
	mouseCaptured = Events.mouseCaptured

func get_dir()->void:
	var basis:Basis = transform.basis
	dir = Vector3.ZERO
	dir += (btnDown - btnUp) * basis.z
	dir += (btnRight - btnLeft) * basis.x
	dir = dir.normalized()

func get_movement(delta:float)->void:
	velocity = velocity.linear_interpolate(dir *spd +(velocity *Vector3.UP), acc *delta)

func get_movement_air(delta:float)->void:
	velocity = velocity.linear_interpolate(dir *spd +(velocity *Vector3.UP), acc *delta *airControl)

func apply_movement()->void:
	var tempVelocity: = velocity
	tempVelocity = move_and_slide_with_snap(velocity +(get_floor_velocity() *vecH), snap, Vector3.UP)
	#check if standing on moving platform 
	for i in get_slide_count():
		var col: = get_slide_collision(i)
		#don't apply returned velocity
		if col.collider.collision_layer == 2:
			velocity.y = 0.0
			return
	velocity = tempVelocity

func get_gravity(delta:float)->void:
	if isGrounded:
		velocity -= floorNormal *grav *delta *gravMult
		if isJumping:
			btnJump = false
			isJumping = false
		elif !isJumping && btnJump:
			set_jump()
	else:
		velocity.y -= grav *delta *gravMult
		if isJumping:
			if !btnJump:
				isJumping = false
				if velocity.y > jumpRelease:
					velocity.y = jumpRelease
		else:
			if btnJump:
				if !jumpBuffer.is_stopped():
					set_jump()
				elif jumpCount < extraJumps:
					jumpCount += 1
					set_jump()
		velocity.y = max(velocity.y, -jumpPower)

func get_gravity_ground(delta:float)->void:
	velocity -= floorNormal *grav *delta *gravMult
	if isJumping:
		btnJump = false
		isJumping = false
	elif !isJumping && btnJump:
		set_jump()

func get_gravity_air(delta:float)->void:
	velocity.y -= grav *delta *gravMult
	if isJumping:
		if !btnJump:
			isJumping = false
			if velocity.y > jumpRelease:
				velocity.y = jumpRelease
	else:
		if btnJump:
			if !jumpBuffer.is_stopped():
				set_jump()
			elif jumpCount < extraJumps:
				jumpCount += 1
				set_jump()
	velocity.y = max(velocity.y, -jumpPower)

func set_jump()->void:
	velocity.y = jumpPower
	isJumping = true
	isGrounded = false
	floorNormal = Vector3.UP
	snap = Vector3.ZERO
	jumpBuffer.stop()
	jumping_event()

func ground_check()->void:
	var new_is_grounded: = false
	if is_on_floor():
		floorNormal = get_floor_normal()
		snap = -floorNormal *snapLength
		new_is_grounded = true
		
	
	if isGrounded && !new_is_grounded:
		if !btnJump:
			jumpBuffer.start()
	elif !isGrounded && new_is_grounded:
		jumpCount = 0
		landing_event()
	
	isGrounded = new_is_grounded
	if !isGrounded:
		floorNormal = Vector3.UP
		snap = Vector3.ZERO


func jumping_event()->void:
	pass

func landing_event()->void:
	pass
