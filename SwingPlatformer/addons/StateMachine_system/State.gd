class_name State

var name:String			#Used when adding state into StateMachine to identify state
var sm					#StateMachine

func _init(_sm)->void:	#on .new() receives reference to it's StateMachine
	sm = _sm


#defined virtual methods that might be called in states
func enter(_msg:Dictionary = {})->void:
	pass

func exit()->void:
	pass

func unhandled_input(_event:InputEvent)->void:
	pass

func physics_process(_delta:float)->void:
	pass

func process(_delta:float)->void:
	pass

func state_check()->void:
	pass
