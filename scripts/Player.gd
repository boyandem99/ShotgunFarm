extends CharacterBody2D

var speed = 100
var dash_speed = 400
var dash_time = 0.2
var dash_cooldown = 1.5
var can_dash = true

@onready var inv_ui: Control = $Inv_ui

@export var inv: Inv

var dash_timer = 0.0
var cooldown_timer = 0.0

var isInvOpen: bool = false
var closingInv: bool = false

@onready var shotgun: Node2D = $Shotgun



func _physics_process(delta):
	if isInvOpen == false:
		handle_movement(delta)
		handle_dash(delta)

func handle_movement(delta):
	velocity = Vector2.ZERO
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play("run")
	else:
		$AnimatedSprite2D.play("idle")

	move_and_slide()
	
func _process(delta):
	var mouse_pos = get_global_mouse_position()
	if Input.is_action_just_pressed("open_close_inventory") and isInvOpen == false:
		just_open_inv()
	elif Input.is_action_just_pressed("open_close_inventory") and isInvOpen:
		closing_inv()
		
	if Input.is_action_just_pressed("shoot") and isInvOpen == false:
		shotgun.shoot()
	

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
func just_open_inv():
	shotgun.visible = false
	$AnimatedSprite2D.play("backpackopen")
	
	isInvOpen = true
func open_inv():
	$AnimatedSprite2D.play("backpack_idle")
func closing_inv():
	closingInv = true
	$AnimatedSprite2D.play("backpack_close")
func closed_inv():
	isInvOpen = false
	closingInv = false
	shotgun.visible = true

func _on_animated_sprite_2d_animation_finished() -> void:
	if isInvOpen and closingInv == false:
		open_inv()
	elif closingInv:
		closed_inv()

func collect(item):
	inv.instert(item)
