extends Node

signal Cutscene

var list: Dictionary = {}
var pattern: Dictionary
var index: Array
var func_name: String
var actor: Node2D
var start: = true	#at completing curent patern
var vec2: Vector2
var var_1
var var_2
var var_3
var time: = 0.0
var timeout: float

func _ready():
	set_process(false)	#disable further _process calling
	connect("Cutscene", self, "on_Cutscene_signal")

func _process(delta:float)->void:
	if list.empty():	#check if there's nothing
		print("empty")
		pattern.clear()
		set_process(false)	#disable further _process calling
		return
	else:
		match func_name:
			"move_to":
				move_to(delta)
			"wait":
				wait(delta)
			"relative_move_to":
				relative_move_to(delta)
			"change_variable":
				change_variable()
			_:										#default
				list.erase(index[0])
				index.pop_front()

func on_Cutscene_signal(msg: Dictionary):
	if list.empty():	#add only if list is empty
		list = msg.duplicate(true)
		index = list.keys()
		pattern = list.get(index[0])
		func_name = pattern.name
		set_process(true)
	pass

#Prepare for changing pattern or completing script
func pattern_end()->void:
	start = true
	list.erase(index[0])			#remove first pattern in the list
	index.pop_front()				#remove first pattern index
	if !list.empty():
		pattern = list.get(index[0])	#set current pattern
		func_name = pattern.name

func move_to(delta: float)->void:
	if start:
		actor = pattern.inst
		vec2 = pattern.pos
		var_1 = pattern.spd
		start = false
	var dist = actor.position.distance_to(vec2)
	if dist>var_1*delta:
		actor.position = actor.position.linear_interpolate(vec2, (var_1*delta)/dist)
	else:
		actor.position = vec2
		pattern_end()

func relative_move_to(delta: float)->void:
	if start:
		actor = pattern.inst
		vec2 = actor.position + pattern.pos
		var_1 = pattern.spd
		start = false
	
	var dist = actor.position.distance_to(vec2)
	if dist>var_1*delta:
		actor.position = actor.position.linear_interpolate(vec2, (var_1*delta)/dist)
	else:
		actor.position = vec2
		pattern_end()

func wait(delta: float):
	if start:
		start = false
		time = 0
		timeout = pattern.time
	time += delta
	if time>=timeout:
		pattern_end()

func change_variable():
	actor = pattern.inst
	if pattern.variable in actor:
		actor.set(pattern.variable, pattern.value)
	pattern_end()








