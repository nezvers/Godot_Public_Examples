extends Position2D
class_name Gun

var gun_index: = 0
var timer: = Timer.new()
var shooting: = false

var gunList: = [
	preload("res://gun/Revolver.tres"),
	preload("res://gun/AutomaticRiffle.tres"),
	preload("res://gun/Shotgun.tres")
]

var bulletList: = [
	preload("res://bullet/RaycastBullet.tscn")
]

func _ready()->void:
	timer.one_shot = true
	add_child(timer)
# warning-ignore:return_value_discarded
	timer.connect("timeout", self, "timeout")

func _unhandled_input(event:InputEvent)->void:
	if event.is_action_pressed("click"):
		if shooting:
			return
		shooting = true
		spawn_bullets()
	elif event.is_action_released("click"):
		shooting = false
		timer.stop()
	elif event.is_action_pressed("weapon_1"):
		gun_index = 0
	elif event.is_action_pressed("weapon_2"):
		gun_index = 1
	elif event.is_action_pressed("weapon_3"):
		gun_index = 2

func spawn_bullets()->void:
	var config:GunConfig = gunList[gun_index]
	timer.start(config.interval)
	var scene:PackedScene = bulletList[config.bullet_type]
	var angle:float = 0.0
	if config.bullet_count > 1:
		angle = deg2rad(config.bullet_spread) / (config.bullet_count -1)
	for i in config.bullet_count:
		var rad:float = angle * i - deg2rad(config.bullet_spread) * 0.5
		rad += config.random_spread * randf() - config.random_spread * 0.5
		var basisX: = global_transform.x.rotated(rad)
		Events.emit_signal("spawn_bullet", scene, config, global_position, basisX, global_rotation + rad)

func timeout()->void:
	if shooting:
		spawn_bullets()
