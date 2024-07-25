##inventory.gd
extends Control

@onready var inventory_slots = $background/slots.get_children()

var held_item = null

## pick up item, put item in slot
# Called when the node enters the scene tree for the first time.
func _ready():
	for slot in inventory_slots:
		slot.gui_input.connect(slot_gui_input.bind(slot))

func _input(event):
	if held_item:
		held_item.global_position = get_global_mouse_position()


func slot_gui_input(event : InputEvent, slot : InventorySlot):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			if held_item:
				if !slot.item_node: ##Put held_item in empty slot
					slot.insert_item(held_item)
					held_item = null
				else: ##swap held_item and slot_item
					var temp_item_node = slot.item_node
					slot.remove_item()
					temp_item_node.global_position = event.global_position
					slot.insert_item(held_item)
					held_item = temp_item_node
			elif slot.item_node:
				held_item = slot.item_node
				slot.remove_item()
				held_item.global_position = get_global_mouse_position()
