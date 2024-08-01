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

func attack():
	if weapon_type == 0:
		melee()
	elif weapon_type == 1:
		ranged()
	elif weapon_type == 2:
		magic()
	else:
		print("weapon type not found")
	

func melee():
	print("melee attack")

func ranged():
	print("ranged attack")

func magic():
	print("magic attack")

