
extends Camera2D

onready var spring: = ShakeSpring.new(0.025, 0.025)

var target: = Vector2.ZERO

func _ready()->void:
	Event.connect("Camerashake", self, "apply_camerashake")

func _unhandled_input(event)->void:
	if event.is_action_pressed("click"):
		var strength: = 2000.0
		var impulse: = Vector2(-strength/2 +(randf()*strength), -strength/2 +(randf()*strength))
		Event.emit_signal("Camerashake", impulse)

func apply_camerashake(impulse:Vector2)->void:
	spring.apply_impulse(impulse)

func _process(delta)->void: #Happens every frame
	position = target + spring.shake_process(delta) #implemention is up to you
