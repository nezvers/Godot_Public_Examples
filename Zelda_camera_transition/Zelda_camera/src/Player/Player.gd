extends KinematicBody2D
class_name Player

var speed: = 120
var velocity: = Vector2.ZERO


func _ready():
	Event.connect("transition", self, "on_transition")

func _unhandled_input(event):
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()
	elif event.is_action("exit"):
		get_tree().quit()

func _physics_process(delta):
	velocity = get_direction() * speed
	velocity = move_and_slide(velocity)

func get_direction():
	var dir: = Vector2.ZERO
	dir.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	dir.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	dir = dir.normalized()
	return dir

func on_transition(dir: Vector2):
	pass
