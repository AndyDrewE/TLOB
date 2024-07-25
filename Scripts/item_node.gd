## item_node.gd
extends Node2D

class_name ItemNode

@onready var item_icon = $item_icon

var item : Item

func _ready():
	item_icon.texture = item.texture
