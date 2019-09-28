extends CanvasLayer

func _ready():
	Score.connect("UpdateTime", self, "on_time")
	Score.connect("UpdateScore", self, "on_score")
	
	$Control/Player1.text = "PL1: " + str(Score.p1)
	$Control/Player2.text = "PL2: " + str(Score.p2)

func on_time(t:int):
	$Control/Timer.text = str(t)

func on_score():
	$Control/Player1.text = "PL1: " + str(Score.p1)
	$Control/Player2.text = "PL2: " + str(Score.p2)