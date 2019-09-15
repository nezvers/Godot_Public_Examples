extends Node

signal Spawn		#Enemies
signal Portal
signal Created
signal Killed
signal PlayerMoved
signal PlayerDead
signal CursorMoved
signal CameraImpulse

var NavigationNode: Node2D
var MapNode: Node2D
var player: Node2D

func _input(event):
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()