extends Node2D

var scene: Node2D
var forward: Script = preload("res://Forward_kinematics.gd")
var follow: Script = preload("res://IK_follower.gd")
var fabrik: Script = preload("res://FABRIK.gd")

func _ready():
	scene = fabrik.new()
	add_child(scene)

func _on_Forward_pressed():
	scene.queue_free()
	yield(get_tree(), "idle_frame")
	scene = forward.new()
	add_child(scene)


func _on_Follow_pressed():
	scene.queue_free()
	yield(get_tree(), "idle_frame")
	scene = follow.new()
	add_child(scene)


func _on_FABRIK_pressed():
	scene.queue_free()
	yield(get_tree(), "idle_frame")
	scene = fabrik.new()
	add_child(scene)
