tool
extends EditorPlugin

var button:Button
var selectedNodes:Array = []
var enabled: = false
var buttonEnabled = false

func _ready()->void:
	print("ready")
	plugin_on()

func enable_plugin()->void:
	plugin_on()

func disable_plugin()->void:
	plugin_off()

func reset(msg=null)->void:
	print(msg)
	button_off()

func plugin_on()->void:
	if enabled: return
	print("enabled")
	# SIGNALS
	connect("scene_changed", self, "reset")
	connect("scene_closed", self, "reset")
	connect("main_screen_changed", self, "reset")
	get_editor_interface().get_selection().connect("selection_changed", self, "selection_changed")
	selection_changed()
	enabled = true

func plugin_off()->void:
	print("disabled")
	if !enabled: return
	disconnect("scene_changed", self, "reset")
	disconnect("scene_closed", self, "reset")
	disconnect("main_screen_changed", self, "reset")
	get_editor_interface().get_selection().disconnect("selection_changed", self, "selection_changed")
	button_off()
	selectedNodes = []
	enabled = false

func button_on()->void:
	if buttonEnabled: return
	print("button on")
	button = Button.new()
	button.name = "ReSize"
	button.text = "ReSize"
	button.connect("pressed", self, "resize_pressed")
	add_control_to_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU, button)
	buttonEnabled = true

func button_off()->void:
	if !buttonEnabled: return
	print("button off")
	button.queue_free()
	buttonEnabled = false

func selection_changed()->void:
	button_off()
	selectedNodes = get_editor_interface().get_selection().get_selected_nodes()
	if selectedNodes.size() == 0:
		return
	for n in selectedNodes:
		if n is MeshInstance || n is CollisionShape:
			button_on()
			return

func resize_pressed()->void:
	for n in selectedNodes:
		if !n.filename.empty():
			print(n.name)
		
		if n is MeshInstance:
			var _scale: Vector3 = n.scale
			n.scale = Vector3(1,1,1)
			resize_mesh(n, _scale)
			for nc in n.get_children():
				if nc is PhysicsBody:
					nc.scale *= _scale
		elif n is PhysicsBody:
			var _scale = n.scale
			n.scale = Vector3(1,1,1)
			for nc in n.get_children():
				if nc is MeshInstance:
					var _nscale = _scale * nc.scale
					nc.scale = Vector3(1,1,1)
					resize_mesh(nc, _nscale)
				elif nc is CollisionShape:
					nc.scale *= _scale

func resize_mesh(mi:MeshInstance, _scale:Vector3)->void:
	#GET MATERIALS
	var mesh:Mesh = mi.mesh
	var meshMaterials: = []
	for i in mesh.get_surface_count():
		if mesh.surface_get_material(i) != null:
			meshMaterials.append(mesh.surface_get_material(i).duplicate())
	
	var instanceMaterials = []
	for i in mi.get_surface_material_count():
		if mi.get_surface_material(i) != null:
			instanceMaterials.append(mi.get_surface_material(i).duplicate())
	#MESH
	mi.mesh = mesh.duplicate()
	mesh = mi.mesh
	
	for i in meshMaterials.size():
		mesh.surface_set_material(i, meshMaterials[i])
	#SET MATERIALS
	for i in instanceMaterials.size():
		mi.set_surface_material(i, instanceMaterials[i])
	
	if mesh is CubeMesh:
		print(mesh.size, ' ', _scale, ' ')
		mesh.size *= _scale
