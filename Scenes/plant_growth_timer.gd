extends StaticBody2D

var plant = Global.plantSelected
var is_plant_growing: bool = false
var is_plant_done: bool = false
var buff_granted: bool = false
var player_scene = preload("res://Scenes/Player.tscn")  # Change from `player` to `player_scene`
@onready var plantSprite: AnimatedSprite2D = $Plant
@onready var collisionShape: CollisionShape2D = $Area2D/CollisionShape2D  
@export var wheat_buff: Resource
@export var carrot_buff: Resource
@export var tomato_buff: Resource
@export var potato_buff: Resource

func _physics_process(delta: float) -> void:
	if not is_plant_growing:
		plant = Global.plantSelected

func _on_wheat_timer_timeout() -> void:
	if $Plant.frame == 0:
		$Plant.frame = 1
		$wheatTimer.start()
	elif $Plant.frame == 1:
		$Plant.frame = 2
		$wheatTimer.start()
	elif $Plant.frame == 2:
		$Plant.frame = 3
		is_plant_done = true
	
	
func _on_carrot_timer_timeout() -> void:
	if $Plant.frame == 0:
		$Plant.frame = 1
		$carrotTimer.start()
	elif $Plant.frame == 1:
		$Plant.frame = 2
		$carrotTimer.start()
	elif $Plant.frame == 2:
		$Plant.frame = 3
		is_plant_done = true

func _on_tomato_timer_timeout() -> void:
	if $Plant.frame == 0:
		$Plant.frame = 1
		$tomatoTimer.start()
	elif $Plant.frame == 1:
		$Plant.frame = 2
		$tomatoTimer.start()
	elif $Plant.frame == 2:
		$Plant.frame = 3
		$tomatoTimer.start()
	elif $Plant.frame == 3:
		$Plant.frame = 4
		is_plant_done = true

func _on_potato_timer_timeout() -> void:
	if $Plant.frame == 0:
		$Plant.frame = 1
		$potatoTimer.start()
	elif $Plant.frame == 1:
		$Plant.frame = 2
		$potatoTimer.start()
	elif $Plant.frame == 2:
		$Plant.frame = 3
		$potatoTimer.start()
	elif $Plant.frame == 3:
		$Plant.frame = 4
		is_plant_done = true

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("seeds"):
		if not is_plant_growing:
			plantSprite.visible = true
			if plant == 0:
				is_plant_growing = true
				$carrotTimer.start()
				plantSprite.play("carrotGrowing")
				plantSprite.offset = Vector2(0,0)
			elif plant == 1:
				is_plant_growing = true
				$wheatTimer.start()
				plantSprite.play("wheatGrowing")
				plantSprite.offset = Vector2(0,-8)
			elif plant == 2:
				is_plant_growing = true
				$tomatoTimer.start()
				plantSprite.play("tomatoGrowing")
				plantSprite.offset = Vector2(0,-8)
			elif plant == 3:
				is_plant_growing = true
				$potatoTimer.start()
				plantSprite.play("potatoGrowing")
				plantSprite.offset = Vector2(0,0)
			else:
				print("null result")
		else:
			print("plant is already growing here")

func _ready() -> void:
	# Restore plant state
	var plant_key = str(global_position)
	if Global.plants_data.has(plant_key):
		var data = Global.plants_data[plant_key]
		plant = data["plant_type"]
		is_plant_done = data["is_plant_done"]
		buff_granted = data["buff_granted"]
		
		# Restore the visual and timer state accordingly
		if plant == 0:
			if is_plant_done:
				$carrotTimer.start()
				plantSprite.play("carrotGrowing")
			else:
				$carrotTimer.stop()
				plantSprite.stop()
		elif plant == 1:
			if is_plant_done:
				$wheatTimer.start()
				plantSprite.play("wheatGrowing")
			else:
				$wheatTimer.stop()
				plantSprite.stop()
		elif plant == 2:
			if is_plant_done:
				$tomatoTimer.start()
				plantSprite.play("tomatoGrowing")
			else:
				$tomatoTimer.stop()
				plantSprite.stop()
		elif plant == 3:
			if is_plant_done:
				$potatoTimer.start()
				plantSprite.play("potatoGrowing")
			else:
				$potatoTimer.stop()
				plantSprite.stop()
		else:
			print("Unknown plant type")

func reset_plant() -> void:
	plantSprite.frame = 0
	is_plant_done = false
	buff_granted = false  
	is_plant_growing = false
	if plant == 0:
				is_plant_growing = true
				$carrotTimer.start()
				plantSprite.play("carrotGrowing")
				plantSprite.offset = Vector2(0,0)
	elif plant == 1:
				is_plant_growing = true
				$wheatTimer.start()
				plantSprite.play("wheatGrowing")
				plantSprite.offset = Vector2(0,-8)
	elif plant == 2:
				is_plant_growing = true
				$tomatoTimer.start()
				plantSprite.play("tomatoGrowing")
				plantSprite.offset = Vector2(0,-8)
	elif plant == 3:
				is_plant_growing = true
				$potatoTimer.start()
				plantSprite.play("potatoGrowing")
				plantSprite.offset = Vector2(0,0)
				is_plant_done = true
	else:
				print("null result")

func save_plant_state() -> void:
	var plant_key = str(global_position) 
	Global.plants_data[plant_key] = {
		"plant_type": plant,
		"is_plant_done": is_plant_done,
		"buff_granted": buff_granted
	}

var buff_resources = {
	0: carrot_buff,
	1: wheat_buff,
	2: tomato_buff,
	3: potato_buff
}

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and is_plant_done and not Global.isDay:
		grant_buff(body)  # Pass the actual player instance
		save_plant_state()
		reset_plant()
	else:
		print("bug1")

func grant_buff(player: Player) -> void:
	var buff_resource = get_buff_resource(plant)  # Get the buff for the current plant
	print("Plant value:", plant)  # Debug: Print the plant value
	print("Buff resource:", buff_resource)  # Debug: Print the buff resource
	
	if buff_resource:
		player.apply_buff(buff_resource)
	else:
		print("bug2")

func get_buff_resource(plant: int) -> Resource:
	match plant:
		0:
			return load("res://Scenes/DamageCarrot.tres")
		1:
			return load("res://Scenes/SpeedWheat.tres")

		2:
			return load("res://Scenes/HealthTomato.tres")

		3:
			return load("res://Scenes/BulletPotato.tres")

		_:
			print("Error: Invalid plant value")
			return null
