extends Camera

export (float) var interpolationSpeed:float = 25.0				#	Remove	camera movement jitter	(Thanks to Garbaj)
export (int, LAYERS_2D_RENDER) var bodyMeshRenderLayer = 2		#	Hide player mesh from camera

onready var cameraPos:Spatial = get_parent()

var physicsFPS: = Engine.iterations_per_second


func _ready()->void:
	cull_mask ^= bodyMeshRenderLayer
	set_as_toplevel(true)
	pass


func _process(delta:float)->void:
	var fps:float = Engine.get_frames_per_second()

	if fps > physicsFPS:
		global_transform = global_transform.interpolate_with(cameraPos.global_transform, interpolationSpeed *delta *fps/physicsFPS)
	else:
		global_transform = cameraPos.global_transform
