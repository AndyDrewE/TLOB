## user_interface.gd

extends CanvasLayer

@onready var player_ref = find_parent("player")
var held_item_stack = null

#Health/Stamina Bars
@onready var health_bar = $health_bar
@onready var stamina_bar = $stamina_bar

func _input(event):
	if event.is_action_pressed("ui_inventory"):
		$inventory.visible = !$inventory.visible
		player_ref.can_attack = !$inventory.visible
		
	if event.is_action_pressed("ui_mouse_wheel_up"):
		player_ref.active_item_up()
	if event.is_action_pressed("ui_mouse_wheel_down"):
		player_ref.active_item_down()

