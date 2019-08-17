extends Area

onready var room = get_parent()


func _on_Void_body_entered(body):
	if body.has_method("death"):
		body.death()
	else:
		body.queue_free()
		room.box_count-=1
		room.update_count()
