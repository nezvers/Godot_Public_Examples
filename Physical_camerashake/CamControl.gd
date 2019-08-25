tool
extends Node2D


export (float) var strenght = 300.0
export (float, 0, 16) var softness = 8
export (float, 0, 0.9) var bias = 0.9
var direction: Vector2
onready var CamBody = $CamBody
onready var PinJoint = $PinJoint2D

func _ready():
	PinJoint.bias = bias
	PinJoint.softness = softness

func _process(delta):
	if Input.is_action_just_pressed("click"):
		shake_rand()

func shake_rand()->void:
	direction = Vector2(randf()*2-1,randf()*2-1).normalized()
	CamBody.apply_central_impulse(direction * strenght)
