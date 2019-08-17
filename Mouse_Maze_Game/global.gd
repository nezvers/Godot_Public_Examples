extends Node2D

var fromStart = false
var death = 0
var firstPlay = true
var timeStart = 0

func _ready():
	pass

func _process(delta):
	if Input.is_action_pressed("restart"):
		firstPlay = true
		get_tree().change_scene("res://Menu.tscn")