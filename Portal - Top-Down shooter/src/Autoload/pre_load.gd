extends Node

#PackedScenes
onready var ps_bullet: PackedScene				= preload("res://src/Object/Bullet.tscn")
onready var ps_death_audio: PackedScene			= preload("res://src/Object/DeathSound.tscn")
onready var ps_player_death_anim: PackedScene 	= preload("res://src/Player/Player_death.tscn")
onready var ps_enemy1: PackedScene				= preload("res://src/Enemy/Enemy1.tscn")
onready var ps_portal: PackedScene				= preload("res://src/Object/Portal.tscn")
onready var ps_enemy_blood: PackedScene			= preload("res://src/VFX/Enemy_blood.tscn")
onready var ps_wall_partickle: PackedScene		= preload("res://src/VFX/Wall_partickle.tscn")
onready var ps_JustCamera: PackedScene			= preload("res://src/Object/JustCamera.tscn")

#Sounds
onready var snd_enemy_death:	= preload("res://src/SFX/Enemy_died2.wav")
onready var snd_shoot:			= preload("res://src/SFX/Shoot.wav")
onready var snd_enemy_hit:		= preload("res://src/SFX/Enemy_hit.wav")
onready var snd_portal:			= preload("res://src/SFX/Portal11.wav")
onready var snd_player_hit:		= preload("res://src/SFX/Player_hit3.wav")
onready var snd_player_death	= preload("res://src/SFX/Player_death.wav")
onready var snd_menu_enter		= preload("res://src/SFX/Menu5.wav")
onready var snd_menu_exit		= preload("res://src/SFX/menu2.wav")
