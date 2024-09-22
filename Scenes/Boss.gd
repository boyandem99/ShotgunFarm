extends CharacterBody2D
class_name VampireBoss

@export var speed = 100
@export var damage = 10
@export var min_distance = 150
@export var buffer_distance = 10 
@export var max_shoot_interval = 3.0 
@export var bullet_number = 3 
@export var bullet_speed_min = 50
@export var bullet_speed_max = 200
@onready var boss_bullet_scene : PackedScene = preload("res://Scenes/BossBullet.tscn")
@onready var healthbar = $HealthBar
@onready var hit_flash_anim_player = $HitFlashAnimationPlayer
@onready var shooting_timer = $ShootingTimer
@export var health_resource : Resource = preload("res://Scenes/BossHealthResource.tres")
var player = null
var health = 10
var is_alive = true
var transformed = false

func _ready():
	health = health_resource.current_health
	healthbar.init_health(health_resource.max_health)
	player = get_tree().root.get_node("Main/Player")
	shooting_timer.wait_time = randf_range(1.0, max_shoot_interval)
	shooting_timer.start()
	$AnimatedSprite2D.play("none")
func take_damage(amount):
	health -= amount
	if amount > 0:
		hit_flash_anim_player.play("hit_flash")
	healthbar._set_health(health)
	
	if health <= 0:
		health = 0
		_die()
	elif health <= health_resource.max_health * 0.5 and transformed == false:
		transform_boss()

func transform_boss():
	transformed = true
	speed += 50
	damage += 10
	bullet_number += 3
	bullet_speed_min += 100
	bullet_speed_max += 150
	$AnimatedSprite2D.play("transform")

	# Tell the main scene to double the enemy spawn rate
	var main_scene = get_tree().root.get_node("Main")
	if main_scene:
		main_scene.set_spawn_rate(2.0)  # Double the spawn rate

func _die():
	is_alive = false
	get_tree().change_scene_to_file("res://Scenes/Victory.tscn")

func _physics_process(delta):
	var mouse_pos = get_global_mouse_position()

	if mouse_pos.x < global_position.x:
		$Sprite2D.flip_h = true
	else:
		$Sprite2D.flip_h = false
	if player:
		var direction = global_position.direction_to(player.global_position)
		var distance_to_player = global_position.distance_to(player.global_position)
		if distance_to_player > min_distance + buffer_distance:
			velocity = direction * speed
		elif distance_to_player < min_distance - buffer_distance:
			velocity = -direction * speed
		else:
			velocity = Vector2.ZERO

		move_and_slide()
		rotation = 0

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_hurtbox_body_entered(body):
	if body is Bullet:
		take_damage(body.damage)
		body.queue_free()

func _on_shooting_timer_timeout():
	var base_direction = global_position.direction_to(player.global_position)
	for i in range(bullet_number):
		var bullet = boss_bullet_scene.instantiate() as Area2D

		var shoot_angle_offset = 0.1 * (i - (bullet_number - 1) / 2.0) 
		var shoot_direction = base_direction.rotated(shoot_angle_offset)
		bullet.velocity = shoot_direction * randf_range(bullet_speed_min, bullet_speed_max)
		bullet.global_position = global_position
		bullet.damage = damage
		get_parent().add_child(bullet)
	
	shooting_timer.wait_time = randf_range(1.0, max_shoot_interval)
	shooting_timer.start()
