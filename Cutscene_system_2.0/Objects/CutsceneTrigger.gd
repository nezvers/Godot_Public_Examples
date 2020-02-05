extends Area2D
class_name CutsceneTrigger

var triggering_object: Object = null		#will be used to reference object

var pattern:Dictionary = {}
var order: Array = []

func _ready()->void:
	connect("body_entered", self, "_on_Trigger_body_entered")

#Virtual function where to add pattern list
func set_pattern()->void:
	pass

func _on_Trigger_body_entered(body):
	if !Cutscene.pattern.empty():			#check if cutscene is busy
		return
	triggering_object = body
	pattern.clear()	#clear previous pattern list
	set_pattern()
	Cutscene.start(pattern)


#************** Add to pattern functions ***************
func add_wait(duration:float)->void:
	pattern[pattern.size()] = {
		'cutscene_method' : "wait",
		'cutscene_arguments' : duration
	}
func add_call_method(object:Object, method:String, parameters:Array)->void:
	pattern[pattern.size()] = {
		'cutscene_method' : "call_method",
		'cutscene_arguments' : [object, method, parameters ]
	}
func add_multi_call_method(method_list:Array)->void:
	pattern[pattern.size()] = {
		'cutscene_method' : "multi_call_method",
		'cutscene_arguments' : method_list
	}
func add_interpolate_value(object: Object, property: NodePath, initial_val, final_val, duration: float, trans_type: int = 0, ease_type: int = 2, delay: float = 0)->void:
	pattern[pattern.size()] = {
		'cutscene_method' : "interpolate_value",
		'cutscene_arguments' : [object, property, initial_val, final_val, duration, trans_type, ease_type, delay]
	}
func add_multi_interpolate_value(interpolate_list:Array)->void:
	pattern[pattern.size()] = {
		'cutscene_method' : "multi_interpolate_value",
		'cutscene_arguments' : interpolate_list
	}
func add_move(relative:bool, global:bool, object:Object, position:Vector2, duration:float, delay:float)->void:
	pattern[pattern.size()] = {
		'cutscene_method' : "move",
		'cutscene_arguments' : [relative, global, object, position, duration, delay]
	}
func add_multi_move(move_list:Array)->void:
	pattern[pattern.size()] = {
		'cutscene_method' : "move",
		'cutscene_arguments' : move_list
	}
#Create an object that needs to be instanced
func add_create_object(object: Object, parent:Node, global_pos: Vector2)->void:
	pattern[pattern.size()] = {
		'cutscene_method' : "move",
		'cutscene_arguments' : [object, parent, global_pos]
	}
#Functions for multi versions
func single_method(object:Object, method:String, parameters:Array)->Array:
	return [object, method, parameters]
func single_interpolate_value(object: Object, property: NodePath, initial_val, final_val, duration: float, trans_type: int = 0, ease_type: int = 2, delay: float = 0)->Array:
	return[object, property, initial_val, final_val, duration, trans_type, ease_type, delay]
func single_move(relative:bool, global:bool, object:Object, position:Vector2, duration:float, delay:float)->Array:
	return [relative, global, object, position]

