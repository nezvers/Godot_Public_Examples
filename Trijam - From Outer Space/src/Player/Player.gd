extends Node2D

export (float) var beam_speed = 4 * 60

onready var parent = get_parent()
onready var ray:RayCast2D = $RayCast2D

signal move

var cow: Node2D = null
var cow_list: Array = []
var move:bool = true

func _ready():
	Event.connect("Text", self, "on_Text")
	Event.connect("Typing", self, "on_Typing")
	$Letters/Label.text = ""
	$Beam/Sprite.visible = false

func _process(delta):
	if move && ray.is_colliding():
		move = false
		emit_signal("move", move)
		$AnimationPlayer.play("Idle")
		cow = ray.get_collider().get_parent()
	
	if !move:
		if cow != null && cow.beam_me:
			cow.shape.disabled = true
			cow_list.append(cow)
			cow = null
			move = true
			emit_signal("move", move)
			$AnimationPlayer.play("Fly")
			$AudioStreamPlayer.play()
	
	cow_collector(delta)
			

func cow_collector(delta:float)->void:
	if cow_list.empty():
		$Beam/Sprite.visible = false
		$Beam/CPUParticles2D.emitting = false
		return
	$Beam/Sprite.visible = true
	$Beam/CPUParticles2D.emitting = true
	for c in cow_list:
		beam_cow(delta, c)
	

func beam_cow(delta:float, c)->void:
	c.global_position.x = global_position.x
	var dist: float = global_position.distance_to(c.global_position)
	if dist > beam_speed*delta:
		c.global_position = c.global_position.linear_interpolate(global_position, (beam_speed*delta)/dist)
	else:
		cow_list.pop_front()
		c.new_position()
		c.shape.disabled = false
		Event.points += 1

func on_Text(txt:String):
	$Letters/Label.text = ""

func on_Typing(txt:String):
	$Letters/Label.text = txt