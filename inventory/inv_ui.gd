extends Control

var isOpen: bool = false

@onready var inv: Inv = preload("res://inventory/player_inventory.tres")

@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

func _ready() -> void:
	inv.update.connect(updat_slots())
	updat_slots()
	slots.append($NinePatchRect/Inv_Ui_Slot)
	close()
	
func updat_slots():
	for i in range(min(inv.slots.size(), slots.size())):
		slots[i].update(inv.slots[i])
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("open_close_inventory"):
		if isOpen:
			close()
		else:
			open()

func open():
	visible = true
	isOpen = true

func close():
	visible = false
	isOpen = false
