extends Node2D

@export var enemy_scene: PackedScene
@export var boss_scene: PackedScene
var enemy_limit: int = 10
var enemy_number: int = 10

@onready var day_soundtrack: AudioStreamPlayer2D = $DaySoundtrack
@onready var night_soundtrack: AudioStreamPlayer = $NightSoundtrack

func _process(delta):
	pass

func _ready():
	new_game()

func new_game():
	# Stop both soundtracks initially
	day_soundtrack.stop()
	night_soundtrack.stop()

	# Check if it's day or night and play the corresponding soundtrack
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
	var boss = boss_scene.instantiate()
	add_child(boss)
	var boss = boss_scene.instantiate()
	add_child(boss)

func _on_spawn_timer_timeout():
	if enemy_number <= enemy_limit:
		var enemy = enemy_scene.instantiate()
		enemy_number += 1
		var enemy_spawn_location = $EnemyPath/EnemySpawnLocation
		enemy_spawn_location.progress_ratio = randf()
		var direction = enemy_spawn_location.rotation + PI / 2
		enemy.position = enemy_spawn_location.position
		direction += randf_range(-PI / 4, PI / 4)
		enemy.rotation = direction
		var velocity = Vector2(randf_range(150.0, 250.0), 0.0).rotated(rotation)
		add_child(enemy)
