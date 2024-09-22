extends Area2D

class_name Hitbox

var damage: float = 10

signal hit_detected
	#
#func set_collision_shape(shape: Shape2D, size: Vector2):
	#var collision_shape = $CollisionShape2D
	#collision_shape.shape = shape
	#collision_shape.scale = size / collision_shape.shape.get_size()
	#
func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
		emit_signal("hit_detected", body)
