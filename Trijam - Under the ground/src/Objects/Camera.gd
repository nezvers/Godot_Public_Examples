extends Node2D

export (float) var speed = 30
var stop: bool = false

func _ready():
	Event.connect("Stop", self, "on_Stop")

func on_Stop():
	stop = true

func _physics_process(delta):
	if stop:
		return
	#translate(Vector2(0, -speed*delta))
	#Same as
	global_position += Vector2(0, -speed*delta)