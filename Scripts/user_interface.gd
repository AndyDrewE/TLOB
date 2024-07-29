## user_interface.gd

extends CanvasLayer

@onready var player_ref = find_parent("player")
var held_item_stack = null

func _input(event):
	if event.is_action_pressed("ui_inventory"):
		$inventory.visible = !$inventory.visible
		
	if event.is_action_pressed("ui_mouse_wheel_up"):
		player_ref.active_item_up()
	if event.is_action_pressed("ui_mouse_wheel_down"):
		player_ref.active_item_down()

