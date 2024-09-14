extends StaticBody2D

var plant = Global.plantSelected
var is_plant_growing: bool = false
var is_plant_done: bool = false





@onready var plantSprite: AnimatedSprite2D = $Plant

func _physics_process(delta: float) -> void:
	if is_plant_growing == false:
		plant = Global.plantSelected
		






func _on_wheat_timer_timeout() -> void:
	var wheat_plant = $Plant
	if wheat_plant.frame == 0:
		wheat_plant.frame = 1
		$wheatTimer.start()
	elif wheat_plant.frame == 1:
		wheat_plant.frame = 2
		is_plant_done = true
	
	
#even though it says wheat it works for other crops

func _on_carrot_timer_timeout() -> void:
	var wheat_plant = $Plant
	if wheat_plant.frame == 0:
		wheat_plant.frame = 1
		$carrotTimer.start()
	elif wheat_plant.frame == 1:
		wheat_plant.frame = 2
		is_plant_done = true


func _on_tomato_timer_timeout() -> void:
	var wheat_plant = $Plant
	if wheat_plant.frame == 0:
		wheat_plant.frame = 1
		$tomatoTimer.start()
	elif wheat_plant.frame == 1:
		wheat_plant.frame = 2
		is_plant_done = true


func _on_potato_timer_timeout() -> void:
	var wheat_plant = $Plant
	if wheat_plant.frame == 0:
		wheat_plant.frame = 1
		$potatoTimer.start()
	elif wheat_plant.frame == 1:
		wheat_plant.frame = 2
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



func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("shoot"):
		if is_plant_done:
			plantSprite.frame = 0
			plantSprite.play("none")
			is_plant_growing = false
			is_plant_done = false
			plantSprite.offset = Vector2(0,0)
			plantSprite.visible = false
