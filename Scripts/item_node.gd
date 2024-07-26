## item_node.gd
extends Node2D

class_name ItemNode

@onready var item_icon = $item_icon

var item : Item

func _ready():
	if item != null:	
		update_item_texture()

#func init():
	#var item_path : String
	#if randi() % 2 == 0:
		#item_path = "res://Data/item_resources/apple.tres"
	#else:
		#item_path = "res://Data/weapon_resources/melee/basic_sword.tres"
#
	#item = load(item_path) as Item
	#
	#if item == null:
		#print("Failed to load item from path: %s" % item_path)
	#else:
		#update_item_texture()

func update_item_texture():
	if item != null:
		$item_icon.texture = item.texture
	else:
		print("No item to set texture for")
