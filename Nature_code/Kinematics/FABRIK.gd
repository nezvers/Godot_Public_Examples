extends Node2D

var pinPos:Vector2
var endPos: = Vector2.ZERO
var errorMargin: = 0.1
var length: = 20.0
var segmentCount: = 20
var totalLength: = length *segmentCount
var posList: = []

#draw IK tentacle line
func _draw()->void:
	var col: = Color.white
	for i in posList.size() -1:
		var start:Vector2 = posList[i]
		var end: Vector2 = posList[i +1]
		draw_line(start, end, col, 1)

# option to move around the pinned point
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		endPos = get_local_mouse_position()
	elif event.is_action_pressed("mb_left"):
		pinPos = get_local_mouse_position()
		posList[0] = pinPos

func _ready()->void:
	pinPos = get_viewport_rect().size * Vector2(0.5, 0.9)
	
	# add point list including pinPos by default pointing up
	for i in segmentCount +1:
		posList.append(pinPos +(i *Vector2.UP *length))

func _process(_delta:float)->void:
	var distance:float = (endPos -pinPos).length()
	
	# out of reach, no point of IK
	if distance >= totalLength:
		straight_reach()
	else:
		var errorDist:float = (endPos -posList[posList.size() -1]).length()
		var itterations: = 0
		# limit the itteration count
		while errorDist > errorMargin && itterations < 10:
			backward_reach()	# start at endPos
			forward_reach()		# start at pinPos
			errorDist = (endPos -posList[posList.size() -1]).length()
			itterations += 1
	
	#draw the updated tentacle
	update()

func straight_reach()->void:
	var direction:Vector2 = (endPos -pinPos).normalized()
	for i in posList.size():
		posList[i] = pinPos +(i *direction *length)

func backward_reach()->void:
	var last: = posList.size() -1
	posList[last] = endPos
	for i in last:
		var p1:Vector2 = posList[last -i]
		var p2:Vector2 = posList[last -1 -i]
		var dir:Vector2 = (p2 -p1).normalized()
		p2 = p1 +(dir *length)
		posList[last -1 -i] = p2

func forward_reach()->void:
	posList[0] = pinPos
	for i in posList.size() -1:
		var p1:Vector2 = posList[i]
		var p2:Vector2 = posList[i +1]
		var dir:Vector2 = (p2 -p1).normalized()
		p2 = p1 +(dir *length)
		posList[i +1] = p2


