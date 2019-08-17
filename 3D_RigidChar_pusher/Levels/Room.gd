extends Node

onready var timer = 30
onready var time = $GUI/Time
onready var count = $GUI/Count
onready var box_count = $Boxes.get_child_count()
export (String, FILE, "*.tscn") var next_scene

func restart():
	get_tree().reload_current_scene()

func next_room():
	get_tree().change_scene(next_scene)

func update_count():
	#box_count = $Boxes.get_child_count()
	count.text = "Boxes: " + String(box_count)
	if box_count == 0:
		next_room()

func _ready():
	update_count()

func _process(delta):
	if box_count>0:
		if ceil(timer)>0:
			timer -= delta
		else:
			restart()
	time.text = "Time: " + String(ceil(timer))
