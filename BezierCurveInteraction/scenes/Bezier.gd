extends ColorRect

#Array of normalized values (0.0, 0.0) to (1.0, 1.0)
#Useful later to get values from start to end
var points: = []
func set_points()->void:
	points = [Vector2(0.0, 0.0)]
	for i in range(1, positions.size()-1):
		var p:Vector2 = positions[i] / (positions.back() - positions.front())
		points.append(p)
	points.append(Vector2(1.0, 1.0))

export (int) var handles: = 3 setget set_handles
func set_handles(value:int)->void:
# warning-ignore:narrowing_conversion
	handles = max(value, 2)
	points = [Vector2(0.0, 0.0)]
	var mid:int = handles - 2
	var div:float = 1.0 / (handles - 1)
	for i in mid:
		points.append((i+1) * div)
	points.append(Vector2(1.0, 1.0))
	set_positions()

#Resolution of the line
export (int) var resolution: = 5 setget set_resolution
func set_resolution(value:int)->void:
# warning-ignore:narrowing_conversion
	resolution = max(value, 2)
	set_handles(handles)


func _ready()->void:
# warning-ignore:return_value_discarded
	connect("mouse_entered", self, "mouse_entered")
# warning-ignore:return_value_discarded
	connect("mouse_exited", self, "mouse_exited")
	set_process(false)
	set_handles(handles)
	update()
	OS.center_window()

var hovering: = false
func mouse_entered()->void:
	set_process(true)
	hovering = true
	update()

func mouse_exited()->void:
	set_process(false)
	hovering = false
	update()

# Arbitrary rectangle padded and inverted Y direction
func get_area()->Rect2:
	var margin: = Vector2(10.0, 10.0)
	var size: = rect_size - margin * 2
	var origin: = rect_position + margin
	origin.y += size.y
	size.y *= -1
	return Rect2(origin, size)

# handle positions on the node
var positions: = []
func set_positions()->void:
	positions = []
	var rect: = get_area()
	for pos in points:
		var p:Vector2 = rect.position + rect.size*pos
		positions.append(p)
	get_bezier()

# find which is closest handle (-1 is none)
func get_closest_point()->int:
	var mPos: = get_local_mouse_position()
	var dist: = 30.0
	var index: = -1
	for i in range(1, positions.size()-1):
		var pDist:float = (mPos - positions[i]).length()
		if pDist < dist:
			dist = pDist
			index = i
	return index

var closest:int = -1
var dragging: = false
func _process(_delta:float)->void:
	closest = get_closest_point()
	if closest > -1 && Input.is_mouse_button_pressed(1):
		dragging = true
	else:
		dragging = false
	
	if dragging:
		var mouse: = get_local_mouse_position()
		positions[closest].x = clamp(mouse.x,positions.front().x, positions.back().x)
		positions[closest].y = clamp(mouse.y,positions.back().y, positions.front().y)
		get_bezier()
		set_points()
	update()

# plot the bezier 
var bezier: = []
func get_bezier()->void:
	bezier = []
	var div:float = 1.0 / resolution
	for i in resolution:
		var t:float = i*div
		bezier.append(bezier_interpolate(positions, t)[0])
	bezier.append(positions.back())

#recursive function that interpolates between lines down to last point
func bezier_interpolate(handlePoints:Array, t:float)->Array:
	var newHandles: = []
	for i in handlePoints.size()-1:
		var pos:Vector2 = handlePoints[i].linear_interpolate(handlePoints[i+1], t)
		newHandles.append(pos)
	if newHandles.size() == 1:
		return newHandles
	else:
		return bezier_interpolate(newHandles, t)

func _draw()->void:
	#draw points
	for i in positions.size():
		var pos:Vector2 = positions[i]
		var col: = Color.white
		var r: = 5.0
		if i == closest:
			r = 10.0
			if dragging:
				col = Color.red
		draw_arc(pos, r, 0.0, PI*2, 5, col)
	
	#draw bezier lines
	for i in bezier.size()-1:
		var p1:Vector2 = bezier[i]
		var p2:Vector2 = bezier[i+1]
		var col = Color.white
		draw_line(p1,p2,col)





