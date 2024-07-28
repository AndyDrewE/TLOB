##inventory.gd
extends Control

@onready var slots = $background/slots.get_children()

const InventorySlot = preload("res://Scripts/inventory_slot.gd")
var held_item = null
var held_item_amount : int

func _ready():
	for slot in slots:
		slot.gui_input.connect(slot_gui_input.bind(slot))
	

func _input(_event):
	if held_item:
		held_item.global_position = get_global_mouse_position() + Vector2(16,16)

##add to inventory from world
func add_to_inventory(item_node : ItemNode):
	for slot in slots:
		if slot.item_node == null:
			slot.insert_item(item_node)
			slot.change_to_amount(1)
			ItemController.item_amount_current -= 1
			return
		else:
			if slot.item_node.item.ID == item_node.item.ID and slot.item_amount < slot.item_node.item.stack_size:
				slot.change_to_amount(1)
				item_node.queue_free()
				ItemController.item_amount_current -= 1
				return
	

##TODO: Add stack splitting
func slot_gui_input(event : InputEvent, slot : InventorySlot):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			if held_item != null: ## If the player is holding an item
				##Empty Slot, insert held item into slot
				if !slot.item_node: 
					slot.insert_item(held_item)
					held_item = null
				#Slot contains an item
				else:
					##Different item, so swap them
					if held_item.item.name != slot.item_node.item.name:
						var temp_item_node = slot.item_node
						slot.remove_item()
						temp_item_node.global_position = get_global_mouse_position()
						slot.insert_item(held_item)
						held_item = temp_item_node
					##Same Item, so try to merge them
					else:
						var item_stack_size = slot.item_node.item.stack_size
						var remaining_space = item_stack_size - slot.item_amount
						if remaining_space >= held_item_amount:
							slot.change_to_amount(held_item_amount)
							held_item.queue_free()
							held_item = null
						else:
							slot.change_to_amount(remaining_space)
							held_item_amount -= remaining_space
							
							held_item.get_node("item_amount").text = str(held_item_amount)
					
					
			elif slot.item_node:
				held_item = slot.item_node
				held_item_amount = slot.item_amount
				slot.remove_item()
				held_item.global_position = get_global_mouse_position() + Vector2(16,16)
