extends Spatial

var tree: = preload("res://Objects/Trees.tscn")
var grass: = preload("res://Objects/Grass.tscn")
onready var lod_parent: = $LOD_instances


func _ready()->void:
	OS.center_window()
	LodManager.set_grid_size( 8, Vector2(-50, -50), Vector2(100, 100))
	LodManager.set_target($Player)
	for i in 400:
		rand_lod_inst()
		yield(get_tree(), "idle_frame")		#give some pause on instancing


func rand_lod_inst()->void:
	var pos: = Vector3(randf()*100.0 - 50.0, 0.0, randf()*100.0 - 50.0)
	var inst: Spatial
	match randi() % 2:
		0:
			inst = tree.instance()
		1:
			inst = grass.instance()
	inst.global_transform.origin = pos
	lod_parent.add_child(inst)
