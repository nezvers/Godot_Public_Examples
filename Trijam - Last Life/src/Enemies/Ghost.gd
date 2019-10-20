extends Area2D

export (float) var wander_distance = 40.0
export (float) var speed = 30.0
export (float) var wander_speed = 15.0

enum {IDLE, WANDER, ATTACK}

onready var tilemap: TileMap = get_node("../../TileMap")

var state: int = IDLE
var target: Node2D = null
var goal: Vector2
var border: Vector2

func _ready()->void:
	start_idle()
	border = tilemap.map_to_world(tilemap.get_used_rect().end)

func _physics_process(delta):
	print()
	match state:
		WANDER:
			sm_wander(delta)
		ATTACK:
			sm_attack(delta)

#STATE STARTS
func start_idle()->void:
	state = IDLE
	$Timer.wait_time = randf() * 1
	$Timer.start()

func start_wander()->void:
	state = WANDER
	choose_goal()
	flip_sprite()

func start_attack()->void:
	state = ATTACK
	if target != null:
		goal = target.global_position
		flip_sprite()
	else:
		start_idle()

func choose_goal()->void:
	var dist: float = (randf()*wander_distance)		#random distance
	var dir: = Vector2(-1 + 2*randf(), -1 + 2*randf()).normalized() * dist	#random direction
	goal = global_position + dir
	goal.x = clamp(goal.x, 0, border.x)
	goal.y = clamp(goal.y, 0, border.y)

func flip_sprite()->void:
	if goal.x >= global_position.x:
		$Sprite.flip_h = false
	else:
		$Sprite.flip_h = true

#STATE FUNCTIONS
func sm_wander(delta: float)->void:
	var dist: float = global_position.distance_to(goal)
	if dist > wander_speed * delta:
		global_position = global_position.linear_interpolate(goal, (wander_speed * delta)/dist)
	else:
		global_position = goal
		start_idle()

func sm_attack(delta: float)->void:
	var dist: float = global_position.distance_to(goal)
	if dist > speed * delta:
		global_position = global_position.linear_interpolate(goal, (speed * delta)/dist)
	else:
		global_position = goal
		start_attack()

func _on_Timer_timeout()->void:
	if state == IDLE:
		start_wander()

func _on_Range_area_shape_entered(area_id, area, area_shape, self_shape)->void:
	if area.get_collision_layer_bit(1) && state != ATTACK:
		target = area.get_parent()
		start_attack()

func _on_Range_area_shape_exited(area_id, area, area_shape, self_shape)->void:
	if area.get_collision_layer_bit(1):
		target = null