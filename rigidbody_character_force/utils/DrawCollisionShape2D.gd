@tool
extends CollisionShape2D
class_name DrawCollisionShape2D

@export var color:Color : set = set_color
@export var width:float = 1.0

func set_color(value:Color)->void:
	color = value
	queue_redraw()

func _draw()->void:
	if shape is CircleShape2D:
		var radius: = (shape as CircleShape2D).radius
		draw_circle(Vector2.ZERO, radius, color)
	elif shape is RectangleShape2D:
		var size:Vector2 = shape.size
		var rect: = Rect2(-size.x * 0.5, -size.y * 0.5, size.x, size.y) 
		draw_rect(rect, color)
	elif shape is SeparationRayShape2D:
		#draw_line(Vector2.ZERO, Vector2.DOWN * shape.length, color, width)
		var rect: = Rect2(-width * 0.5, 0, width, shape.length)
		draw_rect(rect, color)
