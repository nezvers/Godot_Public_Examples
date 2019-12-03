
extends Camera2D

#Variables
export (float) var Tension: float = 0.025		setget set_tension
export (float) var Dampening:float = 0.025		setget set_dampening
export (float) var DampingRatio:float = 1.0		setget set_dampingRatio
var TargetPosition: Vector2 = Vector2.ZERO
var CurrentPosition:Vector2 = TargetPosition
var Velocity:Vector2 = Vector2.ZERO

func set_dampening(value:float)->void:
	Dampening = value
	Tension = Dampening / DampingRatio
	print("Dampening:", Dampening, ", Tension:", Tension, " ,Ratio:", DampingRatio)

func set_tension(value:float)->void:
	Tension = value
	Dampening = Tension * DampingRatio
	print("Dampening:", Dampening, ", Tension:", Tension, " ,Ratio:", DampingRatio)

func set_dampingRatio(value:float)->void:
	if value == 0:
		return
	DampingRatio = value
	Dampening = Tension * DampingRatio
	Tension = Dampening / DampingRatio
	print("Dampening:", Dampening, ", Tension:", Tension, " ,Ratio:", DampingRatio)

func _ready()->void:
	Event.connect("Camerashake", self, "apply_camerashake")

func _unhandled_input(event)->void:
	if event.is_action_pressed("click"):
		var strength: = 100.0
		var impulse: = Vector2(-strength/2 +(randf()*strength), -strength/2 +(randf()*strength))
		Event.emit_signal("Camerashake", impulse)

func _process(delta)->void: #Happens every frame
	camerashake() #Calculate shaking
	position = CurrentPosition #implemention is up to you

func camerashake()->void:
	var Displacement: = (TargetPosition - CurrentPosition)
	Velocity += (Tension * Displacement) - (Dampening * Velocity)
	CurrentPosition += Velocity

func apply_camerashake(impulse:Vector2)->void: #Trigger shaking
	Velocity += impulse #Maybe needs to be negative impulse