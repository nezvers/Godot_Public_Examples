extends Area2D

export (float) var damage = 1
export (float) var speed = 5 * 60

var velocity: = Vector2.ZERO

func start(msg: Dictionary):
	position = msg.pos
	rotation = msg.dir.angle()
	velocity = msg.dir * speed
	scale.y = msg.scale

func _physics_process(delta):
	translate(velocity*delta)

func _on_Bullet_body_entered(body):
	if !body.has_method("damaged"):
		destroy()

func destroy():
	queue_free()
	pass


func _on_Bullet_area_entered(area):
	var body = area.get_node("..")
	body.damaged(damage, (body.position - position).normalized())
	Event.emit_signal("Spawn", pre_load.ps_enemy_blood, {pos = global_position, dir=position - body.position})
	destroy()
