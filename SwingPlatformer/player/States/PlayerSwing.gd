extends PlayerState
class_name PlayerSwing

var swing:Node2D = preload("res://utility/Swing.gd").new()
var rope:Line2D
var trigger: = true
var connection: = false
var point: = Vector2.ZERO
var distance: = 16.0 * 7.0
var move: = Vector2.ZERO
var dt: = 0.0
var prev_jump: = false		#checking for just_pressed
var swing_impulse: = 2.0

func _init(_sm).(_sm)->void:
	name = "Swing"
	rope = player.rope

func enter(_msg:Dictionary = {})->void:
	player.anim.play("Jump")
	trigger = true
	move = player.velocity
	#player.velocity = Vector2.ZERO
	prev_jump = player.jump

func exit()->void:
	rope.points = []
	var speed = swing.arm_length * swing.angular_velocity
	if connection:
		player.velocity += move.normalized() * abs(speed) / dt
		connection = false
	else:
		player.velocity = move
	print(speed)

func unhandled_input(event:InputEvent)->void:
	if event.is_action_released("click"):
		state_check()
	elif event.is_action_pressed("move_right"):
		swing.add_angular_velocity(swing_impulse)
	elif event.is_action_pressed("move_left"):
		swing.add_angular_velocity(-swing_impulse)
	else:
		player.unhandled_input(event)

func physics_process(_delta:float)->void:
	if trigger:
		get_point()
		if connection:
			set_pendulum()
	if !connection:													#Failed connection
		player.air_physics_process(_delta)
		state_check()
		return
	if is_equal_approx(_delta, 0.0):		#in case going to divide by 0
		return
	dt = _delta
	var swing_move:Vector2 = swing.process_velocity(_delta)
	move = swing_move / _delta
	var collision = player.move_and_collide(move* _delta)
	
	if player.jump && !prev_jump: 
		player.jump_impulse()
		sm.transition_to("Jump")
		return
	prev_jump = player.jump
	
	if collision:
		move = Vector2.ZERO
		var ang_vel = swing.angular_velocity * -0.5
		set_pendulum()
		swing.angular_velocity = ang_vel
	
	var offset: = point - rope.global_position
	rope.points = PoolVector2Array([offset+swing.end_position, offset+swing.pivot_point])
	

func process(_delta:float)->void:
	player.direction.x = sign(move.x)
	player.visual_process(_delta)

func state_check()->void:
	if player.is_grounded:
		if abs(player.direction.x) > 0.01:
			sm.transition_to("Walk")
		else:
			sm.transition_to("Idle")
	else:
		sm.transition_to("Jump")

func get_point()->void:
	trigger = false
	var from:Vector2 = rope.global_position
	var toDir:Vector2 = (rope.get_global_mouse_position() - from).normalized()
	var to:Vector2 = from + toDir*distance
	
	var space_state = rope.get_world_2d().direct_space_state
	var result = space_state.intersect_ray(from, to, [], 1)
	if result:
		connection = true
		point = result.position

func set_pendulum()->void:
	swing.set_start_position(Vector2.ZERO, rope.global_position-point)
	#swing.apply_impulse_vector(player.velocity*dt)
	player.velocity = Vector2.ZERO
