extends Area2D

class_name Bullet

@export var speed = 300
@export var damage = 0
var direction = Vector2.RIGHT

func _ready():
	direction = Vector2.RIGHT.rotated(rotation)

func _process(delta):
	position += direction * speed * delta

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)  
	queue_free() 
