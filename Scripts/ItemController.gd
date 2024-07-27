#ItemController.gd

extends Node2D

@export var max_item_amount_in_scene : int = 10
var item_amount_current : int = 0

var TileMap_current : TileMap
var spawnable_tiles : Array

# Item Dictionary
var items = {}

func _ready():
	TileMap_current = get_tree().current_scene.get_node("TileMap")
	spawnable_tiles = get_spawnable_tiles()
	load_all_items()

func _process(delta):
	## check if current_item_amount is less than max item amount
	while item_amount_current < max_item_amount_in_scene:
		spawn_random_item()
	

func get_spawnable_tiles():
	var used_cells = TileMap_current.get_used_cells(1)
	for cell in used_cells:
		var world_position = TileMap_current.map_to_local(cell)
		spawnable_tiles.append(world_position)
	
	return spawnable_tiles

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
		item_amount_current += 1
		return new_item_node
	return null

#Spawn random item at random position
func spawn_random_item():
	var spawn_location = spawnable_tiles[randi() % spawnable_tiles.size()]
	var random_item_ID = randi() % items.size()
	spawn_item(random_item_ID, spawn_location)
	
