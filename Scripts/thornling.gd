##thornling.gd

extends CharacterBody2D

##Signals
signal health_update


##ANIMATION 
@onready var animation_sprite = $AnimatedSprite2D
var animation : String

## MOVEMENT 
@export var base_speed = 50

var direction_input : Vector2
var current_direction : Vector2

##ENEMY STATS
@export var base_health = 30
var max_health = base_health
var current_health = base_health
var health_regen = 1
@onready var health_bar = $health_bar


func _ready():
	health_update.connect(health_bar.update_health_ui)

func _process(delta):
	var updated_health = min(current_health + health_regen * delta, max_health)
	if updated_health != current_health:
		current_health = updated_health
		health_update.emit(current_health, max_health)

func handle_damage(damage):
	current_health -= damage
	if current_health <= 0:
		die()
	

func die():
	self.queue_free()
