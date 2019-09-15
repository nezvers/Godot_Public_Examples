extends Node2D

export (NodePath) var Navigation
export (NodePath) var Map

func _ready():
	Event.NavigationNode = get_node(Navigation)	#Enemies will need Navigation
	Event.MapNode = get_node(Map)
	Event.connect("Spawn", self, "Spawn")

func _on_Gun_shoot(bullet, _position, _direction, _scale):
	var b = bullet.instance()
	add_child(b)
	b.start(_position, _direction, _scale)

func Spawn(inst, msg):
	var i = inst.instance()
	$YSort.add_child(i)
	i.start(msg)