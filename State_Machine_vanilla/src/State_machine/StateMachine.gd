#Taken from https://www.youtube.com/watch?v=BNU8xNRk_oU
extends Node
class_name StateMachine

var state: int	setget set_state
var previous_state: int
var states: = {}
var msg: = {} #if state start need parameter changes

onready var parent: = get_parent()

func _physics_process(delta)-> void:
	if state != null:
		_state_logic(delta)
		var transition = _get_transition()
		if transition != state || transition != null:
			set_state(transition)

func _state_logic(delta)-> void:
	pass

func _get_transition():
	return null

func _enter_state(new_state, old_state)-> void:
	pass

func _exit_state(new_state, old_state)-> void:
	pass

func set_state(new_state)-> void:
	if new_state == null:
		return
	previous_state = state
	state = new_state
	
	if previous_state != null:
		_exit_state(previous_state, new_state)
	if new_state != null:
		_enter_state(new_state, previous_state)

func add_state(state_name: String, function_name: String)-> void:
	states[state_name] = states.size()
