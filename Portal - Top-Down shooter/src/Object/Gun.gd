extends Node2D

onready var timer: = get_node("Timer")
onready var sprite: = $Sprite
onready var bullet: PackedScene = pre_load.ps_bullet

var can_shoot: = true
onready var player: = get_node("..")
onready var cursor: = get_node("../Cursor")
var PlayerPos: = Vector2.ZERO
var CursorPos: = Vector2.ZERO

func _ready():
	timer.wait_time = 0.13
	$Sound.stream = pre_load.snd_shoot

func _process(delta):
	var dir: Vector2 = (cursor.global_position - player.global_position).normalized()
	global_position = player.global_position + (dir * Vector2(4,2))
	look_at(cursor.global_position)
	
	#Flip sprite
	if dir.x > 0:
		sprite.scale.y = 1
	elif dir.x < 0:
		sprite.scale.y = -1
	
	#Shoot
	if Input.is_action_pressed("shoot") && can_shoot:
		Shoot()

func Shoot():
	can_shoot = false
	$Timer.start()
	$Sound.pitch_scale = 1 + (randf()*0.5 -0.25)
	$Sound.play()
	Event.emit_signal("Spawn", bullet, {pos = $Position2D.global_position, dir = Vector2.RIGHT.rotated(global_rotation), scale = sprite.scale.y})

func _on_Timer_timeout():
	can_shoot = true
