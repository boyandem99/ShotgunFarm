extends CharacterBody2D
class_name VampireBoss

@export var speed = 100
@export var damage = 10 # Damage dealt by each bullet
@export var min_distance = 150 # The distance boss tries to maintain from the player
@export var buffer_distance = 10 # Buffer area to avoid jittering
@export var max_shoot_interval = 3.0 # Maximum time between shots
@export var bullet_number = 3 # Number of bullets boss shoots at once
@export var bullet_speed_min = 200 # Minimum bullet speed
@export var bullet_speed_max = 400 # Maximum bullet speed
@export var boss_bullet_scene : PackedScene = preload("res://Scenes/BossBullet.tscn") # Bullet scene

@onready var healthbar = $HealthBar
@onready var hit_flash_anim_player = $HitFlashAnimationPlayer
@onready var shooting_timer = $ShootingTimer

@export var health_resource : Resource = preload("res://Scenes/BossHealthResource.tres")
var player = null
var health = 10
var is_alive = true

func _ready():
	health = health_resource.max_health
	healthbar.init_health(health)
	player = get_tree().root.get_node("Main/Player")
	shooting_timer.wait_time = randf_range(1.0, max_shoot_interval)
	#shooting_timer.connect("timeout", _on_ShootingTimer_timeout()) # Ensure the timer is connected
	shooting_timer.start() # Start the shooting timer

func take_damage(amount):
	health -= amount
	if amount > 0:
		hit_flash_anim_player.play("hit_flash")
	healthbar._set_health(health)
	if health <= 0:
		health = 0
		_die()

func _die():
	is_alive = false
	queue_free()

func _physics_process(delta):
	if player:
		var direction = global_position.direction_to(player.global_position)
		var distance_to_player = global_position.distance_to(player.global_position)
		if distance_to_player > min_distance + buffer_distance:
			# Player is far, move towards them
			velocity = direction * speed
		elif distance_to_player < min_distance - buffer_distance:
			# Player is too close, move away
			velocity = -direction * speed
		else:
			# Player is within stop zone, stop moving
			velocity = Vector2.ZERO

		move_and_slide()

		# Prevent boss rotation
		rotation = 0

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_hurtbox_body_entered(body):
	if body is Bullet:
		take_damage(body.damage)
		body.queue_free()

# Boss Shooting Logic
func _on_ShootingTimer_timeout():
	if player:
		# Calculate base direction towards the player
		var base_direction = global_position.direction_to(player.global_position)

		# Shoot `bullet_number` bullets with a spread
		for i in range(bullet_number):
			var bullet = boss_bullet_scene.instantiate() as Area2D # Use CharacterBody2D for the bullet

			# Offset the bullet direction to spread the bullets
			var shoot_angle_offset = 0.1 * (i - (bullet_number - 1) / 2.0) # Spread bullets evenly
			var shoot_direction = base_direction.rotated(shoot_angle_offset)
			bullet.velocity = shoot_direction * randf_range(bullet_speed_min, bullet_speed_max)
			bullet.global_position = global_position
			bullet.damage = damage
			get_parent().add_child(bullet)

		# Randomize the next shooting interval and restart the timer
		shooting_timer.wait_time = randf_range(1.0, max_shoot_interval)
		shooting_timer.start()
