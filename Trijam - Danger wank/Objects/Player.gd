extends Node2D

export (NodePath) var bar_node
onready var Bar = get_node(bar_node)
onready var particles: = get_node("CPUParticles2D")
onready var finished: = get_node("Succeeded")

var progress:float = 0
var drop_speed:float = 0.2
var add_speed:float = 0.1
var state: String = "idle"

func _ready()->void:
	particles.emitting = false
	progress = 0
	Bar.value = int(progress*100)
	Bar.visible = false
	$Label.visible = false
	Event.connect("Continue", self, "on_Continue_signal")
	Event.connect("Alert", self, "on_Alert_signal")
	Event.connect("Success", self, "on_Success_signal")
	Event.connect("GameOver", self, "on_GameOver_signal")
	pass

func _process(delta:float)->void:
	if state == "idle":
		if progress>0:
			progress+= -drop_speed*delta
			progress = clamp(progress, 0 , 1)
			Bar.value = int(progress*100)
		if Input.is_action_just_pressed("wank"):
			Event.emit_signal("Alert")
	elif state == "wank":
		progress+= -drop_speed*delta
		if Input.is_action_just_pressed("wank"):
			progress+=add_speed
			particles.emitting = true
		if progress >= 1:
			Event.emit_signal("Success")
		progress = clamp(progress, 0 , 1)
		Bar.value = int(progress*100)
	else:
		if progress>0:
			progress+= -drop_speed*delta
			progress = clamp(progress, 0 , 1)
			Bar.value = int(progress*100)

func on_Continue_signal()->void:
	state = "idle"
	Bar.visible = false

func on_Alert_signal()->void:
	state = "wank"
	$Label.visible = true
	$Timer.start()
	Bar.visible = true
	drop_speed = rand_range(0.2, 0.7)
	print("new drop speed ", drop_speed)
	
func on_Success_signal()->void:
	state = "Success"
	finished.emitting = true

func on_GameOver_signal():
	state = "fail"

func _on_Timer_timeout():
	$Label.visible = false
