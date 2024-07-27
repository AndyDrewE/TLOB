##player.gd

extends CharacterBody2D

##ANIMATION 
@onready var animation_sprite = $AnimatedSprite2D
var animation : String

## MOVEMENT 
@export var base_speed = 50
var movement_speed = base_speed

var direction_input : Vector2
var current_direction : Vector2

##PLAYER STATS

##PLAYER STATE 
var is_dashing = false

##INVENTORY
var pickup_enabled = false
@onready var player_inventory = $inventory
var inventory_is_open = false


func _ready():
	movement_speed = base_speed

func _input(event):
	if event.is_action_pressed("ui_inventory"):
		if inventory_is_open:
			close_inventory()
		else:
			open_inventory()
			
	if event.is_action_pressed("ui_interact"):
		pass
		## if there's an item close by that the player can pickup, pick it up

func _physics_process(delta):
	direction_input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction_input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	# Trying to normalize direction that way speed is the same in all directions
	direction_input = direction_input.normalized()
	
	if Input.is_action_pressed("ui_sprint"):
		movement_speed = base_speed * 1.5
	elif Input.is_action_just_released("ui_sprint"):
		movement_speed = base_speed
	
	if Input.is_action_just_pressed("ui_roll"):
		is_dashing = true
		movement_speed = base_speed * 3
	
	var movement = movement_speed * direction_input * delta
	
	
	move_and_collide(movement)
	player_animations(direction_input)


func player_animations(update_direction: Vector2):
	if update_direction != Vector2.ZERO:
		current_direction = update_direction
		if is_dashing:
			animation = "roll_" + return_direction(current_direction)
		else:
			animation = "walk_" + return_direction(current_direction)
	else:
		animation  = "idle_" + return_direction(current_direction)
	
	animation_sprite.play(animation)
		

func return_direction(direction: Vector2):
	var default_return = "south"
	var angle = direction.angle()
	var returned_direction : String = ""
	
	if angle >= - PI/8 and angle < PI/8:
		returned_direction = "east"
	elif angle >= PI/8 and angle < 3*PI/8:
		##returned_direction = "southeast"
		returned_direction = "south"
	elif angle >= 3*PI/8 and angle < 5*PI/8:
		returned_direction = "south"
	elif angle >= 5*PI/8 and angle < 7*PI/8:
		##returned_direction = "southwest"
		returned_direction = "west"
	elif angle >= 7*PI/8 and angle < 9*PI/8:
		returned_direction = "west"
	elif angle >= -7*PI/8 and angle < -5*PI/8:
		##returned_direction = "northwest"
		returned_direction = "north"
	elif angle >= -5*PI/8 and angle < -3*PI/8:
		returned_direction = "north"
	elif angle >= -3*PI/8 and angle < -PI/8:
		##returned_direction = "northeast"
		returned_direction = "east"
	else:
		print("can't find angle")
		returned_direction = default_return
	return returned_direction
	

func open_inventory():
	inventory_is_open = true
	player_inventory.visible = inventory_is_open
	
func close_inventory():
	inventory_is_open = false
	player_inventory.visible = inventory_is_open

func pickup_item(item_node : ItemNode):
	pass
	

func _on_animated_sprite_2d_animation_finished():
	if is_dashing:
		is_dashing = false
		movement_speed = base_speed
