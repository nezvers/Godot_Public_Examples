extends Position2D

onready var SpawnPosition: = $SpawnPosition					#for tracking Position2D where position bullets
onready var level: = get_tree().root.get_node('Level')		#level be used to hold spawned bullets. You can make it manage them as you need
export (PackedScene) var bullet_scene						#you can drop scene in the inspector and it preloads automatically
export (Array, float) var spread_angles: = [-45.0, -22.5, 0.0, 22.5, 45.0]	#choose angles for each bullet


func _draw()->void:											#draw aiming direction
	draw_line(position, SpawnPosition.position,Color.white)


func _process(_delta:float)->void:
	var mouse: = get_global_mouse_position()					#I like to bee fail safe and use global position
	global_rotation = (mouse-global_position).angle()			#Get angle to the mouse
	update() #call _draw()										#I'm drawing line as the pistol

func _unhandled_input(event)->void:
	if event.is_action_pressed("shoot"):
		shoot()

func shoot()->void:
	for angle in spread_angles:									#loop through each entry in Array
		var rad = deg2rad(angle)								#convert angle to radian
		var bullet:Sprite = bullet_scene.instance()
		bullet.global_position = SpawnPosition.global_position
		bullet.global_rotation = global_rotation + rad
		level.add_child(bullet)
