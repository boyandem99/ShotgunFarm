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
@onready var original_collision_layer = collision_layer
@onready var original_collision_mask = collision_mask

func _process(delta):
	var mouse_pos = get_global_mouse_position()

	# Flip the sprite horizontally based on mouse position
	if mouse_pos.x < global_position.x:
		$AnimatedSprite2D.flip_h = false  
	else:
		$AnimatedSprite2D.flip_h = true  

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
	collision_layer = 0  # Set to a layer that doesn't collide with anything
	collision_mask = 0
	dash_direction = velocity.normalized() if velocity.length() > 0 else Vector2(1, 0)  # Dash in movement direction, default right
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

signal hit
