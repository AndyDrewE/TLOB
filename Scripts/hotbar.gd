##hotbar.gd

extends "res://Scripts/inventory.gd"

@onready var hb_slots = $background/slots.get_children()
@onready var active_item_label = $background/ActiveItemLabel
var slot_index = 0


func _ready():
	player_ref.active_item_update.connect(self.update_active_item_label)
	
	var index = 0
	for slot in hb_slots:
		slot.slot_index = index
		slot.gui_input.connect(slot_gui_input.bind(slot))
		player_ref.active_item_update.connect(slot.refresh_style)
		slot.slot_type = InventorySlot.SlotType.HOTBAR
		index += 1
		

func update_active_item_label():
	var active_item = slots[player_ref.active_item_index].item_stack
	var active_item_name = ""
	if active_item != null:
		active_item_name = active_item.item.name
	player_ref.update_active_item(active_item)
	active_item_label.text = active_item_name
