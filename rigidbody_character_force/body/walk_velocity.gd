class_name WalkVelocity
extends Node

@export var body:Body
@export var walk_speed:float = 400
@export var acceleration:float = 3000
@export var deacceleration:float = 500
@export var push_resist:float = 500
@export var move_dir:Vector2


func _physics_process(delta: float) -> void:
	if body.is_pushed:
		speed_down(push_resist * delta)
		return
	if move_dir.length_squared() > 0.01:
		speed_up(acceleration * delta, walk_speed, move_dir.normalized(), delta)
	else:
		speed_down(deacceleration * delta)

func speed_up(strength:float, target_speed:float, dir:Vector2, delta:float)->void:
	var target_velocity:Vector2 = target_speed * dir
	var current_velocity:Vector2 = body.linear_velocity
	var diff_velocity:Vector2 = target_velocity - current_velocity
	var diff_len:float = (target_velocity - diff_velocity).length_squared()
	var str_sqr:float = strength * strength
	if diff_len < str_sqr:
		body.apply_central_impulse(strength * diff_velocity.normalized())
	else:
		body.apply_central_impulse(delta * diff_velocity)

func speed_down(strength:float)->void:
	if body.linear_velocity.length_squared() >= (strength * strength):
		body.apply_central_impulse(strength * -body.linear_velocity.normalized())
	else:
		body.linear_velocity = Vector2.ZERO
