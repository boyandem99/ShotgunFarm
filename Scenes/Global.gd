extends Node
var player_node: Player
var plants_data = {}  
var plantSelected: int = -1
var player_reference = null
var isDay: bool = true 
func _ready():
	player_node = get_tree().root.get_node("Main/Player")	
	if player_node:
		print("Player node successfully initialized.")
	else:
		print("Error: Player node not found.")
	load_plants_state()  # Load the state when the game starts or scene changes
func set_player_reference(player):
	player_reference = player
func save_plants_state() -> void:
	var plant_data = {}
	for plant_node in get_tree().get_nodes_in_group("plants"):
		var key = str(plant_node.global_position)
		plant_data[key] = {
			"plant_type": plant_node.plant,
			"is_plant_done": plant_node.is_plant_done,
			"buff_granted": plant_node.buff_granted
		}
	
	var file = FileAccess.open("user://plants_data.save", FileAccess.WRITE)
	var json = JSON.new()  # Create a new instance of JSON
	var json_data = json.stringify(plant_data)  # Use stringify() to convert to JSON
	file.store_string(json_data)
	file.close()

func load_plants_state() -> void:
	if not FileAccess.file_exists("user://plants_data.save"):
		return  # No saved data to load

	var file = FileAccess.open("user://plants_data.save", FileAccess.READ)
	var json_data = file.get_as_text()
	file.close()
	
	var json = JSON.new()  # Create a new instance of JSON
	var parse_result = json.parse(json_data)  # Use parse() to parse JSON data
	if parse_result != OK:
		print("Failed to parse JSON")
		return
	
	var plant_data = json.result  # Retrieve the parsed data from the result

	for plant_node in get_tree().get_nodes_in_group("plants"):
		var key = str(plant_node.global_position)
		if plant_data.has(key):
			var data = plant_data[key]
			plant_node.plant = data["plant_type"]
			plant_node.is_plant_done = data["is_plant_done"]
			plant_node.buff_granted = data["buff_granted"]
			match plant_node.plant:
				0:  # Carrot
					if plant_node.is_plant_done:
						plant_node.get_node("carrotTimer").start()  # Corrected
						plant_node.plantSprite.play("carrotGrowing")
					else:
						plant_node.get_node("carrotTimer").stop()  # Corrected
						plant_node.plantSprite.stop()
				1:  # Wheat
					if plant_node.is_plant_done:
						plant_node.get_node("wheatTimer").start()  # Corrected
						plant_node.plantSprite.play("wheatGrowing")
					else:
						plant_node.get_node("wheatTimer").stop()  # Corrected
						plant_node.plantSprite.stop()
				2:  # Tomato
					if plant_node.is_plant_done:
						plant_node.get_node("tomatoTimer").start()  # Corrected
						plant_node.plantSprite.play("tomatoGrowing")
					else:
						plant_node.get_node("tomatoTimer").stop()  # Corrected
						plant_node.plantSprite.stop()
				3:  
					if plant_node.is_plant_done:
						plant_node.get_node("potatoTimer").start()  # Corrected
						plant_node.plantSprite.play("potatoGrowing")
					else:
						plant_node.get_node("potatoTimer").stop()  # Corrected
						plant_node.plantSprite.stop()
				_:
					print("Unknown plant type")
