class_name Body
extends RigidBody2D

signal got_push(impulse:Vector2)
signal is_push_changed(value:bool)
var is_pushed:bool : set = set_is_pushed

func _ready()->void:
	# enables collide signals
	contact_monitor = true

func set_is_pushed(value:bool)->void:
	if value == is_pushed:
		return
	is_pushed = value
	is_push_changed.emit(value)
	print(name, ": is_pushed = ", value)

func push(impulse:Vector2)->void:
	linear_velocity = impulse
	got_push.emit(impulse)
	set_is_pushed(true)
