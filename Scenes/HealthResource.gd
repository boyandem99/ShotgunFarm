extends Resource
class_name HealthResource
@export var max_health: int = 100
@export var current_health: int = 100
@export var heal_amount: int = 0
@export var buff_type: String = ""
@export var buff_value: float = 1.0
@export var duration: float = 5.0
@export var texture: Texture2D

func _init(_max_health: int = 100):
	max_health = _max_health
	current_health = max_health

func take_damage(amount: int) -> void:
	current_health = max(0, current_health - amount)

func heal(amount: int) -> void:
	current_health = min(max_health, current_health + amount)
