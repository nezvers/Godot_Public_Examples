extends KinematicBody2D

export(float) var spd:float = 2.0 * 60

onready var body: = $Body

var moveDir: Vector2

# warning-ignore:unused_argument
func _physics_process(delta:float)->void:
	moveDir = Vector2.ZERO
	moveDir.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	moveDir.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
# warning-ignore:return_value_discarded
	move_and_slide(moveDir * spd)

# warning-ignore:unused_argument
func _process(delta:float)->void:
	body.rotation = get_local_mouse_position().angle()
