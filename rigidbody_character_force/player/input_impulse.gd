extends Node

@export var body:Body
@export var force_multiply:float = 3
@export var force_limit:float = 1000

func _input(event: InputEvent) -> void:
	if !event.is_action_released("mouse_left"):
		return
	var mouse_pos:Vector2 = body.get_local_mouse_position()
	var velocity:Vector2 = (mouse_pos * force_multiply)
	if velocity.length_squared() > (force_limit * force_limit):
		velocity = velocity.normalized() * force_limit
	body.push(velocity)
