extends TextureButton

signal double_click

var double_speed:int = 1000*0.25
var last_click: = {}

func double_click_detect(key:String)->bool:
	var new_click: = OS.get_ticks_msec()
	if last_click.has(key) && new_click - last_click[key] <= double_speed:
			return true
	last_click[key] = new_click
	return false


func _unhandled_input(event:InputEvent)->void:
	if event.is_action_pressed("ui_accept"):
		if double_click_detect("ui_accept"):
			print("accept double click")


onready var tween: = $Tween
func _ready()->void:
	connect("pressed", self, "on_pressed")
	connect("double_click", self, "on_double_click")

func on_pressed()->void:
	if double_click_detect("TextureButton"):
		emit_signal("double_click")
	tween.interpolate_property(self, "rect_scale", Vector2(1.5, 0.75), Vector2(1.0, 1.0), 1.0, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	tween.start()

func on_double_click()->void:
	modulate = Color(randf(), randf(), randf(), 1.0)


