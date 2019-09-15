extends CPUParticles2D

export (float) var time = 1

func start(msg: Dictionary):
	global_position = msg.pos
	$Timer.wait_time = time
	$Timer.start()
	lifetime = time
	look_at(msg.pos+msg.dir)
	emitting = true

func _on_Timer_timeout():
	queue_free()
