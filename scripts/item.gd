extends Node2D

var is_inside_ref: bool
var dragable: bool
var body_ref
var offset: Vector2
var initalPos: Vector2

func _process(delta: float) -> void:
	if dragable:
		if Input.is_action_just_pressed("shoot"):
			initalPos = global_position
			offset = get_global_mouse_position() - global_position
			Global.is_draging = true
		if Input.is_action_just_pressed("shoot"):
			global_position = get_global_mouse_position() - offset
		elif Input.is_action_just_released("shoot"):
			Global.is_draging = false
			var tween = get_tree().create_tween()
			if is_inside_ref:
				tween.tween_property(self, "position", body_ref.position, 0.2).set_ease(Tween.EASE_OUT)
			else:
				tween.tween_property(self, "position", initalPos, 0.2).set_ease(Tween.EASE_OUT)

func _on_area_2d_mouse_entered() -> void:
	if not Global.is_draging:
		dragable = true
		scale = Vector2(1.05, 1.05)




func _on_area_2d_mouse_exited() -> void:
	if not Global.is_draging:
		dragable = false
		scale = Vector2(1, 1)
		



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("dropabale2"):
		is_inside_ref = true
		body_ref = body



func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("dropabale2"):
		is_inside_ref = false
