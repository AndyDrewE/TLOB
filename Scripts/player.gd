##player.gd

extends CharacterBody2D

#signals
signal active_item_update
signal health_update
signal stamina_update

##ANIMATION 
@onready var animation_sprite = $AnimatedSprite2D
var animation : String

## MOVEMENT 
@export var base_speed = 75
var movement_speed = base_speed

var direction_input : Vector2
var current_direction : Vector2

##PLAYER STATS
@export var base_health = 100
var max_health = base_health
var current_health = base_health
var health_regen = 5
@export var base_stamina = 100
var max_stamina = base_stamina
var current_stamina = base_stamina
var stamina_regen = 10

var roll_stamina = 10
var sprint_stamina = 1


##PLAYER STATE 
var is_rolling = false
var roll_timer = 0.5
var is_attacking = false
var can_attack = true

##INVENTORY/UI
var pickup_enabled = false
var temp_pickup_item = null
@onready var UserInterface = $UserInterface
@onready var inventory = $UserInterface/inventory
@onready var hotbar = $UserInterface/hotbar
var active_item_index = 0
var active_item : ItemStack = null


func _ready():
	movement_speed = base_speed
	
	health_update.connect(UserInterface.health_bar.update_health_ui)
	stamina_update.connect(UserInterface.stamina_bar.update_stamina_ui)
		
	active_item_update.emit()

func _input(event):
	if event.is_action_pressed("ui_interact"):
		if pickup_enabled:
			pickup_item(temp_pickup_item)


func _process(delta):
	var updated_health = min(current_health + health_regen * delta, max_health)
	if updated_health != current_health:
		current_health = updated_health
		health_update.emit(current_health, max_health)
		
	var updated_stamina = min(current_stamina + stamina_regen * delta, max_stamina)
	if updated_stamina != current_stamina:
		current_stamina = updated_stamina
		stamina_update.emit(current_stamina, max_stamina)

func _physics_process(delta):
	if !is_rolling:
		direction_input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		direction_input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	# Trying to normalize direction that way speed is the same in all directions
	direction_input = direction_input.normalized()
	
	if Input.is_action_pressed("ui_sprint"):
		movement_speed = base_speed * 2
		current_stamina -= sprint_stamina
		stamina_update.emit(current_stamina, max_stamina)
	elif Input.is_action_just_released("ui_sprint"):
		movement_speed = base_speed
	
	#await get_tree().create_timer(bow_cooldown_time).timeout I want this somewhere probably
	if Input.is_action_just_pressed("ui_roll") and current_stamina >= roll_stamina and !is_attacking:
		is_rolling = true
		movement_speed = base_speed * 3
		current_stamina -= roll_stamina
		stamina_update.emit(current_stamina, max_stamina)
		
	
	if active_item != null:
		if active_item.item is Weapon:
			var active_weapon = active_item.item
			if Input.is_action_just_pressed("ui_attack") and !is_rolling and can_attack:
				is_attacking = true
				can_attack = false
				active_weapon.attack(self, current_direction)
				player_animations(current_direction)
	
	var movement = movement_speed * direction_input * delta
	
	if !is_attacking:
		move_and_collide(movement)
		player_animations(direction_input)


## Animation and Direction
func player_animations(update_direction: Vector2):
	if update_direction != Vector2.ZERO:
		current_direction = update_direction
		if is_rolling:
			animation = "roll_" + return_direction(current_direction)
		elif is_attacking:
			var active_weapon_type = get_active_weapon_type()
			##TODO: CHANGE THIS WHEN MORE ANIMATIONS ADDED
			if active_weapon_type != null:
				animation = "melee_" + return_direction(current_direction)
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

## Damage and Health
func handle_damage(take_damage):
	current_health -= take_damage
	if current_health <= 0:
		die()

func die():
	print("You DIED")

##Item Handling and Inventory
func pickup_item(item_node : ItemStack):
	inventory.add_to_inventory(item_node)

func get_active_item():
	var active_item_ref = hotbar.slots[active_item_index].item_stack
	var active_item_name = "None"
	if active_item_ref.item is Weapon:
		active_item_name = active_item_ref.item.name
		
	print("Active item: %s" %active_item_name)

func get_active_weapon_type():
	return active_item.item.weapon_type

func active_item_down():
	active_item_index = (active_item_index + 1) % hotbar.slots.size()
	active_item_update.emit()
	
func active_item_up():
	if active_item_index == 0:
		active_item_index = hotbar.slots.size() - 1
	else:
		active_item_index -= 1
	active_item_update.emit()

func update_active_item(new_item_stack : ItemStack):
	active_item = new_item_stack
	#if new_item_stack == null and equipped_item != null:
		#equipped_item.queue_free()
	#elif new_item_stack != equipped_item:
		#equipped_item = new_item_stack.duplicate()
		#add_child(equipped_item)
	

##Signal Functions
func _on_animated_sprite_2d_animation_finished():
	if is_rolling:
		is_rolling = false
		movement_speed = base_speed
	elif is_attacking:
		is_attacking = false
		can_attack = true


