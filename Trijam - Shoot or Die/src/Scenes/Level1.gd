extends Node2D

export (bool) var timer = true

var time: float = 10

func _ready():
	Event.connect("Spawn", self, "on_Spawn")
	Event.connect("Stop", self, "on_Stop")

func _process(delta):
	if !timer:
		return
	time-=delta
	Score.emit_signal("UpdateTime", int(floor(time)))
	if time <= 0:
		Event.emit_signal("Level")

func on_Spawn(inst, msg):
	var Instance = inst.instance()
	add_child(Instance)
	Instance.start(msg)

func on_Stop():
	yield(get_tree().create_timer(1), "timeout")
	Event.emit_signal("Level")