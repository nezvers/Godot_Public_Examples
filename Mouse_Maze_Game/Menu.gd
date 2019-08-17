extends Control

export (String, FILE, "*.tscn") var next_scene

var hover = false
var blend = 0
var blendSpeed = 0.04
var global
onready var debug = get_node("/root/debug")

func _ready():
	global = get_node("/root/global")
	if !global.firstPlay:
		$DeathCount.visible = true
		$TimeCount.visible = true
		var time_now = OS.get_unix_time()
		var elapsed = time_now - global.timeStart
		var minutes = elapsed / 60
		var seconds = elapsed % 60
		var str_elapsed = "%02d : %02d" % [minutes, seconds]
		$TimeCount.text = "Time to complete : " + String(str_elapsed)
		$DeathCount.text = "Deaths: " + String(global.death)

func _on_Button_mouse_entered():
	hover = true
	$Blip.play(0)
	debug.text = "entered"

func _on_Button_mouse_exited():
	hover = false
	debug.text = "exited"

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
	global.firstPlay = false
	global.death = 0
	global.timeStart = OS.get_unix_time()
	get_tree().change_scene(next_scene)
