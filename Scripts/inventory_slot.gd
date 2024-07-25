##inventory_slot.gd
extends Panel

class_name InventorySlot

var full_tex = preload("res://Assets/inventory/item_slot_background.png")
var empty_tex = preload("res://Assets/inventory/item_slot_empty_background.png")

var full_style : StyleBoxTexture = null
var empty_style : StyleBoxTexture = null


var ItemNode = preload("res://Scenes/item_node.tscn")
var item_node = null
var item_amount : int

func _ready():
	full_style = StyleBoxTexture.new()
	empty_style = StyleBoxTexture.new()
	full_style.texture = full_tex
	empty_style.texture = empty_tex
	
	if randi() % 2 == 0:
		item_node = ItemNode.instantiate()
		add_child(item_node)
	
	refresh_style()

func refresh_style():
	if item_node == null:
		set('theme_override_styles/panel', empty_style)
	else:
		set('theme_override_styles/panel', full_style)

func insert_item(new_item_node : ItemNode):
	item_node = new_item_node
	item_node.position = Vector2(0,0)
	var background_node = find_parent("background")
	background_node.remove_child(item_node)
	add_child(item_node)
	refresh_style()

func remove_item():
	remove_child(item_node)
	var background_node = find_parent("background")
	background_node.add_child(item_node)
	item_node = null
	refresh_style()
