extends PopochiuInventoryItem
## ROADMAP notebook: hints, discovered words, visited map and earned friend cards.

const Data := preload("res://addons/popochiu/engine/templates/inventory_item_state_template.gd")

var state: Data = load("res://game/inventory_items/notebook/inventory_item_notebook.tres")


#region Virtual ####################################################################################
func _on_click() -> void:
	Globals.notebook.open_notebook()


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
