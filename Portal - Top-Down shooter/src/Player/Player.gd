extends KinematicBody2D

export (float) var max_speed_default = 120.0

enum {NORMAL, KICKBACK, DEAD}
onready var sprite: = get_node("Body/AnimatedSprite")

var max_speed: float = max_speed_default
var velocity: = Vector2.ZERO

var CursorPos: = Vector2.ZERO
var state: int = NORMAL
var invulnerable: bool = false
var blink_speed: float = 0.06

func _ready():
	Event.player = self
	Event.connect("CursorMoved", self, "on_CursorMoved")
	Event.emit_signal("PlayerMoved", global_position)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$Blink.wait_time = blink_speed
	Stats.score = 0
	Stats.health = 10
	Stats.emit_signal("Score")
	$Sound.stream = pre_load.snd_player_hit

func _physics_process(delta):
	#Walk
	match state:
		NORMAL:
			velocity = get_direction() * max_speed
			velocity = move_and_slide(velocity)
		KICKBACK:
			velocity = move_and_slide(velocity)
	
	Event.emit_signal("PlayerMoved", global_position)
	
	#Set animation
	if velocity != Vector2.ZERO :
		sprite.play("Walk")
	else:
		sprite.play("Idle")
	
	#Flip sprite
	var dir: Vector2 = CursorPos - position
	if dir.x > 0:
		sprite.flip_h = false
	elif dir.x < 0:
		sprite.flip_h = true
	
	#Blink
	if invulnerable:
		if fmod($Invulnerable.time_left, (blink_speed*2)) > blink_speed:
			sprite.visible = false
		else:
			sprite.visible = true

static func get_direction()->Vector2:
	var dir = Vector2.ZERO
	dir.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	dir.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	dir = dir.normalized()
	
	return dir

func damaged(damage:float, direction: Vector2):
	if !invulnerable:
		state = KICKBACK
		velocity = direction * max_speed
		invulnerable = true
		sprite.material.set_shader_param("colour_mix", 1)
		$Invulnerable.start()
		$Kickback.start()
		$Blink.start()
		$Sound.play()
		Stats.emit_signal("Hit")
		Event.emit_signal("CameraImpulse", -direction*10)

func death():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Event.emit_signal("PlayerDead")
	Event.emit_signal("Spawn", pre_load.ps_player_death_anim, {pos=global_position, flip = sprite.flip_h})
	Event.emit_signal("Spawn", pre_load.ps_JustCamera, {pos=$Cam.global_position})
	queue_free()

func on_CursorMoved(pos: Vector2):
	CursorPos = pos

func _on_Blink_timeout():
	sprite.material.set_shader_param("colour_mix", 0)

func _on_Invulnerable_timeout():
	invulnerable = false
	sprite.visible = true

func _on_Kickback_timeout():
	state = NORMAL
