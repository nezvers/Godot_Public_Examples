extends Node

var single = preload("res://Singleton.tres") #Player and Enemy preload same Resource

func _ready():
	single.player = self #add itself to Resource variable
	yield(get_tree(), "idle_frame")
	print(single.enemy.name)	#access other node
