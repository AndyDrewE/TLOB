## weapon.gd
extends Item

class_name Weapon

@export var weapon_type : String
@export var damage : int
@export var speed : float


func _ready():
	stack_size = 1
