extends Node

# Objects
var o_bullet: PackedScene = preload("res://src/Objects/Bullet.tscn")
var o_blood: PackedScene = preload("res://src/Objects/Blood.tscn")

#Sound Effects
var snd_menu_enter: AudioStreamSample = preload("res://src/Sound/Menu5.wav")
var snd_menu_exit: AudioStreamSample = preload("res://src/Sound/Menu.wav")
var snd_shoot: AudioStreamSample = preload("res://src/Sound/Player_hit.wav")
var snd_player_died: AudioStreamSample = preload("res://src/Sound/Player_died.wav")