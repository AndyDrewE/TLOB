##inventory_slot.gd
extends Panel

@onready var player_ref = find_parent("player")

var full_tex = preload("res://Assets/inventory/item_slot_background.png")
var empty_tex = preload("res://Assets/inventory/item_slot_empty_background.png")
var selected_tex = preload("res://Assets/inventory/item_slot_selected_background.png")

var full_style : StyleBoxTexture = null
var empty_style : StyleBoxTexture = null
var selected_style : StyleBoxTexture = null

var ItemStackScene = preload("res://Scenes/item_stack.tscn")
var item_stack
var slot_index
var slot_type

enum SlotType{
	HOTBAR,
	INVENTORY
}

@onready var item_amount_label = $item_amount

func _ready():
	full_style = StyleBoxTexture.new()
	empty_style = StyleBoxTexture.new()
	selected_style = StyleBoxTexture.new()
	full_style.texture = full_tex
	empty_style.texture = empty_tex
	selected_style.texture = selected_tex
	item_amount_label.visible = false
	
	refresh_style()

func refresh_style():
	if SlotType.HOTBAR == slot_type and player_ref.active_item_index == slot_index:
		if item_stack == null or (item_stack.item is Weapon):
			item_amount_label.visible = false
		else: 
			item_amount_label.visible = true
			
		set('theme_override_styles/panel', selected_style)
	elif item_stack == null:
		set('theme_override_styles/panel', empty_style)
		item_amount_label.visible = false
	else:
		if!(item_stack.item is Weapon):
			item_amount_label.visible = true
		set('theme_override_styles/panel', full_style)
		
	update_amount_label()

func update_amount_label():
	if item_stack != null:
		item_amount_label.text = str(item_stack.item_amount)


func insert_item(new_item_stack : ItemStack):
	#Assign new item node to item node
	item_stack = new_item_stack

	if item_stack.collision_shape.disabled == false:
		item_stack.disable_collision_shape()
	
	## Remove item_stack from current parent if it has one
	if item_stack.get_parent() != null:
		item_stack.get_parent().remove_child(item_stack)
	
	
	self.add_child(item_stack)
	
	item_stack.position = Vector2(0,0)
	refresh_style()

func remove_item():
	# Remove the item_stack from this slot node
	remove_child(item_stack)
	# Add item_stack to inventory backround
	## Add item into inventory_background node so that it can follow mouse cursor
	var background_node = find_parent("background")
	background_node.add_child(item_stack)
	
	# reset Item amount and item_stack
	item_stack = null
	#Refresh style
	refresh_style()
