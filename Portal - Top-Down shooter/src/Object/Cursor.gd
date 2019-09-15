extends Position2D

onready var viewport: = get_viewport()
onready var size = get_viewport().get_visible_rect().size

func _ready():
	Event.connect("PlayerDead", self, "on_PlayerDead")

func _process(delta):
	global_position = get_global_mouse_position()
	#position = viewport.get_mouse_position() - size/2
	Event.emit_signal("CursorMoved", global_position)

func on_PlayerDead():
	queue_free()