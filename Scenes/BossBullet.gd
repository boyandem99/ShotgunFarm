extends Area2D

class_name BossBullet

@export var speed = 300
@export var damage = 0
var velocity = Vector2.ZERO

func _process(delta):
	position += velocity * delta

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()
