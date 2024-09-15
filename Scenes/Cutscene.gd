extends Node2D

func _ready() -> void:
	$AnimationPlayer.play("Cutscene")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")
	Global.isDay = false
