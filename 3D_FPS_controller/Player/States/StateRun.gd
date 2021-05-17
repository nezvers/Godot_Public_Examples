extends StateGrounded
class_name StateRun



# warning-ignore:unused_argument
func enter(data:Dictionary={})->void:
	entity.spd = entity.runSpd

func exit()->void:
	pass

func state_check()->void:
	if ground_state_check():
		return
	
	if entity.btnCrouch:
		sm.transition("Crouch")
		return
	if entity.dir.length() < 0.01:
		sm.transition("Idle")
	elif !entity.btnRun:
			sm.transition("Walk")
