extends Area2D

func _ready():
	$AnimatedSprite/AnimationPlayer.play("Bounce")

func start(msg:Dictionary = {}):
	$AnimatedSprite/AnimationPlayer.play("Bounce")
	global_position = msg.pos
	

func _on_Coin_body_entered(body):
	if body.name == "Player_pickup":
		Event.coins += 1
		Event.emit_signal("Score")
		Event.emit_signal("Spawn", pre_load.o_SoundPlayer, {sound=pre_load.snd_collect, volume=-5.0})
		queue_free()

func bounce():
	Event.emit_signal("Spawn", pre_load.o_SoundPlayer, {sound=pre_load.snd_coin, volume=-0.0})


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
