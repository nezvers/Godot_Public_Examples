extends Area2D

export (float) var speed: = 10.0 * 60.0
export (int) var damage: = 1
export (float) var lifetime: = 2.0

onready var timer: = $Timer
var velocity:Vector2
var spawner

func _ready()->void:
	timer.wait_time = lifetime
	timer.start()
	velocity = global_transform.x * speed			#fly to the direction x axis is pointing (gun changed global_rotation)
	set_as_toplevel(true)							#Make independent from parent movement
	
	timer.connect("timeout", self, "timeout")
	connect("body_entered", self, 'body_entered')


func _physics_process(_delta:float)->void:
	global_translate(velocity*_delta)

func body_entered(body:PhysicsBody2D)->void:
	if body is Actor:
		if body != spawner:
			body.damage()
	queue_free()

func timeout()->void:
	queue_free()
