extends KinematicBody2D
class_name Enemy

export (float) var max_speed = 10
export (float) var trigger_distance = 150
var speed:float = max_speed
var parent_speed:float
var target: KinematicBody = null
var player1: KinematicBody
var player2: KinematicBody
var stop: bool = false
var sounds:Array = [pre_load.snd_splash1,pre_load.snd_splash2,pre_load.snd_splash3]

func _ready():
	Event.connect("Stop", self, "on_Stop")
	parent_speed = get_parent().speed
	player1 = get_node("../Player_drill")
	player2 = get_node("../Player_pickup")
	new_sprite()

func on_Stop():
	stop = true

func _physics_process(delta):
	if stop:
		return
	move_and_slide(get_direction() * speed + Vector2(0, parent_speed))
	if position.y > 320 + 16:
		new_position()

func get_direction():
	var d1: float = global_position.distance_to(player1.global_position)
	var d2: float = global_position.distance_to(player2.global_position)
	if d1<trigger_distance || d1<trigger_distance:
		if d1 < d2:
			target = player1
		else:
			target = player2
	else:
		target = null
	if !target:
		return Vector2.DOWN
	else:
		return global_position.direction_to(target.global_position)

func new_position():
	position.x = 20+ randf()*(320-52)
	position.y = -16 -(randf()*64)
	new_sprite()

func new_sprite():
	if randf() >= 0.5:
		$Sprite.texture = pre_load.t_zombie
	else:
		$Sprite.texture = pre_load.t_sceleton

func death():
	sounds.shuffle()
	Event.emit_signal("Spawn", pre_load.o_SoundPlayer, {sound=sounds[0], volume=-11.0})
	new_position()