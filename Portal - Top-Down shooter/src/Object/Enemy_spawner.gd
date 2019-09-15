extends Node2D

export (int) var creature_limit = 10

onready var portal: PackedScene = pre_load.ps_portal

var creature_count: int = 0
var position_list: Array
var initiated: bool = false

func _ready():
	get_spawn_points()
	Event.connect("Killed", self, "on_Killed_signal")

func _process(delta):
	if !initiated:
		initiated = true
		populate()

func queue_free():
	print("dead")

func on_Killed_signal():
	creature_count -= 1
	create_spawn()

func get_spawn_points():
	position_list.clear()
	for child in get_children():
		position_list.insert(position_list.size(), child)

func populate():
	var times = creature_limit-creature_count
	for i in range(times):
		create_spawn()
		creature_count += 1

func create_spawn():
	var index: int = randi() % position_list.size()
	var pos: Vector2 = position_list[index].global_position
	Event.emit_signal("Spawn", portal, {pos = pos, inst = pre_load.ps_enemy1})