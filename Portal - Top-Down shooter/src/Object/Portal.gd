extends Node2D

export (String, FILE, "*.tscn") var CREATURE

var state: = 0
onready var creature: PackedScene

func start(msg: Dictionary):
	position = msg.pos
	creature = msg.inst
	$Sound.stream = pre_load.snd_portal
	$Sound.play()

func _process(delta):
	if state == 0:	#start
		scale = Vector2(1,1) * (1- $Timer.time_left / $Timer.wait_time)
	elif state == 2:#End
		scale = Vector2(1,1) * ($Timer.time_left / $Timer.wait_time)

func _on_Timer_timeout():
	if state == 3:
		queue_free()
	else:
		state += 1
		if state==1:
			Spawn()
		$Timer.start()

func Spawn():
	Event.emit_signal("Spawn", creature, {pos = position})