extends KinematicBody2D

export (float) var speed:float = 3 * 60
var velocity: Vector2

func _ready():
	randomize()
	velocity = Vector2.RIGHT.rotated(PI * randf()) * speed
	OS.center_window()

func _physics_process(delta):
	var collision = move_and_collide(velocity*delta)
	if collision:
		$ColorRect.color = Color(randf(), randf(), randf())
		velocity = velocity.bounce(collision.normal)