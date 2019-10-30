extends Control

var price_lives: int
var price_speed: int

func _ready():
	$AudioStreamPlayer.stream = pre_load.snd_click
	update()

func update():
	price_lives = Event.pickup_max_lives * Event.lives_price_multiply
	price_speed = Event.pickup_speed * Event.speed_price_multiply
	$"HBoxContainer/VBoxContainer/HBoxContainer/amount".text = str(Event.pickup_max_lives)
	$"HBoxContainer/VBoxContainer/HBoxContainer/Price".text = str(price_lives)
	$"HBoxContainer/VBoxContainer/HBoxContainer2/amount".text = str(Event.pickup_speed)
	$"HBoxContainer/VBoxContainer/HBoxContainer2/Price".text = str(price_speed)

func _on_Button_pressed():
	$AudioStreamPlayer.play()
	if Event.coins >= price_lives:
		Event.pickup_max_lives += 1
		Event.coins -= price_lives
		update()
		Event.emit_signal("Score")
	else:
		pass


func _on_Button2_pressed():
	$AudioStreamPlayer.play()
	if Event.coins >= price_speed:
		Event.pickup_speed += 1
		Event.coins -= price_speed
		update()
		Event.emit_signal("Score")
	else:
		pass
