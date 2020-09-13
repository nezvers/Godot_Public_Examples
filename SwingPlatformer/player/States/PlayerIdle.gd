extends PlayerState
class_name PlayerIdle


func _init(_sm).(_sm)->void:					#inheriting script needs to call .(argument) from inherited scripts
	name = "Idle"

func enter(_msg:Dictionary = {})->void:			#Called by StateMachine when transition_to("State")
	player.anim.play("Idle")					#call AnimationPlayer to play Idle animation

func exit()->void:
	pass

func unhandled_input(event:InputEvent)->void:
	player.unhandled_input(event)				#Player holds all global methods that is the same for most of the states

func physics_process(delta:float)->void:
	player.ground_physics_process(delta)

func process(delta:float)->void:
	player.visual_process(delta)				#Handle player turning + stretch and squash
	state_check()								#call check method if state need to be changed

func state_check()->void:
	if player.is_grounded:						#player has bool variable for reading if it is on ground
		if abs(player.direction.x) > 0.01:		#players movement is above treshold
			sm.transition_to("Walk")			#call StateMachine to change states
	else:
		sm.transition_to("Jump")


