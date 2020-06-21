extends Node2D


enum {PUNCH, KICK}
var timer:Timer
var Sequence:Array = []
var Moves:Dictionary = {
	"Punch Rain" : [PUNCH, PUNCH, PUNCH, PUNCH],
	"Kick Rain" : [KICK, KICK, KICK, KICK],
	"Alternate" : [PUNCH, KICK, PUNCH, KICK],
	"Heavy Blow" : [PUNCH, PUNCH, KICK, KICK]
	}
var Names:Array = Moves.keys()

func _ready()->void:
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 1
	timer.one_shot = true
	timer.connect("timeout", self, "on_timeout")
	$Label.text = str(Sequence)

func on_timeout()->void:
	print("timeout")
	if $Label.text == str(Sequence):
		$Label.text = "timeout"
	Sequence = [] #clear input sequence

func _input(event)->void:
	if not event is InputEventKey: #for particular example limit to keyboard
		return
	if not event.is_pressed():
		return
	if event.is_action_pressed("ui_right"):
		add_input_to_sequence(PUNCH)
	elif event.is_action_pressed("ui_left"):
		add_input_to_sequence(KICK)
	$Label.text = str(Sequence)
	timer.start() #reset timeout timer
	check_sequence()

func add_input_to_sequence(button:int)->void:
	Sequence.push_back(button)

func check_sequence()->void:
	for Name in Names:
		var combo:Array = Moves[Name] #Give sequence of current Combo
		var trim: = Sequence.duplicate() #next steps would alter original sequence
		trim.invert() #Because need to leave last entries
		trim.resize(combo.size()) #Trim to last needed count of entries
		trim.invert() #return to right order
		if trim == combo: #Combo match
			print("COMBO: ", Name)
			Sequence = [] #clear input sequence
			$Label.text = Name
			return
