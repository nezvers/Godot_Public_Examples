extends Button

export (String, FILE, "*.ogg") var audio_file
onready var player: AudioStreamPlayer = $Player 

func _ready():
	var sfx = load(audio_file) 
	player.stream = sfx



func _on_Button_mouse_entered():
	#player.play()
	pass


func _on_Button_pressed():
	player.play(false)
