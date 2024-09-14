extends CharacterBody2D

class_name Player

var speed = 150
var dash_speed = 350
var dash_time = 0.2
var dash_cooldown = 1
var can_dash = true
var is_dashing = false
var dash_timer = 0.0
var cooldown_timer = 0.0
var invincible = false
var dash_direction = Vector2.ZERO
var counter: int = 1
var is_attacking = false
var health = 10
var recoil_strength = 0.5
var recoil_time = 0.1
var original_position = Vector2.ZERO
var recoil_timer = 0.0
var can_shoot = true
var shoot_cooldown = 0.5
var time_since_last_shot = 0.0
@onready var bullet_scene : PackedScene = preload("res://Scenes/Bullet.tscn") 
@onready var shooting_sfx: AudioStreamPlayer2D = $shooting_sfx
@onready var original_collision_layer = collision_layer
@onready var original_collision_mask = collision_mask
@onready var weapon = $WeaponFX
@onready var hitbox = null
@export var health_resource: Resource = preload("res://Scenes/PlayerHealthResource.tres")
@onready var healthbar = $HealthBar
@export var current_item: Item:
	set(value):
		current_item = value
		if current_item != null:
			if current_item.name == "Pitchfork":
				set_damage(current_item.damage)
			else:
				set_damage(1)

func set_damage(amount):
	if is_hitbox_ready():
		hitbox.damage = amount

func _ready():
	original_position = position
	Global.set_player_reference(self)
	health = health_resource.max_health
	healthbar.init_health(health)
	hitbox = $Hitbox
	_update()
	$Weapon.visible = false

func _update():
	if current_item != null:
		set_damage(current_item.damage)

func is_hitbox_ready() -> bool:
	return hitbox != null

func _input(event):
	if event.is_action_pressed("shoot"):
		play_animation()

func shoot():
	if current_item != null and bullet_scene and current_item.name == "Shotgun" :
		if can_shoot:
			shooting_sfx.play()
			can_shoot = false
			var bullet_arc_rad = deg_to_rad(current_item.arc)
			var bullet_count_half = (current_item.bullet_count - 1) / 2.0
			var mouse_pos = get_global_mouse_position()
			var base_direction = (mouse_pos - global_position).normalized()
			
			for i in range(current_item.bullet_count ):
				var bullet = bullet_scene.instantiate()
				bullet.position = global_position
				var angle_offset = (i - bullet_count_half) * (bullet_arc_rad / max(current_item.bullet_count - 1, 1))
				var spread_direction = base_direction.rotated(angle_offset)
				bullet.direction = spread_direction
				bullet.rotation = spread_direction.angle()
				get_tree().root.call_deferred("add_child", bullet)
			await get_tree().create_timer(1 / current_item.fire_rate).timeout
			can_shoot = true
	else:
		print(current_item,bullet_scene,Global.isDay )
func apply_buff(buff_resource: Resource) -> void:
	if buff_resource.buff_type == "heal":
		heal(buff_resource.heal_amount)
	elif buff_resource.buff_type == "speed":
		speed += buff_resource.buff_value
	elif buff_resource.buff_type == "damage":
		set_damage(hitbox.damage + buff_resource.buff_value)
	elif buff_resource.buff_type == "bullet_count":
		current_item.bullet_count += int(buff_resource.buff_value)
	elif buff_resource.buff_type == "invincibility":
		invincible = true
		await get_tree().create_timer(buff_resource.duration).timeout
		invincible = false

func combo(animation):
	if animation in ["fist"]:
		return "_" + str(counter)
	else:
		return ""

func play_animation():
	if current_item == null:
		weapon.play("fist" + combo("fist"))
	else:
		is_attacking = true
		$Weapon.texture = current_item.texture
		weapon.play(current_item.animation)

func _on_weapon_fx_animation_finished(anim_name):
	if current_item != null and anim_name == current_item.animation:
		is_attacking = false

