extends Camera2D

const MAX_DISTANCE = 14
var target_distance = 0
var center_pos = position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = center_pos.direction_to(get_local_mouse_position())
	var target_pos = center_pos + direction * target_distance
	target_pos = target_pos.clamp(
		center_pos - Vector2(MAX_DISTANCE,MAX_DISTANCE),
		center_pos + Vector2(MAX_DISTANCE,MAX_DISTANCE)	
	)
	position = target_pos
	
func _input(event):
	if event is InputEventMouseMotion:
		target_distance = center_pos.distance_to(get_local_mouse_position()) / 3
