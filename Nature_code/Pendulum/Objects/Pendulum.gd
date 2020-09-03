extends Position2D
#class_name Pendulum

var pivot_point:Vector2				 				#point the pendulum rotates around
export (Vector2) var end_position: = Vector2() 		#pendulum itself
var arm_length:float
var angle											#Get angle between position + add godot angle offset

export (float) var gravity = 0.4 * 60
export (float) var damping = 0.995 							#Arbitrary dampening force

var angular_velocity = 0.0
var angular_acceleration = 0.0

func _ready()->void:
	set_start_position(global_position, end_position)

func set_start_position(start_pos:Vector2, end_pos:Vector2):
	pivot_point = start_pos
	end_position = end_pos
	arm_length = Vector2.ZERO.distance_to(end_position-pivot_point)
	angle = Vector2.ZERO.angle_to(end_position-pivot_point) - deg2rad(-90)
	angular_velocity = 0.0
	angular_acceleration = 0.0

func process_velocity(delta:float)->void:
	angular_acceleration = ((-gravity*delta) / arm_length) *sin(angle)	#Calculate acceleration (see: http://www.myphysicslab.com/pendulum1.html)
	angular_velocity += angular_acceleration				#Increment velocity
	angular_velocity *= damping								#Arbitrary damping
	angle += angular_velocity								#Increment angle
	
	end_position = pivot_point + Vector2(arm_length*sin(angle), arm_length*cos(angle))

func add_angular_velocity(force:float)->void:
	angular_velocity += force

func _physics_process(delta)->void:
	game_input()											#example of in game swing kick
	
	process_velocity(delta)
	update()												#draw

func game_input()->void:
	var dir:float = 0
	if Input.is_action_just_pressed("right"):
		dir += 1
	elif Input.is_action_just_pressed("left"):
		dir -= 1
	add_angular_velocity(dir * 0.02) 						#give a kick to the swing

func _draw()->void:
	draw_line(Vector2.ZERO, end_position - pivot_point, Color.white, 1.0, false)
	draw_circle(end_position - pivot_point, 3.0, Color.red)
