extends KinematicBody2D
class_name RigidKinematicBody2D

signal collided

export(Vector2) var linear_velocity = Vector2.ZERO
export(Vector2) var gravity = Vector2(0, 20) setget set_gravity
export(float) var dampening = 0.005 #if too low value it starts gain speed when rolling on the ground
export(float, 0.0, 1.0) var bounciness = 0.5

var collision:KinematicCollision2D
var remainder:Vector2 = Vector2.ZERO

func set_gravity(value:Vector2)->void:
	gravity = value

func set_linear_velocity(value:Vector2)->void:
	linear_velocity = value

func _physics_process(delta)->void:
	rigid_physics(delta)

func rigid_physics(delta)->void:
	linear_velocity += gravity #add gravity
	collision = move_and_collide(linear_velocity * delta + remainder) #apply physics
	linear_velocity = linear_velocity * (1 - dampening) #reduce speed over time
	if collision: #collision detected
		var normal:Vector2 = collision.normal #surface normal
		var strenght:float = -normal.dot(linear_velocity) #
		linear_velocity += normal * strenght * (1 - bounciness) #dampen velocity in floor direction
		linear_velocity = linear_velocity.bounce(normal) #bounce off the surface
		remainder = collision.remainder.bounce(normal) #add in next frame
		emit_signal("collided", collision, strenght)
	else:
		remainder = Vector2.ZERO #No collision means no remainder

func apply_impulse(value:Vector2)->void:
	linear_velocity += value
