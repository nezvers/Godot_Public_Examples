extends Control

export (String, FILE, "*.tscn") var next_scene

var hover = false
var blend = 0
var blendSpeed = 0.04

func _on_Button_mouse_entered():
	hover = true

func _on_Button_mouse_exited():
	hover = false

func _process(delta):
	if hover:
		var color = $BG2.color
		var alpha = lerp(color.a, 1, blendSpeed)
		$BG2.color.a = alpha
	else:
		var color = $BG2.color
		var alpha = lerp(color.a, 0, blendSpeed*5)
		$BG2.color.a = alpha

func _on_Button_pressed():
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().change_scene(next_scene)
