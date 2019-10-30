extends Node

signal Spawn
signal Score
signal Stop

var coins: int = 0

var drill_speed: int = 1
var drill_max_lives: int = 1

var pickup_speed: int = 1
var pickup_max_lives: int = 1

var speed_price_multiply: int = 3
var lives_price_multiply: int = 2