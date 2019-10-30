extends Node

#Objects
var o_coin: PackedScene = preload("res://src/Objects/Coin.tscn")
var o_BlockSmokes: PackedScene = preload("res://src/Objects/BlockSmokes.tscn")
var o_Death: PackedScene = preload("res://src/Objects/Death.tscn")
var o_SoundPlayer: PackedScene = preload("res://src/Objects/SoundPlayer.tscn")

#Sounds
var snd_coin: = preload("res://src/Sounds/Coin.wav")
var snd_collect: = preload("res://src/Sounds/Collect.wav")
var snd_explode: = preload("res://src/Sounds/Explode.wav")
var snd_hit: = preload("res://src/Sounds/Hit.wav")
var snd_rock: = preload("res://src/Sounds/Rock.wav")
var snd_splash1: = preload("res://src/Sounds/Splash_1.wav")
var snd_splash2: = preload("res://src/Sounds/Splash_2.wav")
var snd_splash3: = preload("res://src/Sounds/Splash_3.wav")
var snd_click: = preload("res://src/Sounds/Click.wav")

#Music
var m_underground: = preload("res://src/Sounds/NeZvers-Underground.ogg")
var m_trip: = preload("res://src/Sounds/NeZvers-Trip.ogg")

#Texture
var t_zombie: Texture = preload("res://src/Images/Enemy/Enemy1.png")
var t_sceleton: Texture = preload("res://src/Images/Enemy/Enemy2.png")