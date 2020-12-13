
extends Camera2D

export var tension:float = 75.0 setget set_tension
export var dampening:float = 0.2 setget set_dampening
var spring: = ShakeSpring.new(tension, dampening)

func set_tension(value:float)->void:
	tension = value
	spring.tension = value
func set_dampening(value:float)->void:
	dampening = value
	spring.dampening = value


func _ready()->void:
	Event.connect("Camerashake", self, "apply_camerashake")

func _unhandled_input(event)->void:
	if event.is_action_pressed("click"):
		var strength: = 10.0
		var direction: = Vector2.RIGHT.rotated(PI * 2 * randf())
		var impulse: = direction * strength
		Event.emit_signal("Camerashake", impulse)

func apply_camerashake(impulse:Vector2)->void:
	spring.apply_impulse(impulse)

func _process(delta)->void: #Happens every frame
	offset = spring.shake_process(delta) #implemention is up to you