func _process(delta):
	time_since_last_shot += delta
	if Input.is_action_pressed("shoot") and time_since_last_shot >= shoot_cooldown:
		shoot()
		time_since_last_shot = 0.0

	if recoil_timer > 0:
		recoil_timer -= delta
		if recoil_timer <= 0:
			position = original_position  

	var mouse_pos = get_global_mouse_position()
	$Weapon.look_at(mouse_pos)
	hitbox.look_at(mouse_pos)

	if mouse_pos.x < global_position.x:
		$AnimatedSprite2D.flip_h = false
		if is_hitbox_ready():
			hitbox.scale.x = -1
		$Weapon.flip_h = true
		$Weapon.flip_v = true
	else:
		$AnimatedSprite2D.flip_h = true
		$Weapon.flip_h = true
		$Weapon.flip_v = false

func _physics_process(delta):
	handle_movement(delta)
	handle_dash(delta)
	handle_continuous_damage(delta)  # Added function to handle continuous damage

func handle_movement(delta):
	if not is_dashing:
		velocity = Vector2.ZERO
		if Input.is_action_pressed("move_right"):
			velocity.x += 1
		if Input.is_action_pressed("move_left"):
			velocity.x -= 1
		if Input.is_action_pressed("move_down"):
			velocity.y += 1
		if Input.is_action_pressed("move_up"):
			velocity.y -= 1

		if velocity.length() > 0:
			velocity = velocity.normalized() * speed
			$AnimatedSprite2D.play("run")
		else:
			$AnimatedSprite2D.play("idle")
	move_and_slide()

func handle_dash(delta):
	if Input.is_action_just_pressed("dash") and can_dash:
		start_dash()

	if is_dashing:
		dash_timer -= delta
		if dash_timer > 0:
			velocity = dash_direction * dash_speed
		else:
			end_dash()

	if not can_dash:
		cooldown_timer += delta
		if cooldown_timer >= dash_cooldown:
			can_dash = true
			cooldown_timer = 0.0

func start_dash():
	is_dashing = true
	dash_timer = dash_time
	can_dash = false
	invincible = true
	collision_layer = 5
	collision_mask = 5
	dash_direction = velocity.normalized() if velocity.length() > 0 else Vector2(1, 0)
	var mouse_pos = get_global_mouse_position()
	if (mouse_pos.x - global_position.x) * dash_direction.x > 0:
		$AnimatedSprite2D.play("dash")
	else:
		$AnimatedSprite2D.play("back_dash")

func end_dash():
	is_dashing = false
	invincible = false
	collision_layer = original_collision_layer
	collision_mask = original_collision_mask
	velocity = Vector2.ZERO

func is_invincible():
	return invincible

func take_damage(amount: int):
	health -= amount
	healthbar._set_health(health)  # Update the healthbar immediately after damage
	if health <= 0:
		health = 0
		_die()

func _die():
	get_tree().change_scene_to_file("res://Scenes/Gameover.tscn")

#func _deferred_game_over():
	#get_tree().change_scene_to_file("res://Scenes/Gameover.tscn")
	#
func heal(amount: int):
	pass

signal hit

var colliding_enemies = []  # Track colliding enemies
var damage_per_second = 1  # Damage to apply per second
var damage_interval = 1.0  # Interval in seconds for applying damage
var time_since_last_damage = 0.0

func _on_hurtbox_body_entered(body):
	if body is Enemy:
		if not colliding_enemies.has(body):
			colliding_enemies.append(body)

func _on_hurtbox_body_exited(body):
	if body is Enemy:
		colliding_enemies.erase(body)

func handle_continuous_damage(delta):
	time_since_last_damage += delta
	if colliding_enemies.size() > 0 and time_since_last_damage >= damage_interval:
		for enemy in colliding_enemies:
			if enemy:
				take_damage(damage_per_second * damage_interval)
		time_since_last_damage = 0.0
