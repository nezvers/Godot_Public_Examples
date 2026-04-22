extends Node

@export var body:Body
@export var treshold:float = 120

func _ready()->void:
	body.body_entered.connect(on_body_entered)

func on_body_entered(_other:Node)->void:
	if _other is Body:
		# transfer push
		var other:Body = _other
		print(body.name, " = ", body.linear_velocity.length(), ", other = ", other.linear_velocity.length())
		if other.is_pushed && other.linear_velocity.length_squared() > (treshold * treshold):
			body.is_pushed = true
		elif body.is_pushed && body.linear_velocity.length_squared() > (treshold * treshold):
			other.is_pushed = true
