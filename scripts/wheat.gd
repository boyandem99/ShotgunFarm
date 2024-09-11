extends Sprite2D

@export var item: InvenItem

@export var player = null



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player = body
		player.collect(item)
		queue_free()
