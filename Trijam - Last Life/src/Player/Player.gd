extends KinematicBody2D
class_name Player


export var max_speed_default: = Vector2(60.0, 200.0) 	#speed clamp X & Y
export var acceleration_default: = Vector2(240, 500.0)	#Acceleration & gravity
export var jump_impulse: = 160.0						#Jump force
export var friction_default: = 0.15						#Slipery stop

const FLOOR_NORMAL: = Vector2.UP

onready var sprite:AnimatedSprite = $Body/AnimatedSprite
onready var body: Node2D = $Body
onready var jump_buffer: Timer = $Jmp_buffer

var acceleration: = acceleration_default
var max_speed: = max_speed_default
var velocity: = Vector2.ZERO
var friction: = friction_default
var direction: = Vector2.DOWN
var grounded: bool = false

var can_move: bool = true
var current_animation: String = ""


func _physics_process(delta):
	if !can_move:
		return
	direction = get_move_direction()
	velocity = calculate_velocity(delta)
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() or jump_buffer.time_left != 0:
			velocity.y = -jump_impulse
			jump_buffer.stop()
			grounded = false
			$AudioStreamPlayer.play()
	velocity = move_and_slide(velocity, FLOOR_NORMAL)
	if grounded && !is_on_floor():
		jump_buffer.start()
	grounded = is_on_floor()
	set_animation()

func calculate_velocity(delta: float) -> Vector2:
	var new_velocity: = velocity #Use temporary variable in case we want to manipulate the value later
	#HORIZONTAL
	if direction.x != 0:
		new_velocity.x += direction.x * acceleration.x * delta
		new_velocity.x = clamp(new_velocity.x, -max_speed.x, max_speed.x)
	else: #deaccelerate X
		new_velocity.x = approach(new_velocity.x, 0, abs(new_velocity.x*friction))
	
	#VERTICAL
	if !is_on_floor() && Input.is_action_just_released("jump"):
		if new_velocity.y < -jump_impulse/5:
			new_velocity.y = -jump_impulse/5
	new_velocity.y += acceleration.y * delta
	new_velocity.y = clamp(new_velocity.y, -max_speed.y, max_speed.y)
	return new_velocity

static func get_move_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		1.0
	)

static func approach(start: float, end: float, amount: float):
	if (start < end):
	    return min(start + amount, end)
	else:
	    return max(start - amount, end)

func set_animation()->void:
	if is_on_floor():
		if direction.x != 0:
			sprite.play("Run")
		else:
			sprite.play("Idle")
	else:
		if velocity.y >= 0.0:
			sprite.play("Fall")
		else:
			sprite.play("Jump_up")
	if direction.x != 0:
		body.scale.x = direction.x

func _on_Hitbox_area_shape_entered(area_id, area, area_shape, self_shape):
	if area.get_collision_layer_bit(2):			#Enemy
		Event.keys = 0
		Event.locked = 0
		get_tree().reload_current_scene()
