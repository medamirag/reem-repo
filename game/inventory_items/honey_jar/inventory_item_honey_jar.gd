extends PopochiuInventoryItem

const Data := preload("res://addons/popochiu/engine/templates/inventory_item_state_template.gd")

var state: Data = load("res://game/inventory_items/honey_jar/inventory_item_honey_jar.tres")


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
