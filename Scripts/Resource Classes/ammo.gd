#ammo.gd

extends Item

class_name Ammo

@export var ammo_damage : int
@export var ammo_speed : float

enum AmmoType {
	BOW,
	GUN
}

@export var ammo_type : AmmoType

