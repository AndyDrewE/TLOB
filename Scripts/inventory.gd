##inventory.gd
class_name Inventory

extends Control

@onready var slots = $background/slots.get_children()
var equipment_slots


@onready var player_ref = find_parent("player")

func _ready():
	var index = 0
	for slot in slots:
		slot.slot_index = index
		slot.gui_input.connect(slot_gui_input.bind(slot))
		slot.slot_type = InventorySlot.SlotType.INVENTORY
		index += 1
		
	if !(self is Hotbar):
		equipment_slots = $background/equipment_slots.get_children()
		index = 0
		for slot in equipment_slots:
			slot.slot_index = index
			slot.gui_input.connect(slot_gui_input.bind(slot))
			slot.slot_type = InventorySlot.SlotType.AMMO
			index += 1


func _input(_event):
	if find_parent("UserInterface").held_item_stack:
		find_parent("UserInterface").held_item_stack.global_position = get_global_mouse_position() + Vector2(16,16)

##add to inventory from world
func add_to_inventory(add_item_stack : ItemStack):
	for slot in slots:
		## If slot is empty, just put it in
		if slot.item_stack == null:
			slot.insert_item(add_item_stack)
			ItemController.stack_amount_current -= 1
			slot.refresh_style()
			return
		else:
			## If slot has something in it, check to see if they're the same
			if slot.item_stack.item_resource.ID == add_item_stack.item_resource.ID:
				##Check stack size and only put in the amount that will fit
				var item_stack_size = slot.item_stack.item_resource.stack_size
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

## could I do this in the slot to save code?
##TODO: Add stack splitting
##TODO: Split this up into different methods dude this is outrageous
func slot_gui_input(event : InputEvent, slot : InventorySlot):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			if find_parent("UserInterface").held_item_stack != null: ## If the player is holding an item
				##CAN the item be put into the slot?
				if can_into_slot(find_parent("UserInterface").held_item_stack, slot):
					##Empty Slot, insert held item into slot
					if !slot.item_stack: 
						slot.insert_item(find_parent("UserInterface").held_item_stack)
						find_parent("UserInterface").held_item_stack = null
					#Slot contains an item
					else:
						##Different item, so swap them
						if find_parent("UserInterface").held_item_stack.item_resource.name != slot.item_stack.item_resource.name:
							var temp_item_stack = slot.item_stack
							slot.remove_item()
							temp_item_stack.global_position = get_global_mouse_position()
							slot.insert_item(find_parent("UserInterface").held_item_stack)
							find_parent("UserInterface").held_item_stack = temp_item_stack
						##Same Item, so try to merge them
						else:
							var item_stack_size = slot.item_stack.item_resource.stack_size
							var remaining_space = item_stack_size - slot.item_stack.item_amount
							if remaining_space >= find_parent("UserInterface").held_item_stack.item_amount:
								slot.item_stack.update_item_amount(find_parent("UserInterface").held_item_stack.item_amount)
								find_parent("UserInterface").held_item_stack.queue_free()
								find_parent("UserInterface").held_item_stack = null
								slot.refresh_style()
							else:
								slot.item_stack.update_item_amount(remaining_space)
								find_parent("UserInterface").held_item_stack.item_amount -= remaining_space
								slot.refresh_style()
				else:
					print("THIS DON'T GO HERE")
			elif slot.item_stack:
				find_parent("UserInterface").held_item_stack = slot.item_stack
				find_parent("UserInterface").held_item_stack.item_amount = slot.item_stack.item_amount
				slot.remove_item()
				find_parent("UserInterface").held_item_stack.global_position = get_global_mouse_position() + Vector2(16,16)
			find_parent("UserInterface").get_child(1).update_active_item_label()


func can_into_slot(item_stack : ItemStack, slot : InventorySlot):
	if slot.slot_type == InventorySlot.SlotType.AMMO:
		if item_stack.item_resource is Ammo:
			return true
		else:
			return false
	else:
		return true
