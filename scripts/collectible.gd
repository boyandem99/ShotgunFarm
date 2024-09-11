extends Area2D

@export var item: InvenItem

@onready var player = null




func _on_body_entered(body: Node2D) -> void:
	player.collect(item)
	queue_free()
