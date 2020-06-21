extends Node2D

func _ready()->void:
	$RigidKinematicBody2D.connect("collided", self, "player_collided")

func _unhandled_input(event):
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()
	if event.is_action_pressed("click"):
		var vec:Vector2 = get_global_mouse_position() - $RigidKinematicBody2D.global_position
		$RigidKinematicBody2D.apply_impulse(vec*2)

func player_collided(Collision:KinematicCollision2D, strength:float)->void:
	if strength > 90:
		$AudioStreamPlayer.play()
