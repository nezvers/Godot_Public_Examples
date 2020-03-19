extends Sprite

var index: int = 0
var previous:int = 0
var paletteCount: int = 38

func _ready()->void:
	new_palette()

func _unhandled_input(event):
	if (event is InputEventKey || event is InputEventMouseButton) && event.is_pressed():
		new_palette()

func new_palette()->void:
	previous = index
	index = randi() % paletteCount
	material.set_shader_param("next", index)
	material.set_shader_param("previous", previous)
	$Tween.interpolate_property(material,
								"shader_param/blend",
								0.0, 1.0, 1,
								Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.start()
