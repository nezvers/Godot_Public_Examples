extends Node2D



func _unhandled_input(event)->void:
	if event.is_action_pressed("ui_cancel"):	#Restart
		get_tree().reload_current_scene()
