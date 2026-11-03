extends PopochiuInventoryItem
## game_spec.md: starts as `stone_shiny`, becomes `stone_dull` once wiped clean (FoxRock room).

const Data := preload("res://addons/popochiu/engine/templates/inventory_item_state_template.gd")
const DULL_TEXTURE := preload("res://assets/cut/stone_states/stone_dull.tres")

var state: Data = load("res://game/inventory_items/stone/inventory_item_stone.tres")


#region Virtual ####################################################################################
func _on_click() -> void:
	E.command_fallback()


func _on_right_click() -> void:
	E.command_fallback()


func _on_middle_click() -> void:
	E.command_fallback()


func _on_item_used(_item: PopochiuInventoryItem) -> void:
	E.command_fallback()


func _on_added_to_inventory() -> void:
	super()
	A.sfx_pickup.play()


func _on_discard() -> void:
	super()


#endregion

#region Public #####################################################################################
## Swaps the picture to the wiped-clean, dull version (game_spec.md, FoxRock room).
func set_dull() -> void:
	texture = DULL_TEXTURE


#endregion
