tool
extends CollisionShape2D
class_name VisibleCollisionShape2D

export (Color) var color = Color.white setget set_color

func _draw()->void:
	if shape is CircleShape2D:
		draw_circle(Vector2.ZERO, shape.radius, color)
	elif shape is CapsuleShape2D:
		var height:float = shape.height
		var radius:float = shape.radius
		draw_circle(Vector2(0,-height/2), radius, color)
		draw_circle(Vector2(0,height/2), radius, color)
		var rect:Rect2 = Rect2(Vector2(-radius, - height/2), Vector2(radius*2, height))
		draw_rect(rect, color, true)
	elif shape is RectangleShape2D:
		var ext:Vector2 = shape.extents
		var rect:Rect2 = Rect2(Vector2(-ext.x, -ext.y), ext*2)
		draw_rect(rect, color, true)

func set_color(new_color):
	color = new_color
	update()
