tool
extends Node2D

export (Color) var color = Color.white setget set_color
export (float) var width = 1 setget set_width
export (float) var radius = 1 setget set_radius
export (int) var division = 8 setget set_division
export (float) var angle = 0 setget set_angle
export (Vector2) var Pos = Vector2.ZERO setget set_Pos

func _draw()->void:
	var a:float = deg2rad(angle)			#angle in radians
	var div_a:float = (PI*2) / division		#angle between points
	
	for i in range(division):	#position points
		var x1:float = radius * cos(i*div_a + a)
		var y1:float = radius * -sin(i*div_a + a)
		
		var l:int = (i+1) % division #next point. % to wrap up to 0 on last point
		var x2:float = radius * cos(l*div_a + a)
		var y2:float = radius * -sin(l*div_a + a)
		
		draw_line(Vector2(x1,y1) + Pos, Vector2(x2,y2) + Pos, color, width, false)

func set_radius(value:float)->void:
	radius = value
	update()

func set_division(value:int)->void:
	division = value
	update()

func set_angle(value:float)->void:
	angle = fmod(value, 360 / division)
	update()

func set_color(value:Color)->void:
	color = value
	update()

func set_width(value:float)->void:
	width = value
	update()

func set_Pos(value:Vector2)->void:
	Pos = value
	update()
