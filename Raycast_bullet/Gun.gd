extends Position2D

export (PackedScene) var bulletScene:PackedScene

func _unhandled_input(event:InputEvent)->void:
	if event.is_action_pressed("click"):
		if bulletScene:
			Events.emit_signal("spawn_bullet", bulletScene, global_position, global_transform.x, global_rotation)
		else:
			print("Bullet scene not assigned to the gun")
