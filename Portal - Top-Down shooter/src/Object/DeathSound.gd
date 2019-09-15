extends AudioStreamPlayer2D


func start(msg):
	position = msg.pos
	stream = msg.sound
	play()

func _on_DeathSound_finished():
	queue_free()
