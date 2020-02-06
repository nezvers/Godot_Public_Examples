extends Node
signal cutscene_started
signal cutscene_ended

var pattern:Dictionary = {}
var index: int = -1			#for cycling through pattern order array
onready var timer:Timer = Timer.new()
onready var tween:Tween = Tween.new()
func _ready()->void:
	add_child(timer)
	timer.connect("timeout", self, "on_timeout")
	timer.one_shot = true
	add_child(tween)
	tween.connect("tween_all_completed", self, "on_tween_completed")

func on_timeout()->void:
	trigger_pattern()
func on_tween_completed()->void:
	trigger_pattern()

func start(msg:Dictionary)->void:
	if msg.empty():
		return
	pattern = msg.duplicate()
	trigger_pattern()
	emit_signal("cutscene_started")

func trigger_pattern()->void:
	index +=1
	if !pattern.has(index): #reached the end of pattern order
		clear_pattern()
		return
	var method: Dictionary = pattern[index]
	#for some reasons it doesn't work with callv() here
	call(method.cutscene_method, method.cutscene_arguments)

func clear_pattern()->void:
	index = -1
	pattern.clear()
	emit_signal("cutscene_ended")

#For single parameter change
func call_method(call:Array)->void:
	#instance			method		arguments in array
	call[0].callv(call[1], call[2])
	trigger_pattern()

#For multiple parameter change
func multi_call_method(multi_call:Array)->void:
	for call in multi_call:
		call[0].callv(call[1], call[2])
	trigger_pattern()

#Wait for next pattern entry
func wait(sec:float)->void:
	timer.wait_time = sec
	timer.start()

#Lerp the value
func interpolate_value(param:Array)->void:
	tween.interpolate_property(param[0], param[1], param[2], param[3], param[4], param[5], param[6], param[7])
	tween.start()

func multi_interpolate_value(multi_param:Array)->void:
	for param in multi_param:
		tween.interpolate_property(param[0], param[1], param[2], param[3], param[4], param[5], param[6], param[7])
	tween.start()
#For moving characters
func move(param:Array)->void:
	var relative:bool = param[0]
	var global:bool = param[1]
	
	var instance = param[2]
	var property:String = "global_position" if global else "position"
	var start_pos = instance.global_position if global else instance.position
	var target_pos:Vector2 = param[3] if !relative else start_pos + param[3]
	var sec:float = param[4]
	tween.interpolate_property(instance, property, start_pos, target_pos, sec, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0)
	tween.start()
func multi_move(move_list:Array)->void:
	for param in move_list:
		var relative:bool = param[0]
		var global:bool = param[1]
		
		var instance = param[2]
		var property:String = "global_position" if global else "position"
		var start_pos = instance.global_position if global else instance.position
		var target_pos:Vector2 = param[3] if !relative else start_pos + param[3]
		var sec:float = param[4]
		tween.interpolate_property(instance, property, start_pos, target_pos, sec, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0)
	tween.start()
#Create object
func create_object(object: Object, parent:Node, global_pos: Vector2, method: NodePath = '', arguments: Array = [])->void:
	var instance = object.instance()
	parent.add_child(instance)
	instance.global_position = global_pos
	if !method.is_empty():
		instance.callv(method, arguments)
	trigger_pattern()





