extends Node

signal Alert
signal Arived
signal Success
signal Continue
signal GameOver

var success: = false
var score: int = 0

func _ready():
	randomize()
	connect("Success", self, "on_Success_signal")
	connect("Arived", self, "on_Arrived_signal")

func on_Success_signal():
	success = true
	score += 1
	print("Success")

func on_Arrived_signal():
	print("Signal arrived")
	if success:
		success = false
		print("Continue - ", "Score: ", score)
		emit_signal("Continue")
	else:
		emit_signal("GameOver")
		print("Game Over")