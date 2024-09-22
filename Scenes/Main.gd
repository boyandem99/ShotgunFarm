extends Node2D

@export var enemy_scene: PackedScene
@export var boss_scene: PackedScene
var boss_instance: Node = null 

@onready var day_soundtrack: AudioStreamPlayer2D = $DaySoundtrack
@onready var night_soundtrack: AudioStreamPlayer = $NightSoundtrack
@onready var spawn_timer: Timer = $SpawnTimer # Accessing SpawnTimer node

func _process(delta):
	pass

func _ready():
	new_game()

func new_game():
	day_soundtrack.stop()
	night_soundtrack.stop()

	if Global.isDay:
		day_soundtrack.play()
	else:
		night_soundtrack.play()
		$StartTimer.start()

func _on_player_hit():
	pass

func game_over():
	$SpawnTimer.stop()

func _on_start_timer_timeout():
	$SpawnTimer.start()
	# Check if boss_instance is null before instantiating a new boss
	if boss_instance == null:
		boss_instance = boss_scene.instantiate()
		add_child(boss_instance)

func _on_spawn_timer_timeout():
	var enemy = enemy_scene.instantiate()
	var enemy_spawn_location = $EnemyPath/EnemySpawnLocation
	enemy_spawn_location.progress_ratio = randf()
	var direction = enemy_spawn_location.rotation + PI / 2
	enemy.position = enemy_spawn_location.position
	direction += randf_range(-PI / 4, PI / 4)
	enemy.rotation = direction
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0).rotated(direction)
	enemy.velocity = velocity
	add_child(enemy)


func set_spawn_rate(rate_multiplier: float):
	spawn_timer.wait_time /= rate_multiplier 
	spawn_timer.start() 
