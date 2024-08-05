##thornling.gd

extends CharacterBody2D

##Global Player Reference
@onready var player_ref = GameController.player_ref


##Signals
signal health_update

##ANIMATION 
@onready var animation_sprite = $AnimatedSprite2D
var animation : String

## MOVEMENT 
@export var base_speed = 50
var movement_speed = base_speed

var direction : Vector2

##ENEMY STATS
@export var base_health = 30
var max_health = base_health
var current_health = base_health
var health_regen = 1
@onready var health_bar = $health_bar
var visibility_radius = 100

enum AlertStatus{
	HIDDEN,
	CAUTION,
	DANGER
}

##ENEMY STATE
var is_attacking = false
var alert_status : AlertStatus = AlertStatus.HIDDEN


var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	health_update.connect(health_bar.update_health_ui)

func _process(delta):
	var updated_health = min(current_health + health_regen * delta, max_health)
	if updated_health != current_health:
		current_health = updated_health
		health_update.emit(current_health, max_health)
		

func _physics_process(delta):
	player_detection()
	var movement = movement_speed * direction * delta
	var collision = move_and_collide(movement)
	

func handle_damage(damage):
	current_health -= damage
	if current_health <= 0:
		die()

func die():
	self.queue_free()

func player_detection():
	var distance_to_player = player_ref.position - position
	
	if distance_to_player.length() <= 16:
		direction = Vector2.ZERO
	elif distance_to_player.length() <= visibility_radius:
		direction = distance_to_player.normalized()
	else:
		var random_direction = rng.randf()
		
		if random_direction < 0.05:
			direction = Vector2.ZERO
		elif random_direction < 0.1:
			direction = Vector2.DOWN.rotated(rng.randf() * 2 * PI)	
		
