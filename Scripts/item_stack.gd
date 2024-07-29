## item_stack.gd

class_name ItemStack

extends Area2D

var item_icon : TextureRect
@onready var collision_shape : CollisionShape2D = $CollisionShape2D

var item : Item 
var item_amount : int = 0

var pickup_enabled = false

func _ready():
	if item != null:	
		update_item_texture()

func set_item(p_item : Item):
	item = p_item
	if item_icon:
		update_item_texture()
	else:
		item_icon = TextureRect.new()
		add_child(item_icon)
		update_item_texture()

func set_item_amount(p_amount : int):
	item_amount = p_amount

func update_item_texture():
	if item != null:
		item_icon.texture = item.texture
	else:
		print("No item to set texture for")

func update_item_amount(change : int):
	item_amount += change

func enable_collision_shape():
	collision_shape.disabled = false
	input_pickable = true
	monitoring = true
	monitorable = true

func disable_collision_shape():
	collision_shape.disabled = true
	input_pickable = false
	monitoring = false
	monitorable = false


func _on_body_entered(body):
	if body.name == "player":
		pickup_enabled = true
		body.pickup_enabled = pickup_enabled
		body.temp_pickup_item = self


func _on_body_exited(body):
	if body.name == "player":
		pickup_enabled = false
		body.pickup_enabled = pickup_enabled
		body.temp_pickup_item = null
