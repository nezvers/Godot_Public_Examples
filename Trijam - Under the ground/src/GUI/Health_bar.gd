extends Node2D

var percent: float = 100 setget set_percent

func set_percent(value:float = 100):
	print(value)
	percent = value
	$Control/TextureProgress.value = value

func _process(delta):
	rotation = 0.0