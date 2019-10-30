extends Player


func stats():
	speed = base_speed + Event.pickup_speed * speed_multiply
	lives = Event.pickup_max_lives

func get_direction():
	var dir: = Vector2.ZERO
	dir.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	dir.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	rotation_degrees = lerp(rotation_degrees, 10 * dir.x, 0.1)
	return dir.normalized()

func get_lives():
	return float(lives) / float(Event.pickup_max_lives) * 100.0