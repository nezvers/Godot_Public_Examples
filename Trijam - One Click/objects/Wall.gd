extends Control



func _on_Wall_mouse_entered():
	var global = get_node("/root/global")
	global.fromStart = false
	global.death +=1
