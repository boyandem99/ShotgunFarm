extends StaticBody2D

var plant = Global.plantSelected
var is_plant_growing: bool = false
var is_plant_done: bool = false
var buff_granted: bool = false

@onready var plantSprite: AnimatedSprite2D = $Plant
@onready var collisionShape: CollisionShape2D = $Area2D/CollisionShape2D  
@export var wheat_buff: BuffResource
@export var carrot_buff: BuffResource
@export var tomato_buff: BuffResource
@export var potato_buff: BuffResource

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
				print("Unknown plant type: ", plant)
		else:
			print("Plant is already growing here")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and is_plant_done and not Global.isDay:
		if not buff_granted:
			var buff_resource = get_buff_resource()
			if buff_resource:
				grant_buff(buff_resource)
				buff_granted = true
			else:
				print("Buff resource is null. Plant type: ", plant)
		else:
			print("Buff already granted")
	else:
		print("_on_area_2d_body_entered(body: Node2D)")

func grant_buff(buff_resource: BuffResource) -> void:
	if buff_resource:
		if buff_resource is BuffResource:
			var player = get_node("/root/Player")  # Adjust the path to find the player node
			player.apply_buff(buff_resource)  # Apply the buff to the player
		else:
			print("Invalid buff resource type: ", typeof(buff_resource))
	else:
		print("Buff resource is null")

func get_buff_resource() -> BuffResource: 
	match plant:
		0:  
			return carrot_buff
		1:  
			return wheat_buff
		2: 
			return tomato_buff
		3:  
			return potato_buff
		_:
			print("Unknown plant type: ", plant)
			return null

func reset_plant() -> void:
	plantSprite.frame = 0
	is_plant_done = false  # Reset this to false to allow collection after re-growing
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
	else:
		print("Unknown plant type: ", plant)
