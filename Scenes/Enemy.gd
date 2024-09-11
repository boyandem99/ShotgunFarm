extends CharacterBody2D
class_name Enemy

@export var speed = 100 
@export var damage = 10
@onready var healthbar = $HealthBar
@onready var hit_flash_anim_player = $HitFlashAnimationPlayer
@export var health_resource : Resource = preload("res://Scenes/EnemyHealthResource.tres")
var player = null
var health = 10
var is_alive = true

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)  

func _ready():
	health = health_resource.max_health 
	healthbar.init_health(health)
	player = get_tree().root.get_node("Main/Player")

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
		velocity = direction * speed
		move_and_slide()
		rotation = 0

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_hurtbox_body_entered(body):
	if body is Bullet:
		take_damage(body.damage) 
		body.queue_free()  
