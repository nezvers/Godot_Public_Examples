extends Node

signal Spawn
signal Hit
signal Stop
signal Level

var lvl: Array = [
	"res://src/Scenes/Level1.tscn",
	"res://src/Scenes/Level2.tscn",
	"res://src/Scenes/Level3.tscn",
	"res://src/Scenes/Level4.tscn"
	]

func _ready():
	connect("Hit", self, "on_Hit")
	connect("Level", self, "on_Level")

func on_Hit(Player2: bool):
	emit_signal("Stop")
	if Player2:
		Score.p1+=1
	else:
		Score.p2+=1
	Score.emit_signal("UpdateScore")

func on_Level():
	lvl.shuffle()
	get_tree().change_scene(lvl[0])