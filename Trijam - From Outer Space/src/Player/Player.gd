extends Node2D

export (float) var beam_speed = 8 * 60

onready var parent = get_parent()
onready var ray:RayCast2D = $RayCast2D

signal cow
signal collected

var cow: Node2D = null
var stopped:bool = false

func _ready():
	Event.connect("Text", self, "on_Text")
	Event.connect("Typing", self, "on_Typing")
	$Letters/Label.text = ""

func _process(delta):
	if ray.is_colliding() && !stopped:
		stopped = true
		emit_signal("cow")
		cow = ray.get_collider().get_parent()
		$AnimationPlayer.play("Default_animation")
	elif stopped:
		if cow.beam_me:
			beam_cow(delta)
			$Beam.visible = true
			$Beam/CPUParticles2D.emitting = true
			

func beam_cow(delta:float)->void:
	var dist: float = global_position.distance_to(cow.global_position)
	if dist > beam_speed*delta:
		cow.global_position = cow.global_position.linear_interpolate(global_position, (beam_speed*delta)/dist)
	else:
		cow.new_position()
		emit_signal("collected")
		stopped = false
		$AnimationPlayer.play("Fly")
		$Beam.visible = false
		$Beam/CPUParticles2D.emitting = false

func on_Text(txt:String):
	$Letters/Label.text = ""

func on_Typing(txt:String):
	$Letters/Label.text = txt

