extends Area2D

var unlocked: bool = false

func _ready():
	Event.connect("Unlocked", self, "on_unlock")

func on_unlock():
	$AnimatedSprite.play("open")
	unlocked = true



func _on_Door_area_shape_entered(area_id, area, area_shape, self_shape):
	if area.get_collision_layer_bit(1) && unlocked:
		var player: Node2D = area.get_parent()
		player.can_move = false
		player.visible = false
		$Timer.start()


func _on_Timer_timeout():
	Event.keys = 0
	Event.locked = 0
	get_tree().reload_current_scene()
