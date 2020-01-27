extends Position2D

onready var Origin:Vector2 = global_position 		#point the pendulum rotates around
export (Vector2) var Pendulum_position = Vector2() 	#pendulum itself
onready var arm_length = Vector2.ZERO.distance_to(Pendulum_position-Origin)
onready var angle = Vector2.ZERO.angle_to(Pendulum_position-Origin) - deg2rad(-90) #Get angle between position + add godot angle offset
export (float) var gravity = 0.4 * 60

var angular_velocity = 0.0
var angular_acceleration = 0.0
var damping = 0.995 #Arbitrary dampening force

func _draw()->void:
	draw_line(Vector2.ZERO, Pendulum_position - Origin, Color.white, 1.0, false)

func _physics_process(delta)->void:
	game_input()	#example of in game swing kick
	
	process(delta)
	update()	#draw

func process(delta:float)->void:
	angular_acceleration = ((-gravity*delta) / arm_length) *sin(angle)	#Calculate acceleration (see: http://www.myphysicslab.com/pendulum1.html)
	angular_velocity += angular_acceleration				#Increment velocity
	angular_velocity *= damping								#Arbitrary damping
	angle += angular_velocity								#Increment angle
	
	Pendulum_position = Origin + Vector2(arm_length*sin(angle), arm_length*cos(angle))

func game_input()->void:
	var dir:float = 0
	if Input.is_action_just_pressed("right"):
		dir += 1
	elif Input.is_action_just_pressed("left"):
		dir -= 1
	angular_velocity += dir * 0.18 #give a kick to the swing