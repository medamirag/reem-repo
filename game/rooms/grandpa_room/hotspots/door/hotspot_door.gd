@tool
extends PopochiuHotspot
## The blue door on the right, game_spec.md GrandpaRoom: → Yard, with sfx_door
## (game_spec.md 4.6: "sfx_door when leaving GrandpaRoom through the blue door").


#region Virtual ####################################################################################
func _on_click() -> void:
	# Not in game_spec.md (Decisions to review): the door does nothing until Choice 1 has been
	# answered. Leaving before picking up the basket would skip the mirror story, and without
	# it Reem could never get the HandMirror the BigTree needs (the game would be stuck).
	if not (Globals.chose_truth or Globals.mirror_hidden):
		return

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
