tool
extends VBoxContainer

export (bool) var cut:bool = false setget set_cut
export (BitmapFont) var font:BitmapFont
export (Vector2) var glyphSize:Vector2 = Vector2(16,16) # include space to the right and bellow
export (String) var symbolsInTexture:String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890 .,:;()?!"
#include space symbol too


func set_cut(value:bool)->void:
	if !value:
		return
	if !font:
		print("!!! No font added !!!")
	_cut()
	$ResultLabel.set("custom_fonts/font", font)

func _cut()->void:
	font.clear()
	var texture:Texture = $FontTexture.texture
	var size:Vector2 = texture.get_size()
	font.add_texture(texture)
	font.height = glyphSize.y
	var width:int = size.x / glyphSize.x
	var x = 0
	var y = 0
	var rect = Rect2(Vector2(0.0,0.0), glyphSize)
	for i in symbolsInTexture.length():
		var c = symbolsInTexture[i]
		x = i % width
		y = i / width
		rect.position = glyphSize * Vector2(x,y)
		print(c.to_utf8()[0])
		font.add_char(c.to_utf8()[0], 0, rect)
	
	font.update_changes()
