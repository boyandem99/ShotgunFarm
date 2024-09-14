extends Node

var isDay: bool = false

var inventory = []
var plantSelected = null #0 carrot, 1 wheat, 2 tomato, 3 potato

var numberOfcrops = [0, 0, 0, 0]

signal inventory_updated

var player_node: Node = null
func _ready():
	inventory.resize(30)

func add_item():
	inventory_updated.emit()

func remove_item():
	inventory_updated.emit()
	
func increase_inventory_size():
	inventory_updated.emit()

func set_player_reference(player):
	player_node = player
