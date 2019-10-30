extends AudioStreamPlayer

func start(msg:Dictionary={}):
	stream = msg.sound
	volume_db = msg.volume
	play()

func _on_SoundPlayer_finished():
	queue_free()
