tool
extends Node2D

export (Vector2) var size = Vector2(320,180) setget set_size
export (Vector2) var count = Vector2(3,2) setget set_count
export (Font) var FONT
export (int) var font_size = 16

var current_size: Vector2 = Vector2(0,0)
var current_count: Vector2 = Vector2(0,0)
var current_font = null
var current_font_size: = int(0)


func _draw()->void:
	draw_grid()
	draw_grid_index()

func _ready()->void:
	update()

func set_size(value:Vector2=Vector2(1,1))->void:
	size=value
	print("update the size")
	update()

func set_count(value:Vector2=Vector2(1,1))->void:
	count=value
	print("update the count")
	update()

func draw_grid()->void:
	var h: = int(count.x+1) #horizontal points
	var v: = int(count.y+1) #vertical points
	var start: = Vector2(0,0)#grid start
	var end: = Vector2(size.x*count.x, size.y*count.y)   #grid end
	
	for x in range(h):
		draw_line( Vector2(x*size.x, start.y), Vector2(x*size.x, end.y), Color(1,1,1,1), 1, false)
	
	for y in range(v):
		draw_line(Vector2(start.x, y*size.y), Vector2(end.x, y*size.y), Color(1,1,1,1), 1, false)

func draw_grid_index()->void:
	var offset: = Vector2(5, FONT.get_height())
	var h: = int(count.x) #horizontal points
	var v: = int(count.y) #vertical points
	
	for x in range(h):
		for y in range(v):
			draw_string ( FONT, Vector2((x*size.x)+offset.x, (y*size.y)+offset.y), str(x)+", "+str(y), Color( 1, 1, 1, 1 ), -1 )