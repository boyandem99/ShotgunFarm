extends Area2D

class_name Bullet

@export var speed = 300
var direction = Vector2.ZERO  

func _ready():
	var mouse_position = get_global_mouse_position()
	direction = (mouse_position - global_position).normalized()
	rotation = direction.angle()

func _process(delta):
	position += direction * speed * delta  

func set_direction(dir: Vector2):
	direction = dir
