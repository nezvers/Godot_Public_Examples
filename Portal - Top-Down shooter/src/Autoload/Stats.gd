extends Node

signal Hit
signal kill
signal Score

var score: int = 0
var max_health: int = 10
var health: int

func _ready():
	Event.connect("Killed", self, "on_Killed_signal")
	connect("Hit", self, "on_Hit_signal")

func on_Killed_signal():
	score += 1
	emit_signal("Score", {health=health, score=score})

func on_Hit_signal():
	if health>0:
		health -= 1
		emit_signal("Score", {health=health, score=score})
		if health <= 0:
			Event.player.death()

func on_Player_death():
	get_tree().reload_current_scene()