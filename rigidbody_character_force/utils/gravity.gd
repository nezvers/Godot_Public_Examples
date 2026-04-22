extends Node

@export var gravity:Vector2 : set = set_gravity

# TODO: doesn't seem to work
func set_gravity(value:Vector2)->void:
	gravity = value
	var strength:float = gravity.length()
	var direction:Vector2 = gravity.normalized()
	PhysicsServer2D.area_set_param(get_viewport().find_world_2d().space, PhysicsServer2D.AREA_PARAM_GRAVITY, strength)
	PhysicsServer2D.area_set_param(get_viewport().find_world_2d().space, PhysicsServer2D.AREA_PARAM_GRAVITY_VECTOR, direction)
	print("Gravity: ", gravity)
