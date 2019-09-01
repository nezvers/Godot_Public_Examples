extends Control

const sounds: Array = [
	"res://src/Assets/Sounds/Marker #1.wav",
	"res://src/Assets/Sounds/Marker #2.wav",
	"res://src/Assets/Sounds/Marker #3.wav",
	"res://src/Assets/Sounds/Marker #4.wav",
	"res://src/Assets/Sounds/Marker #5.wav",
	"res://src/Assets/Sounds/Marker #6.wav",
	"res://src/Assets/Sounds/Marker #7.wav",
	"res://src/Assets/Sounds/Marker #8.wav",
	"res://src/Assets/Sounds/Marker #9.wav",
	"res://src/Assets/Sounds/Marker #10.wav",
	"res://src/Assets/Sounds/Marker #11.wav",
	"res://src/Assets/Sounds/Marker #12.wav",
	"res://src/Assets/Sounds/Marker #13.wav",
	"res://src/Assets/Sounds/Marker #14.wav",
	"res://src/Assets/Sounds/Marker #15.wav",
	"res://src/Assets/Sounds/Marker #16.wav",
	"res://src/Assets/Sounds/Marker #17.wav",
	"res://src/Assets/Sounds/Marker #18.wav",
	"res://src/Assets/Sounds/Marker #19.wav",
	"res://src/Assets/Sounds/Marker #20.wav",
	"res://src/Assets/Sounds/Marker #21.wav",
	"res://src/Assets/Sounds/Marker #22.wav",
	"res://src/Assets/Sounds/Marker #23.wav",
	"res://src/Assets/Sounds/Marker #24.wav"
	]


onready var display: = $Display

var index: int = -1
var input: Array
var password: Array
var octave: int = 1
var level: int = 1
var score: int = 0

func _ready():
	set_password()
	score_update(0)
	display.text = ""
	Event.connect("Button", self, "on_button_pressed")

func _input(event):
	if event.is_action_pressed("0"):
		on_button_pressed("0")
	elif event.is_action_pressed("1"):
		on_button_pressed("1")
	elif event.is_action_pressed("2"):
		on_button_pressed("2")
	elif event.is_action_pressed("3"):
		on_button_pressed("3")
	elif event.is_action_pressed("4"):
		on_button_pressed("4")
	elif event.is_action_pressed("5"):
		on_button_pressed("5")
	elif event.is_action_pressed("6"):
		on_button_pressed("6")
	elif event.is_action_pressed("7"):
		on_button_pressed("7")
	elif event.is_action_pressed("8"):
		on_button_pressed("8")
	elif event.is_action_pressed("9"):
		on_button_pressed("9")
	elif event.is_action_pressed("*"):
		on_button_pressed("*")
	elif event.is_action_pressed("#"):
		on_button_pressed("#")
	elif event.is_action_pressed("p"):
		on_button_pressed("p")

func on_button_pressed(c: String):
	match c:
		"*":
			octave +=1
			octave %= 3
		"#":
			check_password()
		"p":
			play_code()
		_:
			enter_button(c)

func set_password():
	password = []
	for i in level:
		password.insert(i, randi()%10)

func enter_button(c: String):
	input.insert(input.size(), int(c))
	if input.size() > password.size():
		input.pop_front()
	display.text = array_to_string(input)
	if index == -1:
		play_sound(int(c))

func check_password():
	if input != password:
		wrong()
	else:
		correct()
		
	set_password()

func play_code():
	if index == -1:
		index+=1
	play_sound(password[index])

func play_sound(i: int):
	var sfx: String = sounds[i+(7*octave)]
	$Player.stream = load(sfx)
	$Player.play()

func array_to_string(arr:Array)->String:
	var s: String = ""
	for i in arr.size():
		s += String(arr[i])
	return s

func _on_Player_finished():
	if index!=-1:	#playing password state
		index +=1
		if index == password.size():	#done playing password
			index = -1
		else:
			play_sound(password[index])

func correct():
	display.text = ""
	input = []
	score_update(score+1)
	$Player.stop()
	index=-1
	$Player.stream = load("res://src/Assets/Sounds/Correct.wav")
	$Player.play()

func wrong():
	display.text = ""
	input = []
	score_update(0)
	$Player.stop()
	index=-1
	$Player.stream = load("res://src/Assets/Sounds/Wrong.wav")
	$Player.play()

func score_update(sc: int):
	score = sc
	level = floor(sc/2) +1
	level = clamp(level, 0, 6)
	$Level.text = "Level: " + str(level)
	$Score.text = "Score: " + str(score)




