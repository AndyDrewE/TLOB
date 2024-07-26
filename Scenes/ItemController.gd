#ItemController.gd

extends Node2D

var items = {}

func _ready():
	load_all_items()
	print(items)
	
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


