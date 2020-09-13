extends Node
class_name StateMachine


export (Array, GDScript) var script_array:Array

var states: = {}					#Dictionary to hold all states with String key to acces them
var state							#Will hold reference to active State
var current_state: = ""				#String that will hold name of active state in case it is needed


func _ready()->void:				#Set the first state
	yield(owner, "ready")			#wait when scene root is ready because states need to fetch nodes in the scene
	
	for st in script_array:
		var inst = st.new(self)		#Create new instance of State
		var n:String = inst.name	#All States should set their names to create their keys for Dictionary
		states[n] = inst			#Put the state into Dictionary and use their name as key
	
	#Base class doesn't implement starting state, should be implemented by inherited script (Example PlayerStateMachine)


func _unhandled_input(event: InputEvent)->void:		#because it's defined in script the engine will call it
	state.unhandled_input(event)					#let the state to do what it needs to do with input

func _physics_process(delta:float)->void:
	state.physics_process(delta)					#state decides how to act during physics process

func _process(delta:float)->void:
	state.process(delta)

func transition_to(next_state: String, msg:Dictionary = {})->void:		#states call this when states need to be changed
	if !states.has(next_state):						#check if state is in dictionary
		print("No state: ", next_state)
		return
	
	var next = states[next_state]					#reference the next state
	state.exit()									#Allow old state to take care on it's exit method
	state = next									#set new state
	state.enter(msg)									#call entering state
	current_state = next_state						#if later need reference which is current state

