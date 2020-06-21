extends Node2D
#thanks to The Coding Train
#https://youtu.be/ntKn5TPHHAk?list=PLRqwX-V7Uu6Y7MdSCaIfsxc561QI0U0Tb

var points:Array
onready var brain = $Perceptron		#our neiron

func _ready()->void:
	for i in range(200):			#count to 200
		var p:Point = Point.new()	#create new point
		add_child(p)
		points.append(p)			#add to the array

func _unhandled_input(event):
	if event.is_action_pressed("click"):		#trigger next round
		for pt in points:						#go through all points
			var inputs:Array = [pt.x, pt.y]		#input for guess
			var target:int = pt.label			#known answer
			var result:bool = brain.train(inputs, target)
			pt.right = result					#for visualization give point a value
			pt.update()							#redraw point
