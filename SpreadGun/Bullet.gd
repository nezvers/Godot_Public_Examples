extends Sprite

export (float) var speed: = 10.0 * 60.0

var velocity:Vector2

func _ready()->void:								#triggers when instance is put into the tree
	velocity = transform.x * speed					#transform.x is direction bullets right side is pointing to, meaning where it is pointing
	yield(get_tree().create_timer(2), "timeout")	#lazy version of timing bullets life
	queue_free()

func _physics_process(_delta:float)->void:
	translate(velocity*_delta)						#usualy for bullet is used Area2D and muved with translate()
