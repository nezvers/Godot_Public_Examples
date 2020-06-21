extends Node

# Bitmasked button system

var p1: int = 0
enum {
	UP = 1,
	DOWN = 2,
	LEFT = 4,
	RIGHT = 8,
	JUMP = 16,
	ACTION1 = 32
}

func _input(event):
	#Buttons pressed
	if event.is_action_pressed("move_up"):
		p1 |= UP
	elif event.is_action_pressed("move_down"):
		p1 |= DOWN
	elif event.is_action_pressed("move_left"):
		p1 |= LEFT
	elif event.is_action_pressed("move_right"):
		p1 |= RIGHT
	elif event.is_action_pressed("jump"):
		p1 |= JUMP
	elif event.is_action_pressed("action1"):
		p1 |= ACTION1
	elif event.is_action_released("move_up"):
	#Button released
		p1 &= ~UP
	elif event.is_action_released("move_down"):
		p1 &= ~DOWN
	elif event.is_action_released("move_left"):
		p1 &= ~LEFT
	elif event.is_action_released("move_right"):
		p1 &= ~RIGHT
	elif event.is_action_released("jump"):
		p1 &= ~JUMP
	elif event.is_action_released("action1"):
		p1 &= ~ACTION1
	
	#if p1 & RIGHT:	#Buttons.p1 & Buttons.RIGHT
		#RIGHT IS PRESSED
