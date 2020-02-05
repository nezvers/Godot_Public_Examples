extends KinematicBody2D

var speed = 3 * 60
var can_move:bool = true

func _physics_process(delta):
	if !can_move:
		return
	var dir = Vector2()
	dir.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	dir.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	translate(dir * speed * delta)
