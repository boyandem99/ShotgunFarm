extends Node2D

@export var enemy_scene: PackedScene

func _process(delta):
	pass
func _ready():
	new_game()
func new_game():
	$StartTimer.start()
func _on_player_hit():
	pass 
func game_over():
	$SpawnTimer.stop()
func _on_start_timer_timeout():
	$SpawnTimer.start()

func _on_spawn_timer_timeout():
	var enemy = enemy_scene.instantiate()
	var enemy_spawn_location = $EnemyPath/EnemySpawnLocation
	enemy_spawn_location.progress_ratio = randf()
	var direction = enemy_spawn_location.rotation + PI / 2
	enemy.position = enemy_spawn_location.position
	direction += randf_range(-PI / 4, PI / 4)
	enemy.rotation = direction
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0).rotated(rotation)
	add_child(enemy)
