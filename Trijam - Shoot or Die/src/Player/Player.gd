extends Node2D

export (bool) var Player2 = false
export (float) var speed = 90
export (int) var BulletCount = 6

onready var pos= $Position2D
onready var mag: int = BulletCount

var can_move: bool = true

func _ready():
	Event.connect("Hit", self, "on_hit")

func _physics_process(delta):
	if !can_move:
		return
	rotation += deg2rad(speed * delta * get_direction())
	if get_shoot():
		shoot()

func get_direction()-> float:
	var dir: float = 0
	if Player2:
		dir = Input.get_action_strength("turn_right_p2") - Input.get_action_strength("turn_left_p2")
	else:
		dir = Input.get_action_strength("turn_right_p1") - Input.get_action_strength("turn_left_p1")
	return dir

func get_shoot()-> bool:
	if mag <= 0:
		return false
		
	var b = false
	if Player2:
		if Input.is_action_just_pressed("shoot_p2"):
			b = true
	else:
		if Input.is_action_just_pressed("shoot_p1"):
			b = true
	return b

func shoot():
	mag -= 1
	Event.emit_signal("Spawn", pre_load.o_bullet, {pos = pos.global_position, rot = pos.global_rotation})
	$AudioStreamPlayer.stream = pre_load.snd_shoot
	$AudioStreamPlayer.play()

func _on_Hitbox_body_entered(body):
	Event.emit_signal("Hit", Player2)
	var dir = get_angle_to(body.linear_velocity)
	
	Event.emit_signal("Spawn", pre_load.o_blood, {pos = body.global_position, rot = dir})
	$AudioStreamPlayer.stream = pre_load.snd_player_died
	$AudioStreamPlayer.play()

func on_hit():
	can_move = false
