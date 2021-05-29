extends Node
class_name StateMachine

export (bool) var inputProcess = true	#Enemies don't need input

var currentState:State
var stateList:Dictionary
var previousState:String = ""


func _ready()->void:
	set_process(false)
	set_physics_process(false)
	set_process_unhandled_input(false)


func _unhandled_input(event:InputEvent)->void:
	currentState.input(event)


func _process(delta:float)->void:
	currentState.process(delta)


func _physics_process(delta:float)->void:
	currentState.physics(delta)


#	Entity need to start StateMachine with first state
func start(stateName:String, data:Dictionary = {} )->void:
	set_process(true)
	set_physics_process(true)
	set_process_unhandled_input(inputProcess)
	if !stateList.has(stateName):
		return
	currentState = stateList[stateName]
	currentState.enter(data)


func transition(stateName:String, data:Dictionary = {} )->void:
	# must have the state in list or different state than current
	if !stateList.has(stateName) || stateName == currentState.name:
		return
	#print("Transition: ", stateName)
	currentState.exit()
	previousState = currentState.name
	currentState = stateList[stateName]
	currentState.enter(data)
