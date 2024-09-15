extends Area2D

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed and Global.isDay:
		# Change the scene to the cutscene
		get_tree().change_scene_to_file("res://Scenes/Cutscene.tscn")
