##inventory.gd
extends Control

@onready var slots = $background/slots.get_children()

const InventorySlot = preload("res://Scripts/inventory_slot.gd")
var held_item_stack = null

func _ready():
	for slot in slots:
		slot.gui_input.connect(slot_gui_input.bind(slot))
	

func _input(_event):
	if held_item_stack:
		held_item_stack.global_position = get_global_mouse_position() + Vector2(16,16)

##add to inventory from world
func add_to_inventory(add_item_stack : ItemStack):
	for slot in slots:
		if slot.item_stack == null:
			slot.insert_item(add_item_stack)
			ItemController.stack_amount_current -= 1
			slot.refresh_style()
			return
		else:
			if slot.item_stack.item.ID == add_item_stack.item.ID:
				var item_stack_size = slot.item_stack.item.stack_size
				var remaining_space = item_stack_size - slot.item_stack.item_amount
				if remaining_space >= add_item_stack.item_amount:
					slot.item_stack.update_item_amount(add_item_stack.item_amount)
					add_item_stack.queue_free()
					slot.refresh_style()
					ItemController.stack_amount_current -= 1
					return
				else:
					slot.item_stack.update_item_amount(remaining_space)
					add_item_stack.item_amount -= remaining_space
					slot.refresh_style()
					
				
	

##TODO: Add stack splitting
func slot_gui_input(event : InputEvent, slot : InventorySlot):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			if held_item_stack != null: ## If the player is holding an item
				##Empty Slot, insert held item into slot
				if !slot.item_stack: 
					slot.insert_item(held_item_stack)
					held_item_stack = null
				#Slot contains an item
				else:
					##Different item, so swap them
					if held_item_stack.item.name != slot.item_stack.item.name:
						var temp_item_stack = slot.item_stack
						slot.remove_item()
						temp_item_stack.global_position = get_global_mouse_position()
						slot.insert_item(held_item_stack)
						held_item_stack = temp_item_stack
					##Same Item, so try to merge them
					else:
						var item_stack_size = slot.item_stack.item.stack_size
						var remaining_space = item_stack_size - slot.item_stack.item_amount
						if remaining_space >= held_item_stack.item_amount:
							slot.item_stack.update_item_amount(held_item_stack.item_amount)
							held_item_stack.queue_free()
							held_item_stack = null
							slot.refresh_style()
						else:
							slot.item_stack.update_item_amount(remaining_space)
							held_item_stack.item_amount -= remaining_space
							slot.refresh_style()
					
					
			elif slot.item_stack:
				held_item_stack = slot.item_stack
				held_item_stack.item_amount = slot.item_stack.item_amount
				slot.remove_item()
				held_item_stack.global_position = get_global_mouse_position() + Vector2(16,16)
