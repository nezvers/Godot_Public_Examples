extends Sprite

export (float) var fire_rate = 0.2
export (bool) var single_shot = true
export (Array, int) var spread_angles = [0.0]
export (PackedScene) var bullet_scene

var can_shoot: = true
var shooting: = false setget set_shooting
onready var timer: = $Timer
onready var spawn_pos: = $Position2D
onready var anim: = $AnimationPlayer
onready var sound: = $AudioStreamPlayer

func _ready():
	timer.connect("timeout", self, 'timeout')
	timer.wait_time = fire_rate

func _unhandled_input(event):
	if event.is_action_pressed('shoot'):
		set_shooting(true)
	if event.is_action_released('shoot'):
		set_shooting(false)

func set_shooting(value:bool)->void:
	if value && can_shoot:
		shooting = true
		can_shoot = false
		shoot()
	elif !value:
		shooting = false


func timeout():
	if shooting:
		if !single_shot:
			shoot()
		else:
			can_shoot = true
			shooting = false
	else:
		can_shoot = true

func shoot()->void:
	timer.start()
	for angle in spread_angles:
		var bullet:Area2D = bullet_scene.instance()
		bullet.spawner = owner										#Add player as spawner
		bullet.rotation_degrees += angle
		add_child(bullet)											#smarter way is to signal to level for parenting somewhere else
	anim.play("Shoot")
	sound.play()
