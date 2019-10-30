extends Node2D

func _ready():
	Event.connect("Spawn", self, "on_Spawn")
	$AudioStreamPlayer.stream = pre_load.m_underground
	$AudioStreamPlayer.volume_db = -15.0
	$AudioStreamPlayer.play()

func on_Spawn(obj, msg:Dictionary = {}):
	var inst = obj.instance()
	$Items.add_child(inst)
	inst.start(msg)