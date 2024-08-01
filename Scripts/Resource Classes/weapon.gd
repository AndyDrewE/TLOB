## weapon.gd
extends Item

class_name Weapon


@export var damage : int
@export var speed : float

enum WeaponType{
	MELEE,
	RANGED,
	MAGIC
}
@export var weapon_type : WeaponType


func _ready():
	stack_size = 1
