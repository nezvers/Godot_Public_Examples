extends State
class_name StateGrounded



# warning-ignore:unused_argument
func process(delta:float)->void:
	state_check()

# warning-ignore:unused_argument
func physics(delta:float)->void:
	entity.physics_ground(delta)

# warning-ignore:unused_argument
func input(event:InputEvent)->void:
	entity.input(event)

# common check for going out of grounded states
func ground_state_check()->bool:
	if !entity.isGrounded:
		sm.transition("Jump")
		return true
	return false
