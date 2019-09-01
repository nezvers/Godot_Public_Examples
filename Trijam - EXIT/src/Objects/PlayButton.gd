extends TextureButton

func _ready():
	pass

func _on_Button_pressed():
	Event.emit_signal("Button", "p")