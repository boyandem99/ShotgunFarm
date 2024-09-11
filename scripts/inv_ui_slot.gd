extends Panel

@onready var item_displey: Sprite2D = $CenterContainer/Panel/item
@onready var amount_text: Label = $CenterContainer/Panel/Label

func update(slots: invSlot):
	if !slots.item:
		item_displey.visible = false
		amount_text.visible = false
	else:
		item_displey.visible = true
		item_displey.texture = slots.item.texture
		if slots.amount > 1:
			amount_text.visible = true
		amount_text.text = str(slots.amount)
