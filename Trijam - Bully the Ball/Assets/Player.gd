extends RigidBody

export var MOVE_SPEED : float = 15.0
export var H_LOOK_SENS : float = 0.1
onready var cam = $Cam

func death():
	get_tree().reload_current_scene()

func _input(event):	#rotate player with mouse
	if event is InputEventMouseMotion:
		cam.rotation_degrees.y -= event.relative.x * H_LOOK_SENS
	#pass

func _physics_process(delta : float) -> void:
	#SET MOUSE CAPTURE
	if Input.is_action_just_pressed("escape"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#restart
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
	
	#Turn
	var turn = Input.get_action_strength("right") - Input.get_action_strength("left")
	#rotation_degrees.y -= turn * 90 * delta
	
	#Move input
	var move_vec = Vector3()
	if Input.is_action_just_pressed("up"):
		move_vec.z -= 1
	if Input.is_action_just_pressed("down"):
		move_vec.z += 1
	if move_vec.z == 0:
		return
	#Get direction
	move_vec = move_vec.rotated(Vector3(0, 1, 0), cam.rotation.y)
	move_vec *= MOVE_SPEED
	apply_impulse(Vector3(), move_vec)
	
