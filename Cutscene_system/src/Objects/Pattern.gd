extends Node

onready var player: Node2D

onready var pattern: Dictionary

func _ready():
	player = get_node("../../Player")
	pattern = {
	-1: {
		name = "change_variable", 
		inst = player, 
		variable = "can_move", 
		value = false
		},
	0: {
		name = "move_to", 
		inst = player, 
		pos = Vector2(500, 350), 
		spd = 120
		},
	1: {
		name = "wait", 
		time = 1
		},
	2:{
		name = "relative_move_to",
		inst = player, 
		pos = Vector2(-60, 36), 
		spd = 120
		},
	3:{
		name = "relative_move_to",
		inst = player, 
		pos = Vector2(0, -90), 
		spd = 120
		},
	4: {
		name = "wait", 
		time = 0.5
		},
	5:{
		name = "relative_move_to",
		inst = player, 
		pos = Vector2(90, 0), 
		spd = 120
		},
	6: {
		name = "change_variable", 
		inst = player, 
		variable = "can_move", 
		value = true
		}
	}