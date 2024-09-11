extends Node2D

var recoil_strength = 0.5
var recoil_time = 0.1
var original_position = Vector2.ZERO
var recoil_timer = 0.0
@export var bullet_scene: PackedScene
var shoot_cooldown = 0.5  
var time_since_last_shot = 0.0
@onready var shooting_sfx: AudioStreamPlayer2D = $"../shootingSFX"


@onready var audio_stream_player_2d: AudioStreamPlayer2D = $"../AudioStreamPlayer2D"

func _ready():
	original_position = position 

func _process(delta):
	aim_at_cursor()
	time_since_last_shot += delta
	if Input.is_action_pressed("shoot") and time_since_last_shot >= shoot_cooldown:
		
		time_since_last_shot = 0.0
		
	if recoil_timer > 0:
		recoil_timer -= delta
		if recoil_timer <= 0:
			position = original_position  

func aim_at_cursor():
	var mouse_pos = get_global_mouse_position()
	look_at(mouse_pos)
	$Sprite2D.flip_v = mouse_pos.x < global_position.x

func shoot():
	shooting_sfx.play()
	var bullet = bullet_scene.instantiate() as Area2D

	bullet.global_position = global_position

	var shoot_direction = (get_global_mouse_position() - global_position).normalized()
	bullet.set_direction(shoot_direction)

	get_tree().root.get_node("Main").add_child(bullet)

	recoil()

func recoil():
	audio_stream_player_2d.play()
	var mouse_position = get_global_mouse_position()
	var direction_to_cursor = (mouse_position - global_position).normalized()
	position -= direction_to_cursor * recoil_strength
	recoil_timer = recoil_time  
