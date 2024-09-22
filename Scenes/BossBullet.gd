extends Area2D

class_name BossBullet

@export var speed = 300
@export var damage = 20
var velocity = Vector2.ZERO
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _process(delta):
	position += velocity * delta
	animated_sprite.play("default")

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()
