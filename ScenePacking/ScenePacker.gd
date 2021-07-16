class_name ScenePacker

static func create_package(_node:Node)->PackedScene:
	set_owner(_node, _node)
	var package: = PackedScene.new()
# warning-ignore:return_value_discarded
	package.pack(_node)
	return package

static func set_owner(_node:Node, _owner:Node)->void:
	for child in _node.get_children():
		child.owner = _owner
		set_owner(child, _owner)

