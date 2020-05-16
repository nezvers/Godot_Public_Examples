extends Node2D

onready var cam: = $Cam

func _process(delta):
	var dir: = Vector2.ZERO
	dir.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	dir.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	translate(dir * 120* delta)


func _unhandled_input(event):
	if event.is_action_pressed("click"):
		#cam.shake_rand()
		pass
