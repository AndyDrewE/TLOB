#health_bar.gd

extends ColorRect

@onready var health_value = $value


func update_health_ui(current_health, max_health):
	health_value.size.x = (self.size.x - health_value.position.x*2) * current_health/ max_health 
