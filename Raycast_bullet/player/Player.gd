extends KinematicBody2D

export(float) var spd:float = 2.0 * 60
export (float) var accelerate: float = 700.0

onready var body: = $Body
onready var gun:Gun = $Body/Gun

var moveDir: Vector2
var velocity: Vector2
var btnRight: = 0.0
var btnLeft: = 0.0
var btnUp: = 0.0
var btnDown: = 0.0

var isDead: = false

func _input(event:InputEvent)->void:
	if isDead:
		return
	elif event.is_action("move_right"):
		btnRight = Input.get_action_strength("move_right")
	elif event.is_action("move_left"):
		btnLeft = Input.get_action_strength("move_left")
	elif event.is_action("move_down"):
		btnDown = Input.get_action_strength("move_down")
	elif event.is_action("move_up"):
		btnUp = Input.get_action_strength("move_up")
	elif event.is_action_pressed("click"):
		gun.set_shooting(true)
	elif event.is_action_released("click"):
		gun.set_shooting(false)

# warning-ignore:unused_argument
func _physics_process(delta:float)->void:
	moveDir = Vector2.ZERO
	moveDir.x = btnRight - btnLeft
	moveDir.y = btnDown - btnUp
	
	velocity = velocity.move_toward(moveDir * spd, delta * accelerate)
# warning-ignore:return_value_discarded
	velocity = move_and_slide(velocity)

# warning-ignore:unused_argument
func _process(delta:float)->void:
	body.rotation = get_local_mouse_position().angle()

func get_hit(_data: Dictionary)->void:
	if isDead:
		return
	isDead = true
	btnRight = 0.0
	btnLeft = 0.0
	btnUp = 0.0
	btnDown = 0.0
	set_process(false)
	gun.set_shooting(false)
	Engine.time_scale = 0.25
	yield(get_tree().create_timer(0.25), "timeout")
	Engine.time_scale = 1.0
	isDead = false
	set_process(true)
