extends Panel

@export var inventory_open = false  
@onready var slots = $Inventory.get_children()  
@export var equipped_item : Item = null  

func _ready() -> void:
	add_item(load("res://Scenes/Pitchfork.tres"))
	add_item(load("res://Scenes/Shotgun.tres"))
	
	set_inventory_visibility(inventory_open)
	set_process_input(true)  

func add_item(item : Item):
	for slot in slots:
		if slot.item == null:
			slot.item = item
			return
	print("Can't add any more items...")

# Remove item from the inventory
func remove_item(item : Item):
	for slot in slots:
		if slot.item == item:
			slot.item = null
			return
	print("Item not found...")

# Open and close the inventory when 'E' is pressed
func _input(event):
	if event.is_action_pressed("ui_inventory"):  # Assuming 'E' is mapped to 'ui_inventory'
		toggle_inventory()

# Toggle the inventory state
func toggle_inventory():
	inventory_open = !inventory_open
	set_inventory_visibility(inventory_open)

# Show or hide the inventory (Panel)
func set_inventory_visibility(visible):
	self.visible = visible  # Toggle visibility of the Panel and its contents

# Save the equipped item
func equip_item(item : Item):
	equipped_item = item
	print("Equipped item:", equipped_item.name)

func equip_selected_item(slot_index):
	var item = slots[slot_index].item
	if item != null:
		equip_item(item)
	else:
		print("No item to equip in the selected slot.")
