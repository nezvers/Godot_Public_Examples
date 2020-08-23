extends Actor
class_name Player

onready var anim:AnimationPlayer = $AnimationPlayer

enum {IDLE, WALK, JUMP}
var state: = IDLE
var prev_state: = state
var scaler: = Vector2(1.0, 1.0)

var landed: = false
var velocity_previous: = Vector2.ZERO

func _ready()->void:
	OS.center_window()
	pass

func _unhandled_input(event)->void:
	if event.is_action_pressed("jump"):
		jump = true
	elif event.is_action_released("jump"):
		jump = false
	elif event.is_action_pressed("reset"):
		get_tree().reload_current_scene()
	elif event.is_action_pressed("exit"):
		get_tree().quit()

func direction_logic()->void:
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

func _process(delta:float):
	if abs(direction.x)>= 0.001:
		body.scale.x *= sign(direction.x)
	
	state_check()
	
	#Stretch and squash
#	if !is_grounded:
#		scaler.y = range_lerp(abs(velocity.y), 0.0, abs(jump_impulse), 0.75, 1.25)
#		scaler.x = range_lerp(abs(velocity.y), 0.0, abs(jump_impulse), 1.25, 0.75)
#
#	if !landed && is_grounded:
#		land()
#		scaler.x = range_lerp(abs(velocity_previous.y), 0.0, abs(jump_impulse), 1.2, 1.25)
#		scaler.y = range_lerp(abs(velocity_previous.y), 0.0, abs(jump_impulse), 0.8, 0.5)
#
#	scaler.x = lerp(scaler.x, 1.0, 1.0 - pow(0.01, delta))
#	scaler.y = lerp(scaler.y, 1.0, 1.0 - pow(0.01, delta))
#
#	body.scale = scaler * Vector2(sign(body.scale.x), 1.0)
	
	landed = is_grounded
	velocity_previous = velocity

func state_check()->void:
	if is_grounded:
		if abs(direction.x) > 0.01:
			state = WALK
		else:
			state = IDLE
	else:
		state = JUMP
	
	if prev_state != state:
		match state:
			IDLE:
				anim.play("Idle")
			WALK:
				anim.play("Walk")
			JUMP:
				anim.play("Jump")
	
	prev_state = state

func damage()->void:
	pass


func jump()->void:
	pass

func land()->void:
	pass


onready var GunPos: = $Body/GunPosition
var gun_data: = {
	normal = preload("res://Guns/Gun.tscn"),
	automatic = preload("res://Guns/Automatic.tscn"),
	spread = preload("res://Guns/Spread.tscn")
}
func equip_gun(gun_type:String):
	for gun in GunPos.get_children():	#if there is gun remove it
		gun.queue_free()
	
	var gun:Sprite = gun_data[gun_type].instance()
	GunPos.add_child(gun)














