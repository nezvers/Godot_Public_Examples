tool
extends Node2D

func _unhandled_input(event):
	if event.is_action_pressed("exit"):
		get_tree().quit()
	elif event.is_action_pressed("reset"):
		get_tree().reload_current_scene()

func _ready()->void:
	OS.center_window()


