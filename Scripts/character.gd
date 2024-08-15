##character.gd
class_name Character

extends CharacterBody2D

##ANIMATION
@onready var animation_sprite = $AnimatedSprite2D
var animation : String

##MOVEMENT
@export var base_speed = 50
var movement_speed = base_speed

##STAT INFORMATION
@export var base_health = 100
var max_health = base_health
var current_health = base_health
var health_regen = 5
@export var base_stamina = 100
var max_stamina = base_stamina
var current_stamina = base_stamina
var stamina_regen = 10
