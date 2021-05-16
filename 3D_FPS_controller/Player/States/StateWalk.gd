extends StateGrounded
class_name StateWalk



# warning-ignore:unused_argument
func enter(data:Dictionary={})->void:
	entity.spd = entity.walkSpd

func exit()->void:
	pass

func state_check()->void:
	if ground_state_check():
		return
	if entity.dir.length() < 0.01:
		sm.transition("Idle")
	elif entity.btnRun:
			sm.transition("Run")
