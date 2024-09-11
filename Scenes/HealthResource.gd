extends Resource

@export var max_health: int
@export var current_health: int

func _init(_max_health: int = 100):
	max_health = _max_health
	current_health = max_health

func take_damage(amount: int) -> void:
	current_health = max(0, current_health - amount)

func heal(amount: int) -> void:
	current_health = min(max_health, current_health + amount)
