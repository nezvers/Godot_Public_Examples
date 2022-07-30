extends Node2D

onready var tilemap: = $TileMap

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.pressed && event.button_index == 1:	#pressed left mouse button
			#Explosion.trigger(tilemap, get_global_mouse_position())
			random_explosions()
	elif event.is_action_pressed("ui_cancel"):
# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()

func random_explosions()->void:
# warning-ignore:unused_variable
	var pos: = get_global_mouse_position()
	var rand_size: = 80.0
	var count: = 6
	
	for i in count:
		var rand_pos: = Vector2(rand_range(-rand_size, rand_size), rand_range(-rand_size, rand_size))
		# call static function that doesn't need instancing
		Explosion.trigger(tilemap, get_global_mouse_position() + rand_pos)
