extends Node2D

export (NodePath) var navigation
export (NodePath) var nav_point_group
export (NodePath) var call_point
export (float) var speed = 150

onready var nav: Node2D = get_node(navigation)
onready var nav_points: Node2D = get_node(nav_point_group)
onready var call_node: Node2D = get_node(call_point)

var state: String = "idle"
var path : PoolVector2Array
var point_name: String

func _ready()->void:
	set_timer()
	Event.connect("Alert", self, "on_Alert_signal")

func _unhandled_input(event)->void:
	if event.is_action_pressed("action"):
		Event.emit_signal("Call")

func _process(delta: float)->void:
	if state != "idle":
		walk(delta)

func walk(delta: float) -> void:
	if !path:
		if state == "walk":
			set_timer()
			state = "idle"
		if state == "alert":
			set_timer()
			state = "idle"
	if path.size() > 0:
		var d: float = position.distance_to(path[0])
		if d > 10:
			position = position.linear_interpolate(path[0], (speed * delta)/d)
		else:
			path.remove(0)

func set_timer() ->void:
	$Timer.set_wait_time(rand_range(0.5,3))
	$Timer.start()
	print("Wait time ",$Timer.wait_time)

func set_path(pos: Node2D) ->void:
	if pos == null:
		if nav_points.get_child_count() > 0:
			var count: int = nav_points.get_child_count()
			var children = nav_points.get_children()
			var n = children[randi()%count]
			print("position chosen ", n.position)
			path = nav.get_simple_path(position, n.position, false)
	else:
		print("new position ", pos)
		path = nav.get_simple_path(position, call_node.position, false)

func on_Alert_signal():
	set_path(call_node)
	state = "alert"
	$Timer.stop()

func _on_Timer_timeout():
	state = "walk"
	print("time out")
	set_path(null)

func _on_Area2D_area_entered(area):
	point_name = area.get_parent().name
	print("name ",point_name)

func _on_Area2D_area_exited(area):
	point_name = ""
