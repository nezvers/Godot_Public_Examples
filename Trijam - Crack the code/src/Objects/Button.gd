extends TextureButton

func _ready():
	$Label.text = name

func _on_Button_pressed():
	Event.emit_signal("Button", $Label.text)

