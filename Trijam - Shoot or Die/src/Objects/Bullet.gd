extends RigidBody2D

const speed: float = 6*60.0

func start(msg):
	Event.connect("Stop", self, "on_stop")
	global_position = msg.pos
	global_rotation = msg.rot
	apply_impulse(Vector2.ZERO, Vector2(speed, 0).rotated(global_rotation))

func _physics_process(delta):
	pass

func on_stop():
	applied_force = Vector2.ZERO
	linear_velocity = Vector2.ZERO
	$CPUParticles2D.emitting = false