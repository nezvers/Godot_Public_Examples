extends Node2D

func start(msg:Dictionary = {}):
	global_position = msg.pos
	$AnimatedSprite.play("default")

func _on_AnimatedSprite_animation_finished():
	queue_free()
