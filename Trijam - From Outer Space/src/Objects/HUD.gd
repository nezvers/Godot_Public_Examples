extends CanvasLayer

func _ready()->void:
	Event.connect("Score", self, "on_Score")

func on_Score()->void:
	$HBoxContainer/VBoxContainer/Label.text = "Points: " + str(Event.points)
	$HBoxContainer/VBoxContainer/Label2.text = "Difficulity: " + str(Event.difficulity)