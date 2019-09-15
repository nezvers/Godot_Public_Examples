extends AnimatedSprite

signal dead

var done: bool = false

func start(msg: Dictionary):
	play()
	$AudioStreamPlayer.stream = pre_load.snd_player_death
	$AudioStreamPlayer.play()
	connect("dead", Stats, "on_Player_death")
	global_position = msg.pos
	if msg.flip:
		scale.x = -1

func _on_AudioStreamPlayer_finished():
	if done:
		$Timer.start()
	else:
		done = true

func _on_Player_death_animation_finished():
	#$Timer.start()#testing
	if done:
		$Timer.start()
	else:
		done = true


func _on_Timer_timeout():
	emit_signal("dead")
