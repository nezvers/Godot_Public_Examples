extends Node

@export var body:Body
@export var treshold:float = 120

func _ready() -> void:
	body.is_push_changed.connect(on_is_push_changed)

func on_is_push_changed(value:bool)->void:
	set_process(value)

func _physics_process(_delta:float)->void:
	if body.linear_velocity.length_squared() < (treshold * treshold):
		body.set_is_pushed(false)
