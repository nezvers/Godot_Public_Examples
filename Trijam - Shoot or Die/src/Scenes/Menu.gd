extends Control

#export (String, FILE, "*.tscn") var next_scene

var hover = false
var blend = 0
var blendSpeed = 0.04

func _on_Button_mouse_entered():
	hover = true
	$AudioStreamPlayer.stream = pre_load.snd_menu_enter
	$AudioStreamPlayer.volume_db = -10.0
	$AudioStreamPlayer.play()

func _on_Button_mouse_exited():
	hover = false
	$AudioStreamPlayer.stream = pre_load.snd_menu_exit
	$AudioStreamPlayer.volume_db = -15.0
	$AudioStreamPlayer.play()

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
	#get_tree().change_scene(next_scene)
	Event.emit_signal("Level")
