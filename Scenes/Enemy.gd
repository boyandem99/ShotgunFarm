extends CharacterBody2D
class_name Enemy

@export var speed = 100 
@onready var healthbar = $HealthBar
@onready var hit_flash_anim_player = $HitFlashAnimationPlayer

var player = null
var health = 10
var is_alive = true

func _ready():
	health = 10
	healthbar.init_health(health)
	player = get_tree().root.get_node("Main/Player")

	# Connect the signal for detecting collisions with bullets
	if not is_connected("body_entered", Callable(self, "_on_body_entered")):
		connect("body_entered", Callable(self, "_on_body_entered"))

func take_damage(damage_amount):
	health -= damage_amount
	hit_flash_anim_player.play("hit_flash")
	healthbar.health = health

	if health <= 0:
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

# This is the correct signal to detect bullet collision
func _on_body_entered(body):
	if body is Bullet:
		take_damage(body.damage)  # Subtract bullet's damage from enemy health
		body.queue_free()  # Destroy the bullet
