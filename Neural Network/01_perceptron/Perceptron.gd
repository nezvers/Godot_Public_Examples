extends Node
class_name Perceptron

var weights: Array = [0,0] 		#weight for each input
var learning_rate:float = 0.1	#Adjustment value when teaching

func _sign(value:float)->int:	#get answer RIGHT or WRONG
	if value >= 0:
		return +1
	else:
		return -1

func _ready()->void:
	for i in range(weights.size()):
		weights[i] = randf()*2 -1 #give some initial random value

func guess(inputs:Array)->int:
	var sum = 0
	for i in range(inputs.size()):
		sum+= inputs[i] * weights[i]	#weighting the inputs
	
	return _sign(sum)					#give answer

func train(inputs:Array, target:int)->bool:
	var guess:int = guess(inputs)						#do guesing on inputs
	var error:int = target - guess						#evaluate how correct the answer
	for i in range(weights.size()):						#go through input weights
		weights[i] += error * inputs[i] * learning_rate	#Adjust weights
	return guess == target								#Send guess result






