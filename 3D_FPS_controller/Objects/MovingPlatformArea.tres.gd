extends Area

onready var prevPos: = global_transform.origin
var bodyArray: = []

func _ready()->void:
# warning-ignore:return_value_discarded
	connect("body_entered", self, "_body_entered")
# warning-ignore:return_value_discarded
	connect("body_exited", self, "_body_exited")

func _body_entered(body:Node)->void:
	bodyArray.append(body)


func _body_exited(body:Node)->void:
	bodyArray.erase(body)

func _physics_process(_delta:float)->void:
	var difference:Vector3 = global_transform.origin - prevPos
	for body in bodyArray:
		body.global_transform.origin += difference
	prevPos = global_transform.origin


