extends Node2D
class_name Point

var x:float
var y:float
var label:int
var right:bool = false	#walue for visualization

func _draw()->void:
	var color:Color
	if label == 1:
		color = Color.white
	else:
		color = Color.black
	var pos:Vector2 = Vector2(x,y)
	draw_circle(pos, 5, color)
	if right:
		color = Color.green
	else:
		color = Color.red
	draw_circle(pos, 3, color)

func _ready()->void:
	#randomly place on the screen
	var size:Vector2 = get_viewport().get_visible_rect().size
	x = floor(randf() * size.x)
	y = floor(randf() * size.y)
	
	#set value
	if x > y:		#imagined line for sorting
		label = 1
	else:
		label = -1