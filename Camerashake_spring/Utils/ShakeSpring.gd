class_name ShakeSpring
#Variables
var tension:		= 2.0 setget set_tension
var dampening:		= 0.013 setget set_dampening
var targetPosition: = Vector2.ZERO
var shakePosition:	= Vector2.ZERO
var velocity:		= Vector2.ZERO

func set_tension(value:float)->void:
	tension = value

func set_dampening(value:float):
	dampening = value

#on instancing assign values
func _init(_tension:float, _dampening:float)->void:
	set_tension(_tension)
	set_dampening(_dampening)

#trigger with signal
func apply_impulse(impulse:Vector2)->void: #length of 10 works great
	velocity += impulse #Maybe needs to be negative impulse

#call from camera's _process()
func shake_process(delta:float)->Vector2:
	var displacement: = (targetPosition - shakePosition) * delta    #distance to center
	velocity += (displacement * tension) - (velocity * dampening)
	shakePosition += velocity
	return shakePosition
