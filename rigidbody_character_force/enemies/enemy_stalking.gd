extends Node

@export var walk_velocity:WalkVelocity
@export var player_body:Body
@export var body:Body

func _process(_delta: float) -> void:
	walk_velocity.move_dir = (player_body.global_position - body.global_position).normalized()
