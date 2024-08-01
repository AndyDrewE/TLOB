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

func attack(character_node, direction : Vector2):
	if weapon_type == 0:
		melee(character_node, direction)
	elif weapon_type == 1:
		ranged(character_node, direction)
	elif weapon_type == 2:
		magic(character_node, direction)
	else:
		print("weapon type not found")
	

func melee(character_node, direction : Vector2):
	var hitbox = ShapeCast2D.new()
	hitbox.shape = RectangleShape2D.new()
	hitbox.set_target_position(direction * 16)
	character_node.add_child(hitbox)
	
	print(hitbox.is_colliding())
	if hitbox.is_colliding():
		var num_of_collisions = hitbox.get_collision_count()
		for i in range(0, num_of_collisions - 1):
			print(hitbox.get_collider(i))
	
	await character_node.get_tree().create_timer(0.1).timeout
	hitbox.queue_free()

func ranged(character_node, direction : Vector2):
	print("Ranged by %s" %character_node)

func magic(character_node, direction : Vector2):
	print("Magic by %s" %character_node)

