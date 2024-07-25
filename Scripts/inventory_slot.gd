##inventory_slot.gd
extends Panel

var full_tex = preload("res://Assets/inventory/item_slot_background.png")
var empty_tex = preload("res://Assets/inventory/item_slot_empty_background.png")

var full_style : StyleBoxTexture = null
var empty_style : StyleBoxTexture = null

var ItemNodeScene = preload("res://Scenes/item_node.tscn")
var item_node = null

@onready var item_amount_label = $item_amount
var item_amount : int

func _ready():
	full_style = StyleBoxTexture.new()
	empty_style = StyleBoxTexture.new()
	full_style.texture = full_tex
	empty_style.texture = empty_tex
	item_amount_label.visible = false
	
	refresh_style()

func refresh_style():
	if item_node == null:
		set('theme_override_styles/panel', empty_style)
	else:
		set('theme_override_styles/panel', full_style)

func insert_item(new_item_node : ItemNode):
	item_node = new_item_node
	if item_node.get_parent() != null:
		item_node.get_parent().remove_child(item_node)
	item_node.position = Vector2(0,0)
	add_child(item_node)
	refresh_style()

func remove_item():
	remove_child(item_node)
	## Add item into inventory_background node so that it can follow mouse cursor
	var background_node = find_parent("background")
	background_node.add_child(item_node)
	item_node = null
	refresh_style()
