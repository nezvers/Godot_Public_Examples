extends Spatial

var LOD: = 2
onready var LOD0: = get_child(0)
onready var LOD1: = get_child(1)

func set_LOD(level:int)->void:	#LodManager calls this method to set instances LOD level
	match level:
		0:
			LOD0.visible = true
			LOD1.visible = false
		1:
			LOD0.visible = false
			LOD1.visible = true
		2:
			LOD0.visible = false
			LOD1.visible = false

func _ready()->void:
	set_LOD(2)
	#yield(owner, "ready")	#wait when Level sets LodManager grid
	LodManager.add_instance(self)
