tool
extends CanvasLayer

export (Vector2) var center = Vector2(0.5, 0.5) setget set_center #percentage on screen like UV
export (float, 0.0, 1.0) var percent = 0.5 setget set_percent

func _ready()->void:
	$Fill.material.set_shader_param("tex_size", get_viewport().get_visible_rect().size)
	$Fill.material.set_shader_param("pos", center)
	$Fill.material.set_shader_param("percent", percent)

func set_center(pos: Vector2)->void:
	center.x = clamp(pos.x, 0.0, 1.0)
	center.y = clamp(pos.y, 0.0, 1.0)
	$Fill.material.set_shader_param("pos", center)

func set_percent(pos: float)->void: #Set function 
	percent = pos
	$Fill.material.set_shader_param("percent", pos)