extends Node

signal mouse_capture
var mouseCaptured: = false setget set_mouseCapture

func _ready():
	OS.center_window()

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		set_mouseCapture(!mouseCaptured)

func set_mouseCapture(value:bool)->void:
	mouseCaptured = value
	if !mouseCaptured:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	emit_signal("mouse_capture")
