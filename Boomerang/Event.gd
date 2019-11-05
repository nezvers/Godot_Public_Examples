extends Node

func _input(event):
	if event.is_action_pressed("exit"):
		get_tree().quit()
	elif event.is_action_pressed("restart"):
		get_tree().reload_current_scene()