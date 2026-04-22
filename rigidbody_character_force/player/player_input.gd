class_name PlayerInput
extends Node

@export var move_right:String = "move_right"
@export var move_left:String = "move_left"
@export var move_down:String = "move_down"
@export var move_up:String = "move_up"

@export var walk_velocity:WalkVelocity

func _process(_delta:float)->void:
	walk_velocity.move_dir.x = Input.get_axis(move_left, move_right)
	walk_velocity.move_dir.y = Input.get_axis(move_up, move_down)
