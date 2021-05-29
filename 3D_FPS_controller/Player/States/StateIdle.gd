extends StateGrounded
class_name StateIdle


func state_check()->void:
	if ground_state_check():
		return
	if entity.btnCrouch:
		sm.transition("Crouch")
		return
	
	if entity.dir.length() >0.01:
		if entity.btnRun:
			sm.transition("Run")
		else:
			sm.transition("Walk")


# warning-ignore:unused_argument
func enter(data:Dictionary = {} )->void:
	entity.spd = entity.walkSpd
