#ItemController.gd

extends Node2D

const ItemStackScene = preload("res://Scenes/item_stack.tscn")

@export var max_item_amount_in_scene : int = 25
var stack_amount_current : int = 0

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
	while stack_amount_current < max_item_amount_in_scene:
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
func spawn_item(item_ID : int, spawn_location : Vector2, item_amount: int) -> ItemStack:
	var item_resource = get_item(item_ID)
	var random_amount = randi_range(1,item_resource.stack_size)
	
	if item_resource:
		var new_item_stack = ItemStackScene.instantiate()
		new_item_stack.set_item(item_resource)
		if !(item_resource is Weapon):
			new_item_stack.set_item_amount(item_amount)
		else:
			new_item_stack.set_item_amount(1)
		new_item_stack.position = spawn_location
		get_tree().get_root().get_child(2).add_child(new_item_stack)
		stack_amount_current += 1
		return new_item_stack
	return null

#Spawn random item at random position
func spawn_random_item():
	var spawn_location = spawnable_tiles[randi() % spawnable_tiles.size()]
	var random_item_ID = randi() % items.size()
	var random_amount = randi_range(1,99)
	spawn_item(random_item_ID, spawn_location, random_amount)
	
