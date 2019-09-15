extends Control

onready var health: = $Health
onready var score: = $Score
var current_health: int = 100
var maximum_health: int = 100


func _ready():
	Stats.connect("Score", self, "on_Score_signal")

func on_Score_signal(msg):
	animate_value(current_health, msg.health*10)
	current_health = msg.health*10
	score.text = "Score: " + str(msg.score)

func animate_value(start, end):
	$Tween.interpolate_property($Health, "value", start, end, 0.6, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	$Tween.start()