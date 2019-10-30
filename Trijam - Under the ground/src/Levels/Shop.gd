extends Control

func _ready():
	Event.connect("Score", self, "on_Score")
	$Coins.text = "Coins: " + str(Event.coins)
	$Music.stream = pre_load.m_trip
	$Music.play()

func on_Score():
	$Coins.text = "Coins: " + str(Event.coins)

func _on_Button_pressed():
	Event.coins = 0
	get_tree().change_scene("res://src/Levels/Level.tscn")
