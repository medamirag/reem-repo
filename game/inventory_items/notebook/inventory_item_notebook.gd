extends PopochiuInventoryItem
## game_spec.md 4.4: "Clicking it in the inventory plays the current hint." The hint itself is
## whatever the current room put in Globals.notebook_hint (a Callable); rooms that give no hint
## leave it empty, so clicking does nothing (game_spec.md 7: no click ever breaks the game).

const Data := preload("res://addons/popochiu/engine/templates/inventory_item_state_template.gd")

var state: Data = load("res://game/inventory_items/notebook/inventory_item_notebook.tres")


#region Virtual ####################################################################################
func _on_click() -> void:
	if Globals.notebook_hint.is_valid():
		await Globals.notebook_hint.call()
	else:
		# No hint in this room: nothing happens (it does not become the mouse cursor either).
		await get_tree().process_frame


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
