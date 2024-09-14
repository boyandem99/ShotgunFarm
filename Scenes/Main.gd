extends Node2D

@export var enemy_scene: PackedScene
var enemy_limit = 23
var enemy_number = 0

func _process(delta):
	pass
func _ready():
	new_game()
func new_game():
	if Global.isDay == false:
		$StartTimer.start()
func _on_player_hit():
	pass 
func game_over():
	$SpawnTimer.stop()
func _on_start_timer_timeout():
	$SpawnTimer.start()

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
