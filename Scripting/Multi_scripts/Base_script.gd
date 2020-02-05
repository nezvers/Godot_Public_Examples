extends Sprite

export(Script) var script1
var scriptInstance

func _ready():
	scriptInstance = script1.new() #not added as child floats doesn't trigger ready/ process etc
	print(scriptInstance.num) #access variables in it

func _physics_process(delta):
	translate( scriptInstance.script_process(delta) )	#call functions but it's bad use case in example
