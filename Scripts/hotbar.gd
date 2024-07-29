##hotbar.gd

extends "res://Scripts/inventory.gd"



@onready var hb_slots = $background/slots.get_children()
var slot_index = 0


func _ready():
	var index = 0
	for slot in hb_slots:
		slot.slot_index = index
		slot.gui_input.connect(slot_gui_input.bind(slot))
		player_ref.active_item_update.connect(slot.refresh_style)
		slot.slot_type = InventorySlot.SlotType.HOTBAR
		index += 1
		


