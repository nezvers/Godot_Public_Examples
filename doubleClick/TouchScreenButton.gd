extends TouchScreenButton

signal double_click
var double_speed:int = 1000*0.25
var last_touch: = 0.0

func double_click_detect()->bool:
	var new_touch: = OS.get_ticks_msec()
	if new_touch - last_touch <= double_speed:
			return true
	last_touch = new_touch
	return false

onready var tween: = $Tween
onready var sprite: = $Sprite

func _ready():
	OS.center_window()
	connect("pressed", self, "on_pressed")
	connect("double_click", self, "on_double_click")

func on_pressed()->void:
	if double_click_detect():
		emit_signal("double_click")
	tween.interpolate_property(sprite, "scale", Vector2(1.5, 0.7), Vector2(1.0, 1.0), 1.0, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	tween.start()


func on_double_click()->void:
	sprite.modulate = Color(randf(), randf(), randf(), 1.0)

