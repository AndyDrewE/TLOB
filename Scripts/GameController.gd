##GameController.gd
extends Node2D

@onready var player = get_tree().root.get_node("main/player")

func _input(event):
	if event.is_action_pressed("ui_debug"):
		print("===================")
		print("Held Item: %s" % player.inventory.held_item.item.name)
		print("===================")
