## weapon.gd
extends Item

class_name Weapon

var arrow_scene = preload("res://Scenes/arrow.tscn")


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
	match weapon_type:
		WeaponType.MELEE:
			melee(character_node, direction)
		WeaponType.RANGED:
			ranged(character_node, direction)
		WeaponType.MAGIC:
			magic(character_node, direction)
		_:
			print("weapon type not found")


##TODO: Refactor into a few seperate weapon classes 
func melee(character_node, direction : Vector2):
	#instantiate and update shapecast
	var hitbox = ShapeCast2D.new()
	hitbox.shape = RectangleShape2D.new()
	hitbox.set_target_position(direction * 16)
	character_node.add_child(hitbox)
	hitbox.force_shapecast_update() ##THIS IS IMPORTANT BECAUSE WE'RE NOT IN PHYSICS_PROCESS
	
	if hitbox.is_colliding():
		var num_collisions = hitbox.get_collision_count()
		for i in range(num_collisions):
			var collider = hitbox.get_collider(i)
			if collider.has_method("handle_damage"):
				collider.handle_damage(damage)
	
	await character_node.get_tree().create_timer(0.1).timeout
	hitbox.queue_free()

func ranged(character_node, direction : Vector2):
	var arrow_instance = arrow_scene.instantiate()
	arrow_instance.rotation = direction.angle()
	arrow_instance.global_position = character_node.global_position
	character_node.add_child(arrow_instance)


func magic(character_node, direction : Vector2):
	print("Magic by %s" %character_node)

