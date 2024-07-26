#ItemController.gd

extends Node2D

var items = {}

func _ready():
	load_all_items()
	spawn_item(0,Vector2(100,100))
	
	
# Function to load item resources, will deprecate into database
func load_all_items():
	var item_paths = [
		"res://Data/item_resources/apple.tres",
		"res://Data/weapon_resources/melee/basic_sword.tres"
	]
	
	for path in item_paths:
		var item = load(path)
		if item:
			items[item.ID] = item

# Get item by item ID
func get_item(item_ID : int) -> Item:
	if item_ID in items:
		return items[item_ID]
	
	print("Item ID (%s) not found" % item_ID)
	return null

#Spawn item at given position
func spawn_item(item_ID : int, spawn_location : Vector2) -> ItemNode:
	var item_resource = get_item(item_ID)
	if item_resource:
		var new_item_node = ItemNode.new()
		new_item_node.init(item_resource)
		new_item_node.position = spawn_location
		get_parent().add_child.call_deferred(new_item_node)
		return new_item_node
	return null
