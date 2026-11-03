extends PopochiuInventoryItem

const Data := preload("res://addons/popochiu/engine/templates/inventory_item_state_template.gd")

var state: Data = load("res://game/inventory_items/basket/inventory_item_basket.tres")


#region Virtual ####################################################################################
func _on_click() -> void:
	E.command_fallback()


func _on_right_click() -> void:
	E.command_fallback()


func _on_middle_click() -> void:
	E.command_fallback()


func _on_item_used(_item: PopochiuInventoryItem) -> void:
	E.command_fallback()


# game_spec.md 4.4: "Play sfx_pickup when an item is added."
func _on_added_to_inventory() -> void:
	super()
	A.sfx_pickup.play()


func _on_discard() -> void:
	super()


#endregion
