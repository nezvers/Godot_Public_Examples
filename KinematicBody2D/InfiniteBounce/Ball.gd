extends KinematicBody2D

onready var radius:float = $CollisionShape2D.shape.radius
func _draw()->void:
	draw_circle(Vector2.ZERO, radius, Color.blue)

var velocity: = Vector2.ZERO
var remainder: = 0.0

func _physics_process(delta:float)->void:
	var collision: = move_and_collide(velocity*delta + velocity.normalized()*remainder)
	remainder = 0.0
	if collision:
		var speed: = velocity.length() 							#current speed
		var dir: = velocity.normalized()						#current direction
		var normal:Vector2 = collision.normal
		remainder = collision.remainder.length()				#velocity remainder
		velocity = dir.bounce(normal) *speed					#velocity after bouncing off the surface

func _unhandled_input(event:InputEvent)->void:
	if event is InputEventMouseButton && event.is_pressed() && event.button_index == 1:
		var dir:Vector2 = get_local_mouse_position().normalized()
		velocity += dir * 50
