extends State
class_name PlayerState

var player: KinematicBody2D

func _init(_sm).(_sm)->void:	#inheriting script needs to call .(argument) from inherited scripts
	player = sm.owner			#to make easier referencing later  for player methods and nodes

