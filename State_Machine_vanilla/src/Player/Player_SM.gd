extends StateMachine

func _ready():
	#add_state("state_name", "function_name")
	add_state("idle", "sm_idle")
	add_state("walk", "sm_walk")
	add_state("jump", "sm_jump")
	call_deferred("set_state", states.idle) #Default state

func _state_logic(delta):	#process
	match state:
		states.idle:
			sm_idle(delta)
		states.walk:
			sm_walk(delta)
		states.jump:
			sm_jump(delta)

func _get_transition():	#switch logic
	match state:
		states.idle:
			if !parent.is_on_floor():
				return states.jump
			elif parent.direction.x != 0:
				return states.walk
		states.walk:
			if !parent.is_on_floor():
				return states.jump
			elif parent.direction.x == 0:
				return states.idle
		states.jump:
			if parent.is_on_floor():
				if parent.direction.x == 0:
					return states.idle
				else:
					return states.walk

func _enter_state(new_state, old_state):
	match new_state:
		states.idle:
			parent.anim_player.play("idle")
		states.walk:
			parent.anim_player.play("walk")
		states.jump:
			if parent.velocity.y < 0:
				parent.anim_player.play("jump")
			else:
				parent.anim_player.play("default")

func _exit_state(new_state, old_state):
	pass

func sm_idle(delta)->void:
	parent.get_move_direction()
	parent.apply_velocity(delta)
	parent.apply_physics(delta)

func sm_walk(delta)->void:
	parent.get_move_direction()
	parent.apply_velocity(delta)
	parent.apply_physics(delta)

func sm_jump(delta)->void:
	parent.get_move_direction()
	parent.apply_velocity(delta)
	parent.apply_physics(delta)
