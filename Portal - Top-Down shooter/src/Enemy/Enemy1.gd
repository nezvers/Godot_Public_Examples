extends KinematicBody2D

export (float) var speed = 80
export (float) var health = 10
export (float) var damage = 1
export (float) var hit_time = 0.08

enum {IDLE, ATTACK, KICKBACK}

var state: = ATTACK
var velocity: = Vector2.ZERO
var Nav: Navigation2D
var PlayerPos: = Vector2.ZERO
var path: PoolVector2Array

func start(msg: Dictionary):	#Called by spawner
	position = msg.pos
	Nav = Event.NavigationNode
	$Sound.stream = pre_load.snd_enemy_hit
	Event.connect("PlayerMoved", self, "on_PlayerMoved")
	Event.connect("PlayerDead", self, "on_PlayerDead")
	get_path()

func _physics_process(delta:float):
	match state:
		ATTACK:
			move(delta)
		KICKBACK:
			kickback()
		IDLE:
			pass

func move(delta: float):
	if path.size() > 0:
		var d: float = position.distance_to(path[0])
		if d > speed*delta:
			look_at(path[0])
			var dir: Vector2 = (path[0] - position).normalized()
			velocity = dir * speed
			move_and_slide(velocity)
		else:
			if path.size() == 1:
				velocity = (path[0] - position) / delta
				move_and_slide(velocity)
				get_path()
			else:
				path.remove(0)

func kickback():
	move_and_slide(velocity)

func get_path():
	path = Nav.get_simple_path(position, PlayerPos, false)

func damaged(damage:float, direction: Vector2):
	state = KICKBACK
	velocity = direction * speed * 2
	$Kickback.wait_time = hit_time
	$Kickback.start()
	$Sound.play()
	Blink()
	health -= damage
	if health <= 0:
		death()

func Blink():
	$Blink.start()
	material.set_shader_param("colour_mix", 1)

func _on_Kickback_timeout():
	if state == ATTACK:
		get_path()
	elif state == KICKBACK:
		state = ATTACK

func death():
	Event.emit_signal("Killed")
	Event.emit_signal("Spawn", pre_load.ps_death_audio, {pos = global_position, sound = pre_load.snd_enemy_death})
	queue_free()

func _on_Blink_timeout():
	material.set_shader_param("colour_mix", 0)

func _on_Hitbox_area_entered(area):
	if area.name == "Hitbox":
		var body = area.get_node("..")
		body.damaged(damage, (body.position - position).normalized())

func on_PlayerMoved(pos: Vector2):
	PlayerPos = pos

func on_PlayerDead():
	state = IDLE