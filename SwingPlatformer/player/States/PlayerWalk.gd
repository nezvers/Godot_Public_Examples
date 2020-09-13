extends PlayerState
class_name PlayerWalk


func _init(_sm).(_sm)->void:
	name = "Walk"

func enter(_msg:Dictionary = {})->void:
	player.anim.play("Walk")

func exit()->void:
	pass

func unhandled_input(event:InputEvent)->void:
	player.unhandled_input(event)

func physics_process(delta:float)->void:
	player.ground_physics_process(delta)

func process(delta:float)->void:
	player.visual_process(delta)
	state_check()

func state_check()->void:
	if player.is_grounded:
		if abs(player.direction.x) < 0.01:
			sm.transition_to("Idle")
	else:
		sm.transition_to("Jump")
