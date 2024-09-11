extends Area2D

class_name Hurtbox

@export var damage := 1  

signal hurtbox_hit

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
		emit_signal("hurtbox_hit", body)
