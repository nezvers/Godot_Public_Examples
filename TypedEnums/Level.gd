extends Node2D


class EnumClass:
	const One: = 1
	const Str: = "Something"
	const Dic: = {name = "Dic"}


func _ready()->void:
	var one: = DataClass.TypedEnumOne
	print(one)
	
	var named:int = DataClass.StdNamed.ENUM_ONE
	print(named)
	
	var Dic: = EnumClass.Dic
	print(Dic)

