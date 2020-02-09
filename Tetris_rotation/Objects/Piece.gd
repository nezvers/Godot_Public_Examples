extends Node2D

enum {L, J, S, Z, T, I, O}

var block:PackedScene = preload("res://Objects/Block.tscn")
var block_positions:Array	#Array of vec2 for each block
var blocks:Array			#Array of block instances
var rotation_pos:int = 0	#Current rotation index
var id: int					#Tetris piece figure index

func _ready()->void:
	create_blocks()
	id = randi() % 7		#choose new piece
	block_positions = get_block_default_positions()
	
	var new_rot:int = randi() % 4
	block_positions = get_rotation_pos(new_rot, block_positions)
	rotation_pos = new_rot
	set_block_position()

func get_block_default_positions()->Array:
	var pos: Array
	match id:	#get Array of block positions
		L:
			pos = [
				Vector2(0,0),
				Vector2(-1,0),
				Vector2(1,0),
				Vector2(1,-1)
			]
		J:
			pos = [
				Vector2(0,0),
				Vector2(1,0),
				Vector2(-1,0),
				Vector2(-1,-1)
			]
		S:
			pos = [
				Vector2(0,0),
				Vector2(-1,0),
				Vector2(0,-1),
				Vector2(1,-1)
			]
		Z:
			pos = [
				Vector2(0,0),
				Vector2(1,0),
				Vector2(0,-1),
				Vector2(-1,-1)
			]
		T:
			pos = [
				Vector2(0,0),
				Vector2(-1,0),
				Vector2(1,0),
				Vector2(0,-1)
			]
		O:
			pos = [
				Vector2(0,0),
				Vector2(1,0),
				Vector2(0,-1),
				Vector2(1,-1)
			]
		I:
			pos = [
				Vector2(0,0),
				Vector2(-1,0),
				Vector2(1,0),
				Vector2(2,0)
			]
	return pos

func get_rotation_pos(rot_pos:int, block_pos:Array)->Array:
	rot_pos = 3 if rot_pos == -1 else rot_pos % 4	
	var trans = Transform2D()	#default rotation
	match rot_pos:	#rotate transform
		1:
			trans = trans.rotated(PI*0.5)
		2:
			trans = trans.rotated(PI)
		3:
			trans = trans.rotated(PI*1.5)
	
	for i in block_pos.size():		#Set positions to rotated position
		var x:float = block_pos[i].dot(trans.x)
		var y:float = block_pos[i].dot(trans.y)
		block_pos[i] = Vector2(x,y)
	
	var offset:Vector2 = get_offset(rot_pos)	#Get rotation offset
	for i in block_pos.size():					#Set positions to offset
		block_pos[i] += offset
	return block_pos

func get_offset(rot_pos:int)->Vector2:
	var offset:Array
	match id:
		L:
			offset = [
				Vector2(0,0),
				Vector2(0,0),
				Vector2(0,0),
				Vector2(0,0)
				]
		J:
			offset = [
				Vector2(0,0),
				Vector2(0,0),
				Vector2(0,0),
				Vector2(0,0)
				]
		T:
			offset = [
				Vector2(0,0),
				Vector2(0,0),
				Vector2(0,0),
				Vector2(0,0)
				]
		S:
			offset = [
				Vector2(0,0),
				Vector2(-1,0),
				Vector2(0,1),
				Vector2(0,0)
				]
		Z:
			offset = [
				Vector2(0,0),
				Vector2(-1,0),
				Vector2(0,1),
				Vector2(0,0)
				]
		O:
			offset = [
				Vector2(0,0),
				Vector2(-1,0),
				Vector2(-1,1),
				Vector2(0,1)
				]
		I:
			offset = [
				Vector2(0,0),
				Vector2(0,0),
				Vector2(-1,0),
				Vector2(0,1)
				]
	#print('rotation ', rot_pos, ' offset ', offset[rotation_pos] - offset[rot_pos])
	return offset[rotation_pos] - offset[rot_pos] 	#previous - new = end offset

func create_blocks()->void:
	for i in range(4):
		var b = block.instance()
		add_child(b)
		blocks.append(b)
	blocks[0].modulate = Color.green	#mark origin block

func set_block_position()->void:
	for i in blocks.size():
		blocks[i].position = block_positions[i]













