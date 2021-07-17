extends Node2D

const saveFile: = "res://SavedPackage.tscn" #or .scn for binary version
onready var original: = $Original/icon
onready var cloneParent: = $CloneParent
onready var label: = $CanvasLayer/Label
var createdPackage:PackedScene
var packageInstance:Node


func _ready()->void:
	OS.center_window()


func Randomize_pressed():
	original.modulate = Color(randf(), randf(), randf(), 1.0)
	for child in original.get_children():
		child.modulate = Color(randf(), randf(), randf(), 1.0)
	label.text = "Randomized"


func Package_pressed():
	createdPackage = ScenePacker.create_package(original)
	label.text = "Package created"


func Instance_pressed():
	if !createdPackage:
		print("No package to create an instance")
		return
	
	if packageInstance:
		packageInstance.queue_free()
	
	packageInstance = createdPackage.instance()
	cloneParent.add_child(packageInstance)
	label.text = "Instance created"


func Save_pressed():
	if !createdPackage:
		print("No package to save")
		return
	
	var error: = ResourceSaver.save(saveFile, createdPackage)
	if error != OK:
		push_error("An error occurred while saving the scene to disk.")
	label.text = "Package saved"
	


