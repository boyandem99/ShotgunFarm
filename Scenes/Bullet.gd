extends Area2D

class_name Bullet

@export var speed = 450
@export var damage = 15
var direction = Vector2.RIGHT

func _ready():
	pass

func _process(delta):
	position += direction * speed * delta

func _on_body_entered(body):
	if body is Player:
		return

	if body.has_method("take_damage"):
		body.take_damage(damage)
		queue_free()
