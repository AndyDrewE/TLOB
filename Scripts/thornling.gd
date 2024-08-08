##thornling.gd

extends CharacterBody2D

##Global Player Reference
@onready var player_ref = GameController.player_ref


##Signals
signal health_update

##ANIMATION and Collision
@onready var animation_sprite = $AnimatedSprite2D
var animation : String
@onready var collision_shape = $CollisionShape2D
@onready var hitbox = $hitbox_area/hitbox


## MOVEMENT 
@export var base_speed = 20
var movement_speed = base_speed
var direction : Vector2


##ENEMY STATS
@export var base_health = 300
var max_health = base_health
var current_health = base_health
var health_regen = 1
@onready var health_bar = $health_bar
var visibility_radius = 75
var damage = 10

enum AlertStatus{
	HIDDEN,
	CAUTION,
	DANGER
}

##ENEMY STATE
var is_attacking = false
var can_attack = true
var is_sleeping = false
var alert_status : AlertStatus = AlertStatus.HIDDEN


var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	health_update.connect(health_bar.update_health_ui)

func _process(delta):
	var updated_health = min(current_health + health_regen * delta, max_health)
	if updated_health != current_health:
		health_bar.visible = true
		current_health = updated_health
		health_update.emit(current_health, max_health)
	else:
		health_bar.visible = false
		

func _physics_process(delta):
	var movement = movement_speed * direction * delta
	
	if !is_sleeping and !is_attacking:
		var collision = move_and_collide(movement)

func update_animation():
	if is_sleeping:
		animation = "sleep"
	elif is_attacking:
		animation = "attack"
	else:
		animation = "walk"
	animation_sprite.play(animation)

func handle_damage(take_damage):
	current_health -= take_damage
	if current_health <= 0:
		die()

func die():
	self.queue_free()

func player_detection():
	var distance_to_player = player_ref.position - position
	
	if distance_to_player.length() <= 16:
		direction = Vector2.ZERO
		attack()
	elif distance_to_player.length() <= visibility_radius:
		direction = distance_to_player.normalized()
		is_sleeping = false
		$player_not_seen.stop()
	else:
		var random_direction = rng.randf()
		if $player_not_seen.is_stopped():
			$player_not_seen.start(0)
		
		if random_direction < 0.05:
			direction = Vector2.ZERO
		elif random_direction < 0.1:
			direction = Vector2.DOWN.rotated(rng.randf() * 2 * PI).normalized()
			
	update_animation()


func attack():
	if can_attack and !is_attacking:
		is_attacking = true
		can_attack = false
		$attack_cooldown.start()
		
		await get_tree().create_timer(0.2).timeout
		hitbox.disabled = false

func _on_update_movement_timeout():
	player_detection()

func _on_player_not_seen_timeout():
	is_sleeping = true

func _on_animated_sprite_2d_animation_finished():
	is_attacking = false
	hitbox.disabled = true

func _on_hitbox_area_body_entered(body):
	if body != self:
		if body.has_method("handle_damage"):
			body.handle_damage(damage)

func _on_attack_cooldown_timeout():
	can_attack = true
