extends Camera

export (float) var interpolationSpeed:float = 25.0
export (int, LAYERS_2D_RENDER) var bodyMeshRenderLayer = 2
var physicsFPS: = Engine.iterations_per_second
onready var cameraPos:Spatial = get_parent()

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
