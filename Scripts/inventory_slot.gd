##inventory_slot.gd
extends Panel

var full_tex = preload("res://Assets/inventory/item_slot_background.png")
var empty_tex = preload("res://Assets/inventory/item_slot_empty_background.png")

var full_style : StyleBoxTexture = null
var empty_style : StyleBoxTexture = null

var ItemNodeScene = preload("res://Scenes/item_node.tscn")
var item_node

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
		item_amount_label.visible = false
	else:
		if!(item_node.item is Weapon):
			item_amount_label.visible = true
		
		set('theme_override_styles/panel', full_style)
		update_amount_label()

func update_amount_label():
	item_amount_label.text = str(item_amount)

func change_to_amount(change : int):
	item_amount += change
	refresh_style()

func insert_item(new_item_node : ItemNode):
	#Assign new item node to item node, Assign the value of item_node's label to item_amount
	item_node = new_item_node
	#Get label off of item_node
	var label = item_node.get_node("item_amount")
	if label:
		item_amount = int(label.text)
		item_node.remove_child(label)
	else:
		print("Label not found on item_node")
	
	## Remove item_node from current parent if it has one
	if item_node.get_parent() != null:
		item_node.get_parent().remove_child(item_node)
	
	
	add_child(item_node)
	item_node.position = Vector2(0,0)
	refresh_style()

func remove_item():
	# Store item amount
	var recorded_amount = item_amount
	# Remove the item_node from this slot node
	remove_child(item_node)
	# Add item_node to inventory backround
	## Add item into inventory_background node so that it can follow mouse cursor
	var background_node = find_parent("background")
	background_node.add_child(item_node)
	#Create duplicate label with recorded amount
	var duplicate_label = item_amount_label.duplicate() as Label
	duplicate_label.text = str(recorded_amount)
	item_node.add_child(duplicate_label)
	
	# reset Item amount and item_node
	item_amount = 0
	item_node = null
	
	#Refresh style
	refresh_style()
