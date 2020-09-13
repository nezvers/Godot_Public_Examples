extends StateMachine
class_name PlayerStateMachine

export (String) var start_state

func _ready()->void:						#Set the first state
	yield(._ready(), "completed")			#Base class uses yield so need to wait when it is done
	
	if !states.has(start_state):			#check if state is in dictionary
		print("No state: ", start_state)	#Debug info when writing wrong state
		return
	state = states[start_state]				#set the first state
	state.enter()							#call enter method for the state in case it need some setup
	current_state = start_state				#Sets string with the name od state
