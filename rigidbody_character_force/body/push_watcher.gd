extends Node

@export var body:Body
@export var walk_velocity:WalkVelocity
@export var treshold:float = 120

## Gravity value is removed for treshold detection
@export var resist_gravity:bool = true

func _ready() -> void:
	body.is_push_changed.connect(on_is_push_changed)

func on_is_push_changed(value:bool)->void:
	set_process(value)

func _physics_process(_delta:float)->void:
	var velocity:Vector2 = body.linear_velocity
	if resist_gravity:
		velocity -= Gravity.velocity
	if velocity.length_squared() < (treshold * treshold):
		body.set_is_pushed(false)
