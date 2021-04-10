extends Node2D
#Influenced by
#The Coding Train - Coding Challenge #64.1: Forward Kinematics

class Segment:
	var start:Vector2
	var end:Vector2
	var length:float
	var angle:float
	var parentAngle:float = 0   #root doesn't have parent so needs default value
	var selfAngle:float
	var child:Segment = null
	var t:float = randf() * 360
	var angle_mod:float = 0
	func _init(_start:Vector2, _length:float, _angle:float):
		start = _start
		length = _length
		selfAngle = _angle
		calculate_end()
	func update_self()->void:
		# add some movement code
		t += randf() * (randi() % 8)
		angle_mod = sin(deg2rad(t)) * PI * 0.05
		update_angle()
		if child != null:
			child.update_self() # go down to next child
	func update_angle()->void:
		angle = parentAngle + selfAngle + angle_mod
		calculate_end()
	func calculate_end():
		end = Vector2(start.x + cos(angle)*length, start.y + sin(angle)*length)
		update_child_start()
	func update_child_start()->void:
		if child != null:
			child.start = end
			child.parentAngle = angle
	

var segments: Array         # used for drawing lines
var segment_count:int = 20
var root: Segment
onready var default_pos:Vector2 = get_viewport_rect().size * Vector2(0.5, 0.90)
var default_length:float = 15
var default_angle:float = -90


func _ready()->void:
	root = Segment.new(default_pos, default_length, default_angle)
	segments.append(root)           # used for drawing lines
	var current: Segment = root     # for iterration in for loop
	for _i in range(segment_count):
		var seg:Segment = Segment.new(current.end, default_length, 0)   #new segment
		current.child = seg     # add new segment as child
		current = seg           # next current will be new segment
		segments.append(seg)    # used for drawing lines

func _process(_delta)->void:
	root.selfAngle = (get_local_mouse_position() - root.start).angle()
	root.update_self()
	update()    #call draw call
	

func _draw()->void:
	var color: Color = Color.white
	var width:float = 1
	for seg in segments:
		var start:Vector2 = seg.start
		var end: Vector2 = seg.end
		draw_line(start, end, color, width)

func _unhandled_input(event):
	if event.is_action_pressed("mb_left"):
		root.start = get_local_mouse_position()
	if event.is_action_pressed("mb_right"):
		var a: = root.start
		var b: = get_local_mouse_position()
		var a1: = -(b-a).angle()
		root.selfAngle = a1
