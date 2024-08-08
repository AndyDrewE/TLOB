## arrow.gd

extends Area2D

var speed = 300
var damage = 10

func _ready():
	set_as_top_level(true)

func _process(delta):
	position += (Vector2.RIGHT * speed).rotated(rotation) * delta

func set_speed(p_speed):
	speed = p_speed

func set_damage(p_damage):
	damage = p_damage

func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()

func _on_body_entered(body):
	if body != self.get_parent():
		speed = 0
		if body.has_method("handle_damage"):
			body.handle_damage(damage)
		queue_free()
