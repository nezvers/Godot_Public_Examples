class_name Gravity
extends Node

static var velocity:Vector2

@export var gravity:Vector2 : set = set_gravity


func set_gravity(value:Vector2)->void:
	gravity = value
	velocity = value
	print("Gravity: ", gravity)
