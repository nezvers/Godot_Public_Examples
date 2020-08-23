extends Area2D

export (String) var gun_type = 'normal'

func _ready()->void:
	connect("body_entered", self, 'body_entered')



func body_entered(body:PhysicsBody2D)->void:
	if body is Actor:
		if body.has_method('equip_gun'):
			body.equip_gun(gun_type)
