extends Node2D

enum {STAY, MOVE}
export (float) var speed_default: float = 1*60
export (float) var speed_base:float = 2 * 60
var speed: float = speed_default+speed_base
var state: int = MOVE

func _ready()->void:
	Event.connect("Score", self, "on_Score")

func _process(delta):
	match state:
		STAY:
			pass
		MOVE:
			position.x += delta* speed

func _on_Player_move(do:bool):
	#print(do)
	if do:
		state = MOVE
	else:
		state = STAY

func on_Score()->void:
	speed = speed_base + (speed_default * Event.difficulity)