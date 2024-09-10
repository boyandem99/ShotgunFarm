extends CharacterBody2D

var speed = 200
var dash_speed = 400
var dash_time = 0.2
var dash_cooldown = 1.5
var can_dash = true



var dash_timer = 0.0
var cooldown_timer = 0.0




func _physics_process(delta):
	handle_movement(delta)
	handle_dash(delta)

func handle_movement(delta):
	velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play("run")
	else:
		$AnimatedSprite2D.play("idle")

	move_and_slide()
	
func _process(delta):
	var mouse_pos = get_global_mouse_position()
	


	if mouse_pos.x < global_position.x:
		$AnimatedSprite2D.flip_h = false  
	else:
		$AnimatedSprite2D.flip_h = true  

func handle_dash(delta):
	if Input.is_action_just_pressed("dash") and can_dash:
		dash_timer = dash_time
		can_dash = false
	if dash_timer > 0:
		velocity = velocity.normalized() * dash_speed
		dash_timer -= delta
	elif not can_dash:
		cooldown_timer += delta
		if cooldown_timer >= dash_cooldown:
			can_dash = true
			cooldown_timer = 0.0
