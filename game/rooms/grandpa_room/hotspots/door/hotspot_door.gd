@tool
extends PopochiuHotspot
## The blue door on the right, game_spec.md GrandpaRoom: → Yard. Yard does not exist yet this
## session, so until it is registered, clicking the door just does nothing (game_spec.md 7: a
## click never breaks the game) instead of erroring.


#region Virtual ####################################################################################
func _on_click() -> void:
	if PopochiuResources.get_data_value("rooms", "Yard", "").is_empty():
		E.command_fallback()
		return

	await C.player.walk_to_clicked()
	A.sfx_door.play()
	R.goto_room("Yard")


func _on_double_click() -> void:
	E.command_fallback()


func _on_right_click() -> void:
	E.command_fallback()


func _on_middle_click() -> void:
	E.command_fallback()


func _on_item_used(_item: PopochiuInventoryItem) -> void:
	E.command_fallback()


#endregion
