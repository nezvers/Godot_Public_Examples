extends Node2D

onready var bulletParent: = $Bullets

func _ready()->void:
# warning-ignore:return_value_discarded
	Events.connect("spawn_bullet", self, "spawn_bullets")

func spawn_bullets(bullet_scene:PackedScene, pos:Vector2, dir:Vector2, rot:float)->void:
	var inst:Node2D = bullet_scene.instance()
	inst.pos = pos
	inst.dir = dir
	inst.rot = rot
	bulletParent.add_child(inst)
