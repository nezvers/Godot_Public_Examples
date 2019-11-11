extends Node2D

enum {STAY, MOVE}
var speed_default: float = 4*60
var speed: float = speed_default
var state: int = MOVE

func _process(delta):
	match state:
		STAY:
			pass
		MOVE:
			position.x += delta* speed

func _on_Player_cow():
	state = STAY

func _on_Player_collected():
	state = MOVE
