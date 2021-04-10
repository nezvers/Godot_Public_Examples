extends Node2D
#Influenced by
#The Coding Train - Coding Challenge #64.2: Inverse Kinematics

class Segment:
	var start:Vector2
	var end:Vector2
	var length:float
	var angle:float
	var parent: Segment
	func _init(_end:Vector2, _length:float, _angle:float):
		end = _end
		length = _length
		angle = _angle
		calculate_start()
	func update_self()->void:
		update_angle()
		if parent != null:
			parent.update_self() # go down to next parent
	func update_angle()->void:
		angle = (start-end).angle()
		calculate_start()
	func calculate_start():
		start = Vector2(end.x + cos(angle)*length, end.y + sin(angle)*length)
		update_parent_end()
	func update_parent_end()->void:
		if parent != null:
			parent.end = start

var segments: Array         # used for drawing lines
var segment_count:int = 20
var tentacle: Segment
var default_pos:Vector2 = Vector2(150, 90)
var default_length:float = 20
var default_angle:float = 0

func _ready()->void:
	tentacle = Segment.new(default_pos, 20, default_angle)
	segments.append(tentacle)           # used for drawing lines
	var current: Segment = tentacle     # for iterration in for loop
	for _i in range(segment_count):
		var seg:Segment = Segment.new(current.start, default_length, default_angle)   #new segment
		current.parent = seg        # add new segment as parent
		current = seg               # next current will be new segment
		segments.append(seg)        # used for drawing lines

func _process(_delta)->void:
	tentacle.end = get_local_mouse_position()
	tentacle.update_self()
	update()    #call draw call

func _draw()->void:
	var color: Color = Color.white
	var width:float = 1
	for seg in segments:
		var start:Vector2 = seg.start
		var end: Vector2 = seg.end
		draw_line(start, end, color, width)
