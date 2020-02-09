extends Node2D

onready var SCREEN_SIZE:Vector2 = get_viewport().get_visible_rect().size
var tetraminoe:PackedScene = preload("res://Objects/Piece.tscn")
var piece: Node2D

func _ready()->void:
	piece = tetraminoe.instance()
	add_child(piece)
	piece.position.x = ceil(SCREEN_SIZE.x * 0.5)
	piece.position.y = 2

func _process(delta):
	if Input.is_action_just_pressed("ui_left"):
		piece.rotate_piece(-1)
	if Input.is_action_just_pressed("ui_right"):
		piece.rotate_piece(1)

func _unhandled_input(event)->void:
	if event.is_action_pressed("ui_cancel"):	#Restart
		get_tree().reload_current_scene()
