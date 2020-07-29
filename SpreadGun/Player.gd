extends KinematicBody2D

var speed = 4.0 * 60.0	#walk speed

func _physics_process(_delta:float)->void:		#no collisions in this example so it's not needed for _physics_process
	var dir: = Vector2.ZERO
	dir.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")	#right - left
	dir.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")		#down - up
	
	move_and_slide(dir*speed)		#move

