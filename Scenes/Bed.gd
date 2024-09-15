extends StaticBody2D

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("right_click") and Global.isDay:
		get_tree().change_scene_to_file("res://Scenes/Cutscene.tscn")
