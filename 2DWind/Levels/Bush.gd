extends Sprite

onready var spring: = ShakeSpring.new(0.02, 0.02)
export (float) var strength = 200

var point: = Vector2.ZERO

func _unhandled_input(event:InputEvent)->void:
	if event is InputEventMouseButton && event.is_pressed():
		spring.apply_impulse(Vector2(randf()*strength*sign(randf()-0.5),randf()*strength*sign(randf()-0.5)))
		pass


func _process(delta:float)->void:
	point = spring.shake_process(delta)
	material.set_shader_param("u_offset", point)
	#update()
