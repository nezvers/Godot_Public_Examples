extends Node

var single = preload("res://Singleton.tres") #Player and Enemy preload same Resource

func _ready():
	single.enemy = self #add itself to Resource variable
	
