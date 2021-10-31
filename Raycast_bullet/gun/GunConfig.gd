extends Resource
class_name GunConfig

enum bullet {RAYCAST}

export (float) var speed: float = 120.0 *60
export (float) var speed_fall: float = 10.0
export (float) var fade_time: float = 0.5
export (float) var life_time:float = 0.3
export (int) var bounces: int = 6

export (int) var bullet_count: int = 1
export (float) var bullet_spread: float = 0.0
export (float) var interval: float = 0.2
export (float) var random_spread:float = PI * 0.01

export (bullet) var bullet_type:int

export (float) var kickStrength:float = 0.5 * 60;
