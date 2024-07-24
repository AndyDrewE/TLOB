## item_node.gd

extends Node2D

@onready var item_icon = $item_icon

var item : Item

func _ready():
	item_icon = item.texture
