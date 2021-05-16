extends State
class_name StateJump



# warning-ignore:unused_argument
func process(delta:float)->void:
	state_check()

# warning-ignore:unused_argument
func physics(delta:float)->void:
	entity.physics_air(delta)

# warning-ignore:unused_argument
func input(event:InputEvent)->void:
	entity.input(event)

func state_check()->void:
	if entity.isGrounded:
		if entity.dir.length() < 0.01:
			sm.transition("Idle")
		elif !entity.btnRun:
				sm.transition("Walk")
		else:
			sm.transition("Run")

