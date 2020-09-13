extends Actor
class_name Player

onready var anim:AnimationPlayer = $AnimationPlayer
onready var audio:AudioStreamPlayer = $AudioStreamPlayer
onready var swing:Node2D = preload("res://utility/Swing.gd").new()

var scaler: = Vector2(1.0, 1.0)

var landed: = false
var velocity_previous: = Vector2.ZERO
var step_sounds: = [
	preload("res://assets/Steps_01.wav"),
	preload("res://assets/Steps_02.wav"),
	preload("res://assets/Steps_03.wav"),
	preload("res://assets/Steps_04.wav"),
	]

func unhandled_input(event)->void:
	if event.is_action("move_right"):
		move_right = Input.get_action_strength("move_right")
	elif event.is_action("move_left"):
		move_left = Input.get_action_strength("move_left")
	elif event.is_action("move_up"):
		move_up = Input.get_action_strength("move_up")
	elif event.is_action("move_down"):
		move_down = Input.get_action_strength("move_down")
	elif event.is_action_pressed("jump"):
		jump = true
	elif event.is_action_released("jump"):
		jump = false

func visual_process(delta:float):
	if abs(direction.x)>= 0.001:
		body.scale.x = sign(direction.x)
	
#	if !is_grounded:	#Stretch to the velocity
#		scaler.y = range_lerp(abs(velocity.y), 0.0, abs(jump_impulse), 0.85, 1.15)
#		scaler.x = range_lerp(abs(velocity.y), 0.0, abs(jump_impulse), 1.0, 0.85)
		
	scaler.x = lerp(scaler.x, 1.0, 7.0 * delta)
	scaler.y = lerp(scaler.y, 1.0, 7.0 * delta)
	
	body.scale = scaler * Vector2(sign(body.scale.x), 1.0)
	velocity_previous = velocity


func damage()->void:
	set_process(false)
	set_physics_process(false)
	anim.play("Idle")
	visible = false
	audio.volume_db = 0.0
	audio.stream = preload("res://assets/Die.wav")
	audio.play()
	yield(audio, "finished")
	#Event.emit_signal("reset")

func steps()->void:
	audio.stream = step_sounds[randi() % 4]
	audio.volume_db = -18.0
	audio.play()

func jumping()->void:
	scaler.y = range_lerp(abs(velocity.y), 1.0, abs(jump_impulse), 1.0, 1.75)
	scaler.x = range_lerp(abs(velocity.y), 1.0, abs(jump_impulse), 1.0, 0.65)
	audio.stream = preload("res://assets/Jump_01.wav")
	audio.volume_db = 0.0
	audio.play()

func land()->void:
	scaler.x = range_lerp(abs(velocity_previous.y), 0.0, abs(jump_impulse), 1.2, 1.25)
	scaler.y = range_lerp(abs(velocity_previous.y), 0.0, abs(jump_impulse), 0.8, 0.5)
	audio.stream = preload("res://assets/Landing.wav")
	audio.volume_db = 0.0
	audio.play()

















