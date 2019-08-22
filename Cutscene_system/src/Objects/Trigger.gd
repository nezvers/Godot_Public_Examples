extends Area2D

export (String, FILE, "*.gd") var pattern_script
onready var scr_load = load(pattern_script)
onready var scr = scr_load.new()
func _ready():
	#print(get_parent())
	add_child(scr)
	#scr._ready()
	#print(scr.pattern)

func _on_Trigger_body_entered(body):
	Cutscene.emit_signal("Cutscene", scr.pattern)
	pass