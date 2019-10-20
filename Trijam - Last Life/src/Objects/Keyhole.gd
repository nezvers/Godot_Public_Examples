extends Area2D


func _ready():
	Event.locked += 1

func _on_Keyhole_area_shape_entered(area_id, area, area_shape, self_shape):
	if area.get_collision_layer_bit(1):
		if Event.keys > 0:
			Event.keys -= 1
			Event.locked -=1
			if Event.locked <= 0:
				Event.emit_signal("Unlocked")
			print(Event.locked)
			queue_free()
