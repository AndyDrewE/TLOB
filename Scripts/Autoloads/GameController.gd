##GameController.gd
extends Node2D

@onready var player_ref = get_tree().root.get_node("main/player")

func _ready():
	pass

func _input(event):
	if event.is_action_pressed("ui_debug"):
		print("===================")
		print("Current Health: %s" %player_ref.current_health)
		print("Current Stamina: %s" %player_ref.current_stamina)
		player_ref.get_active_item()
		print("===================")
