@tool
extends PopochiuHotspot
## The blue door on the right, game_spec.md GrandpaRoom: → Yard, with sfx_door
## (game_spec.md 4.6: "sfx_door when leaving GrandpaRoom through the blue door").


#region Virtual ####################################################################################
func _on_click() -> void:
	G.block()
	await C.player.walk(to_global(walk_to_point))
	G.unblock()
	A.sfx_door.play()
	R.goto_room("Yard")


func _on_double_click() -> void:
	await _on_click()


func _on_right_click() -> void:
	await _on_click()


func _on_middle_click() -> void:
	pass


func _on_item_used(_item: PopochiuInventoryItem) -> void:
	pass


#endregion
