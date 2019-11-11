extends Node2D

onready var camera = get_node("../Camera")

func _ready():
	Event.connect("Text", self, "on_Text")

func _physics_process(delta):
	global_position.x = max(global_position.x, camera.global_position.x)
	if global_position.x == camera.global_position.x:
		if !$Start.visible:
			$Start.visible = true

func on_Text(txt:String):
	if txt == "start" || txt == "START":
		get_tree().change_scene_to(load("res://src/Levels/Level.tscn"))