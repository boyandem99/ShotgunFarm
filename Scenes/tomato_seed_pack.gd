extends StaticBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var selected: bool = false
var seed_type = 2

func _ready() -> void:
	animated_sprite_2d.play("idle")





func _physics_process(delta: float) -> void:
	if selected:
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("shoot") and selected:
		Global.plantSelected = null
		selected = false
	elif Input.is_action_just_pressed("shoot"):
		Global.plantSelected = seed_type
		selected = true
