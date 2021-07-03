extends Node2D

onready var bulletParent: = $Bullets

func _ready()->void:
# warning-ignore:return_value_discarded
	Events.connect("spawn_bullet", self, "spawn_bullets")

func spawn_bullets(scene:PackedScene, config:GunConfig, pos:Vector2, dir:Vector2, rot:float)->void:
	var inst:Node2D = scene.instance()
	inst.pos = pos
	inst.dir = dir
	inst.rot = rot
	inst.set_config(config)
	bulletParent.add_child(inst)
