extends CharacterBody2D

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
var counter : int = 1
var is_attacking = false
var health = 10
@onready var original_collision_layer = collision_layer
@onready var original_collision_mask = collision_mask
@onready var weapon = $WeaponFX
@onready var hitbox = null 
@export var health_resource : Resource = preload("res://Scenes/PlayerHealthResource.tres")
@onready var healthbar = $HealthBar
@onready var hit_flash_anim_player = $PlayerHitFlashAnimationPlayer
@export var current_item : Item:
	set(value):
		current_item = value
		if current_item != null:
			if current_item.animation in ["pitchfork"]:
				set_damage(current_item.damage)
			else:
				set_damage(1)

func set_damage(amount):
	if is_hitbox_ready():
		hitbox.damage = amount

func _ready():
	health = health_resource.max_health
	healthbar.init_health(health)
	hitbox = $Weapon/Hitbox	
	_update() 

func _update():
	if current_item != null:
		set_damage(current_item.damage)

func is_hitbox_ready() -> bool:
	return hitbox != null

func _input(event):
	if event.is_action_pressed("shoot") and not is_attacking:
		play_animation()

func play_animation():
	if not is_attacking:
		is_attacking = true  
		$Weapon.texture = current_item.texture
		weapon.play(current_item.animation)

func _on_weapon_fx_animation_finished(anim_name):
	if anim_name == current_item.animation:
		is_attacking = false 

func _process(delta):
	var mouse_pos = get_global_mouse_position()
	if mouse_pos.x < global_position.x:
		$AnimatedSprite2D.flip_h = false
		$Weapon.look_at(mouse_pos)
		if is_hitbox_ready():
			hitbox.scale.x = -1
	else:
		$AnimatedSprite2D.flip_h = true
		$Weapon.flip_h = true
		$Weapon.look_at(mouse_pos)

func _physics_process(delta):
	handle_movement(delta)
	handle_dash(delta)

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
	collision_layer = 0  
	collision_mask = 0
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
	if amount > 0:
		hit_flash_anim_player.play("hit_flash")
	healthbar._set_health(health)  # Update the healthbar immediately after damage
	if health <= 0:
		health = 0
		_die()

func _die():
	health = 100
	#get_tree().change_scene("res://Scenes/YouDiedScene.tscn")
func heal(amount: int):
	#current_health += amount
	#if current_health > max_health:
		#current_health = max_health
	#healthbar._set_health(current_health)
	pass
signal hit


func _on_hurtbox_body_entered(body):
	if body is Enemy:
		take_damage(body.damage) 
