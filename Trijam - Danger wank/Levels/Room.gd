extends Node2D

onready var restart: = get_node("GUI/TextureButton")
onready var score: = get_node("GUI/Score")

func _ready():
	restart.disabled = true
	restart.visible = false
	score.text = "SCORE: " + str(Event.score)
	Event.connect("GameOver", self, "on_GameOver_signal") 
	Event.connect("Continue", self, "on_Continue_signal")

func _on_TextureButton_pressed():
	Event.score = 0
	get_tree().reload_current_scene()

func on_GameOver_signal():
	restart.disabled = false
	restart.visible = true

func on_Continue_signal():
	score.text = "SCORE: " + str(Event.score)