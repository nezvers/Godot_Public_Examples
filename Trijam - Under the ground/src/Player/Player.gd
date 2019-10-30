extends KinematicBody2D
class_name Player

export (float) var speed_multiply = 10
onready var player: = get_node("../Player_pickup")
var base_speed: float = 10
var speed: float
var list: Array
var hurt: bool = false
var lives: int
var stop: bool = false

func _ready():
	Event.connect("Stop", self, "on_Stop")
	stats()
	print(speed)

func stats():
	speed = base_speed + Event.drill_speed * speed_multiply
	lives = Event.drill_max_lives

func on_Stop():
	stop = true

func _physics_process(delta):
	if stop:
		return
	move_and_slide(get_direction()*speed)
	clamp_position()
	check_collision()

func get_direction():
	var dir: = Vector2.ZERO
	dir.x = Input.get_action_strength("go_right") - Input.get_action_strength("go_left")
	dir.y = Input.get_action_strength("go_down") - Input.get_action_strength("go_up")
	rotation_degrees = lerp(rotation_degrees, 10 * dir.x, 0.1)
	return dir.normalized()

func clamp_position():
	position.x = clamp(position.x, 24, 296)
	position.y = clamp(position.y, 30, 178)
	if position.y > 178:
		death()

func _on_Area2D_body_entered(body):	#add to checklist
	if body == player:
		return
	list.insert(list.size(), body)

func _on_Area2D_body_exited(body):	#remove from checklist
	remove_from_list(body)

func check_collision():
	var count := get_slide_count()
	for col in range(count):
		var inst = get_slide_collision(col).collider
		if in_list(inst):
			inst.death()
		else:
			if inst is Enemy:
				inst.new_position()
				if !hurt:
					damage()

func in_list(body):
	for inst in list:
		if body == inst:
			return true
	return false

func remove_from_list(body):
	var index: int = 0
	for inst in list:
		if body == inst:
			list.remove(index)
			return
		index += 1

func damage():
	lives -= 1
	if lives <= 0:
		death()
		return
	hurt = true
	modulate = Color("#d9ff00")
	$Health_bar.visible = true
	$Health_bar.percent = get_lives()
	$Timer.start()
	Event.emit_signal("Spawn", pre_load.o_SoundPlayer, {sound=pre_load.snd_hit, volume=-0.0})

func get_lives()->float:
	return float(lives) / float(Event.drill_max_lives) * 100.0

func death():
	Event.emit_signal("Stop")
	Event.emit_signal("Spawn", pre_load.o_Death, {pos = global_position+ Vector2(0, -8)})
	Event.emit_signal("Spawn", pre_load.o_SoundPlayer, {sound=pre_load.snd_explode, volume=-4.0})
	queue_free()

func _on_Timer_timeout():
	hurt = false
	$Health_bar.visible = false
	modulate = Color("#ffffff")
