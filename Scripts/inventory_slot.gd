##inventory_slot.gd

extends Panel

var full_tex = preload("res://Assets/inventory/item_slot_background.png")
var empty_tex = preload("res://Assets/inventory/item_slot_empty_background.png")

var full_style : StyleBoxTexture = null
var empty_style : StyleBoxTexture = null

var itemNode = null

func _ready():
	full_style = StyleBoxTexture.new()
	empty_style = StyleBoxTexture.new()
	full_style.texture = full_tex
	empty_style.texture = empty_tex
		
	refresh_style()


func refresh_style():
	if itemNode == null:
		set('theme_override_styles/panel', empty_style)
	else:
		set('theme_override_styles/panel', full_style)
		

