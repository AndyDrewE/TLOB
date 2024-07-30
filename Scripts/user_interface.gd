## user_interface.gd

extends CanvasLayer

@onready var player_ref = find_parent("player")
var held_item_stack = null

#Health/Stamina Bars Value
@onready var health_value = $health_bar/value
@onready var stamina_value = $stamina_bar/value

func _input(event):
	if event.is_action_pressed("ui_inventory"):
		$inventory.visible = !$inventory.visible
		
	if event.is_action_pressed("ui_mouse_wheel_up"):
		player_ref.active_item_up()
	if event.is_action_pressed("ui_mouse_wheel_down"):
		player_ref.active_item_down()

func update_health_ui(current_health, max_health):
	health_value.size.x = ($health_bar.size.x - health_value.position.x*2) * current_health/ max_health 

func update_stamina_ui(current_stamina, max_stamina):
	stamina_value.size.x = ($stamina_bar.size.x - health_value.position.x*2) * current_stamina/ max_stamina 
