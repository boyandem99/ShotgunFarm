extends Area2D

class_name Bullet

@export var speed = 450
@export var damage = 10  
var direction = Vector2.RIGHT

func _ready():
	# Set direction initially if needed, but it will be overridden by shoot()
	pass

func _process(delta):
	position += direction * speed * delta

func _on_body_entered(body):
	if body is Player:
		return

	if body.has_method("take_damage"):
		body.take_damage(damage)
		queue_free()
