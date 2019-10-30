extends StaticBody2D
class_name Block
onready var camera:Node2D = get_node("../../Camera")

var max_lives: int = 6
var lives: int = max_lives

func _process(delta):
	check_position()

func check_position():
	if global_position.y > camera.global_position.y + 180:
		new_position()

func new_position():
	global_position.y = camera.global_position.y -16 -(randf()*64)
	global_position.x = 16+ randf()*(320-48)

func death():
	lives -= 1
	if lives <= 0:
		lives = max_lives
		spawn()
		new_position()
		Event.emit_signal("Spawn", pre_load.o_SoundPlayer, {sound=pre_load.snd_rock, volume=-12.0})

func spawn():
	Event.emit_signal("Spawn", pre_load.o_BlockSmokes, {pos = global_position+Vector2(8,8)})
	if randf() > 0.8:
		Event.emit_signal("Spawn", pre_load.o_coin, {pos = global_position+Vector2(8,8)})