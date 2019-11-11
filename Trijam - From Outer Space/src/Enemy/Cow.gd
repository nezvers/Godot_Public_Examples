extends Node2D

var my_name: String = ""
var beam_me:bool = false
var on_screen:bool = false

func _ready():
	new_name()
	Event.connect("Text", self, "on_Text")

func new_position():
	beam_me = false
	rotation_degrees = 0
	global_position.y = randf() * 160 + 840
	global_position.x += 1920
	new_name()

func new_name():
	var size: int = Event.word_collection.size() -1
	my_name = Event.word_collection[randi() % size]
	$Letters/Label.text = my_name

func on_Text(txt:String):
	if my_name == txt:
		beam_me = true
		$Letters/Label.text = ""
