extends Node2D
#class_name Pendulum

var pivot_point:Vector2				 				#point the pendulum rotates around
export (Vector2) var end_position: = Vector2() 		#pendulum itself
var arm_length:float
var angle											#Get angle between position + add godot angle offset

export (float) var gravity = 0.2 * 60
export (float) var damping = 0.999 							#Arbitrary dampening force

var angular_velocity = 0.0
var angular_acceleration = 0.0

var enabled: = false setget set_enabled
func set_enabled(value:bool)->void:
	enabled = value
	update()

func set_start_position(start_pos:Vector2, end_pos:Vector2):
	pivot_point = start_pos
	end_position = end_pos
	arm_length = Vector2.ZERO.distance_to(end_position-pivot_point)
	angle = -(pivot_point-end_position).angle() - PI*0.5# - deg2rad(-90)
	angular_velocity = 0.0
	angular_acceleration = 0.0

func process_velocity(delta:float)->Vector2:
	angular_acceleration = ((-gravity*delta) / arm_length) *sin(angle)	#Calculate acceleration (see: http://www.myphysicslab.com/pendulum1.html)
	angular_velocity += angular_acceleration *60 * delta				#Increment velocity
	angular_velocity *= damping *60 * delta								#Arbitrary damping
	angle += angular_velocity *60 * delta								#Increment angle
	
	var pre_pos = end_position
	end_position = pivot_point + Vector2(arm_length*sin(angle), arm_length*cos(angle))
	return end_position - pre_pos

func add_angular_velocity(force:float)->void:
	force = force  / 60 * sign(cos(angle)) * sign(sin(angle+deg2rad(90)))
	angular_velocity += force

#func apply_impulse_vector(velocity)->void:
#	pass
#	#s = a * r
#	#a = r / s
#	var x:float = velocity.x * sign(cos(angle))
#	var y:float = velocity.y * sign(sin(angle))
#	if x == 0.0:
#		angular_velocity = 0.0
#	else:
#		angular_velocity = arm_length / x
#	if y == 0.0:
#		angular_velocity += 0.0
#	else:
#		angular_velocity += arm_length / y

func _draw()->void:
	if !enabled:
		return
	draw_line(Vector2.ZERO, end_position - pivot_point, Color.white, 1.0, false)


#func game_input()->void:
#	var dir:float = 0
#	if Input.is_action_just_pressed("right"):
#		dir += 1
#	elif Input.is_action_just_pressed("left"):
#		dir -= 1
#	add_angular_velocity(dir * 0.02) 						#give a kick to the swing

#func _ready()->void:
#	set_start_position(global_position, end_position)

#func _physics_process(delta)->void:
#	game_input()											#example of in game swing kick
#
#	process_velocity(delta)
#	update()												#draw
