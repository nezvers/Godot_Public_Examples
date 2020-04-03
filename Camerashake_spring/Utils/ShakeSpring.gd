extends Object
class_name ShakeSpring

#Variables
var tension: 		= 0.4 *60
var dampening: 		= 0.2
var targetPosition: = Vector2.ZERO
var shakePosition: 	= Vector2.ZERO
var velocity: 		= Vector2.ZERO

func _init(_tension:float, _dampening:float)->void:
	tension = _tension *60
	dampening = _dampening

func shake_process(delta:float)->Vector2:
	var displacement: = (targetPosition - shakePosition)
	velocity += (tension * displacement) - (dampening * velocity)
	shakePosition += velocity * delta
	return shakePosition

func apply_impulse(impulse:Vector2)->void: #Trigger shaking
	velocity += impulse #Maybe needs to be negative impulse
