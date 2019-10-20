extends Area2D

onready var start_position: = global_position
var time: float = 0

func _physics_process(delta):
	time += delta *6
	global_position = start_position + Vector2.UP * sin(time)

func _on_Key_area_shape_entered(area_id, area, area_shape, self_shape):
	if area.get_collision_layer_bit(1):
		Event.keys += 1
		queue_free()
