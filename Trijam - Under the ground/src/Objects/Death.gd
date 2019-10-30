extends Node2D

func start(msg:Dictionary = {}):
	global_position = msg.pos
	$CPUParticles2D.emitting = true

func _on_Timer_timeout():
	get_tree().change_scene("res://src/Levels/Shop.tscn")
