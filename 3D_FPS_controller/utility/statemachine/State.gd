extends Node
class_name State

export (NodePath) var smPath

var sm:Node
var entity:Node					#save reference to entity that will be controlled

func _ready()->void:
	sm = get_node(smPath)
	sm.stateList[name] = self		# State add itself to StateMachine (Node must be named corectly)
	entity = owner
	on_ready()


func on_ready()->void:
	pass

# warning-ignore:unused_argument
func process(delta:float)->void:
	pass

# warning-ignore:unused_argument
func physics(delta:float)->void:
	pass

# warning-ignore:unused_argument
func input(event:InputEvent)->void:
	pass

# warning-ignore:unused_argument
func enter(data:Dictionary={})->void:
	pass

func exit()->void:
	pass

func state_check()->void:
	pass
