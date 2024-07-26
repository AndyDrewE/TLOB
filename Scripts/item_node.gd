## item_node.gd

class_name ItemNode

extends Node2D

var item_icon : TextureRect

var item : Item 


func _ready():
	if item != null:	
		update_item_texture()

func init(p_item : Item):
	item = p_item
	if is_inside_tree():
		update_item_texture()
	else:
		call_deferred("update_item_texture")

func update_item_texture():
	if item_icon == null:
		item_icon = TextureRect.new()
		add_child(item_icon)
	if item != null:
		item_icon.texture = item.texture
	else:
		print("No item to set texture for")
