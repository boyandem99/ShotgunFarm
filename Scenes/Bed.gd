extends StaticBody2D

func _ready() -> void:
	
	set_process_input(true)

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
				handle_bed_interaction()

func handle_bed_interaction() -> void:
	get_tree().change_scene_to_file("res://Scenes/Cutscene.tscn")
