#extends Node #nor needed to be of any class

var num = 19
var speed = 3*60

func script_process(delta):
	var dir = Vector2()
	dir.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	dir.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	dir = dir.normalized()
	return dir * speed * delta
