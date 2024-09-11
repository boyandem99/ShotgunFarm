extends Sprite2D

@export var item: InvenItem

@export var player = null



func _on_area_2d_body_entered(body: Node2D) -> void:
	player.connect(item)
