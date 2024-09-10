extends Node2D

var recoil_strength = 0.5
var recoil_time = 0.1
var original_position = Vector2.ZERO
var recoil_timer = 0.0
@export var bullet_scene: PackedScene
@export var bullet_count: int = 1
@export_range(0,360) var arc:float = 0
@export_range(0,20) var fire_rate:float = 0
var can_shoot = true
var shoot_cooldown = 0.5  
var time_since_last_shot = 0.0

func _ready():	
	original_position = position 

func _process(delta):
	aim_at_cursor()
	time_since_last_shot += delta
	if Input.is_action_pressed("shoot") and time_since_last_shot >= shoot_cooldown:
		shoot()
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
	if can_shoot:
		can_shoot = false
		for i in bullet_count:
			var bullet = bullet_scene.instantiate()
			bullet.position = global_position
			if bullet_count == 1:
				bullet.rotation = global_rotation
			else:
				var arc_rad = deg_to_rad(arc)
				var increment = arc_rad / (bullet_count - 1)
				bullet.global_rotation = (
				global_rotation + increment * i - arc_rad/2
			)
				get_tree().root.call_deferred("add_child", bullet)
				recoil()
		await get_tree().create_timer(1/fire_rate).timeout
		can_shoot = true

func recoil():
	var mouse_position = get_global_mouse_position()
	var direction_to_cursor = (mouse_position - global_position).normalized()
	position -= direction_to_cursor * recoil_strength
	recoil_timer = recoil_time  
