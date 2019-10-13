extends Node2D

onready var ViewSize: Vector2 = get_viewport().get_visible_rect().size

var tweening1: bool = false
var tweening2: bool = false

func _ready():
	Event.connect("transition", self, "on_transition")
	Area2D

func on_transition(dir: Vector2, body, ShapeSize: Vector2):
	$Tween.interpolate_property(self, "global_position", global_position, (global_position + (ViewSize * dir)) , 1, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
	$Tween.start()
	tweening1 = true
	
	$Tween2.interpolate_property(body, "global_position", body.global_position, (body.global_position + (ShapeSize * 2 * dir)) , 1, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
	$Tween2.start()
	tweening2 = true

func _on_Up_body_entered(body):
	if body is Player and !tweening1:
		Event.emit_signal("transition", Vector2.UP, body, get_shape_size(body))

func _on_Down_body_entered(body):
	if body is Player and !tweening1:
		Event.emit_signal("transition", Vector2.DOWN, body, get_shape_size(body))

func _on_Left_body_entered(body):
	if body is Player and !tweening1:
		Event.emit_signal("transition", Vector2.LEFT, body, get_shape_size(body))

func _on_Right_body_entered(body):
	if body is Player and !tweening1:
		Event.emit_signal("transition", Vector2.RIGHT, body, get_shape_size(body))

func get_shape_size(body)-> Vector2:
	return body.get_node("CollisionShape2D").get_shape().get_extents()

func _on_Tween_tween_all_completed():
	tweening1 = false


func _on_Tween2_tween_all_completed():
	tweening2 = false
