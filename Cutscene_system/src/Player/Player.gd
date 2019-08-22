extends KinematicBody2D

const speed:float = 120.0
var can_move: = true

func _process(delta:float)->void:
	if !can_move:
		return
	var vec = Vector2()
	vec.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	vec.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	translate(vec*speed*delta)