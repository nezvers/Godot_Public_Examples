extends Control

export var handleCount:int = 4 setget set_handleCount
func set_handleCount(value:int)->void:
# warning-ignore:narrowing_conversion
	handleCount = max(2, value)
	reset_handles()

export var resolution:int = 10 setget set_resolution
func set_resolution(value:int)->void:
# warning-ignore:narrowing_conversion
	resolution = max(2, value)

func get_area()->Rect2:
	var margin: = Vector2(10.0, 10.0)
	var size: = rect_size - margin * 2
	var origin: = margin
	origin.y += size.y
	size.y *= -1
	return Rect2(origin, size)

var handleList:Array
func reset_handles()->void:
	var area:Rect2 = get_area()
	handleList.clear()
	for i in handleCount:
		var perc:float = float(i)/float(handleCount-1)
		handleList.append(area.position+area.size*perc)
	update()


func _ready()->void:
	# warning-ignore:return_value_discarded
	connect("mouse_entered", self, "mouse_entered")
	# warning-ignore:return_value_discarded
	connect("mouse_exited", self, "mouse_exited")
	# warning-ignore:return_value_discarded
	connect("resized", self, "resized")
	set_process(false)
	set_handleCount(handleCount)

func resized()->void:
	var rect: = get_area()
	var start:Vector2 = handleList.front()
	var end:Vector2 = handleList.back()
	var dist: = end - start
	
	for i in handleList.size():
		var perc:Vector2 = (handleList[i] - start) / dist
		handleList[i] = rect.position + rect.size * perc
	update()

func point_in_rect(r:Rect2, p:Vector2)->bool:
	return p.x > r.position.x && p.x < r.position.x+r.size.x && p.y < r.position.y && p.y > r.position.y + r.size.y

var hovering: = false
func mouse_entered()->void:
	set_process(true)
	hovering = true
	update()

func mouse_exited()->void:
	set_process(false)
	hovering = false
	dragIndex = -1
	update()

var dragIndex: = -1
func get_closest_handle()->int:
	var dist:float = 30
	var mousePos: = get_local_mouse_position()
	var index: = -1
	for i in range(1, handleList.size()-1):
		var d:float = (mousePos - handleList[i]).length()
		if d < dist:
			dist = d
			index = i
	return index

# warning-ignore:unused_argument
func _process(delta:float)->void:
	if dragIndex == -1:
		dragIndex = get_closest_handle()
	if dragIndex != -1:
		if Input.is_mouse_button_pressed(1):
			var mousePos: = get_local_mouse_position()
			var rect: = get_area()
			if point_in_rect(rect, mousePos):
				mousePos.x = clamp(mousePos.x, rect.position.x, rect.position.x+rect.size.x)
				mousePos.y = clamp(mousePos.y, rect.position.y+rect.size.y, rect.position.y)
				handleList[dragIndex] = mousePos
				update()
			else:
				dragIndex = -1
				update()
		else:
			dragIndex = -1
			update()

func get_bezier_value(points:Array, perc:float)->Array:
	if points.size() == 1:
		return points
	var newPoints: = []
	for i in points.size()-1:
		var p:Vector2 = points[i] + (points[i+1] - points[i]) * perc
		newPoints.append(p)
	return get_bezier_value(newPoints, perc)

func _draw()->void:
	draw_handles(handleList, 5.0, 0.0)
	
	draw_bezier_2D(handleList, resolution)

func draw_handles(arr:Array, r:float, a:float, col1:Color=Color.white)->void:
	for i in arr.size():
		var pos:Vector2 = arr[i]
		draw_arc(pos, r, a, a+2*PI, 5, col1)

func draw_bezier_2D(h:Array, res:int, col:Color = Color.white)->void:
	var points: = []
	for i in res+1:
		var pos:Vector2 = get_bezier_value(h,i/float(res))[0]
		points.append(pos)
	
	for i in points.size()-1:
		draw_line(points[i], points[i+1], col)







