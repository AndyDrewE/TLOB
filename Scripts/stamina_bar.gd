# stamina_bar.gd

extends ColorRect

@onready var stamina_value = $value


func update_stamina_ui(current_stamina, max_stamina):
	stamina_value.size.x = (self.size.x - stamina_value.position.x*2) * current_stamina/ max_stamina
