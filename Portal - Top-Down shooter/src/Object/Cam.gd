extends Node2D

export (NodePath) var MAP #In level scene make player children editable

onready var player: = get_node("..")
onready var cursor: = get_node("../Cursor")

var pos: = Vector2.ZERO
var impulse_offset: = Vector2.ZERO

func _ready():
	Event.connect("CameraImpulse", self, "on_CameraImpulse")
	
	var map = get_node(MAP)
	var map_limits = map.get_used_rect()
	var map_cellsize = map.cell_size

	var cam = $Camera2D
	cam.limit_left = map_limits.position.x * map_cellsize.x
	cam.limit_right = map_limits.end.x * map_cellsize.x
	cam.limit_top = map_limits.position.y * map_cellsize.y
	cam.limit_bottom = map_limits.end.y * map_cellsize.y


func _process(delta):
	pos = global_position.linear_interpolate((player.global_position + cursor.global_position)/2, 0.5)
	global_position = pos + impulse_offset

func on_CameraImpulse(impulse: Vector2):
	$Tween.interpolate_property(self, "impulse_offset", impulse, Vector2.ZERO, 0.6, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$Tween.start()
