@tool
extends PopochiuProp
## The basket, hanging on the wall right under Grandpa's mirror with its handle tucked behind
## the mirror's frame (user's request: the basket must be near the mirror, so it makes sense
## that taking it brings the mirror down; game_spec.md had it on the floor). game_spec.md
## GrandpaRoom, "Click BasketProp": Reem reaches up and takes it, which makes the mirror fall and
## break, then Choice 1.

## Where Reem stands when she takes the basket, relative to the basket, in room pixels: on the
## floor just below it, a little to the left. A starting point: adjust in the Inspector.
@export var reem_stand_offset := Vector2(-230, 420)

#region Virtual ####################################################################################
func _on_click() -> void:
	if Globals.basket_taken:
		E.command_fallback()
		return

	await C.player.walk_to_clicked(reem_stand_offset)
	await C.player.face_clicked()
	# The basket hangs above her head: she reaches up instead of bending down.
	await C.player.reach_up()
	# reem_s1_004 ("I'll take the basket") is said at the start of the room instead (user request).

	await C.player.add_to_inventory(I.Basket)
	disable()
	Globals.basket_taken = true

	# Note: using R.current (typed PopochiuRoom) rather than this clickable's own `room`
	# property, which is only typed as Node2D and so doesn't expose get_prop()/get_marker().
	var mirror: PopochiuProp = R.current.get_prop("Mirror")
	if mirror and mirror.has_method("break_mirror"):
		await mirror.break_mirror()
	Globals.mirror_broken = true

	await Lines.say("reem_s1_005")
	await Lines.say("reem_s1_006")

	var went_green: bool = await Choices.ask_two(Labels.CHOICE1_GREEN, Labels.CHOICE1_SAND)

	if went_green:
		await Lines.say("reem_s1_007a")
		Globals.chose_truth = true
	else:
		await Lines.say("reem_s1_007b")

		var cushion: Marker2D = R.current.get_marker("RightCushion")
		if cushion:
			await C.player.walk_to(cushion.position)

		if mirror:
			mirror.disable()

		Globals.mirror_hidden = true
		Globals.wilt()


func _on_double_click() -> void:
	E.command_fallback()


func _on_right_click() -> void:
	E.command_fallback()


func _on_middle_click() -> void:
	E.command_fallback()


func _on_item_used(_item: PopochiuInventoryItem) -> void:
	E.command_fallback()


func _on_linked_item_removed() -> void:
	pass


func _on_linked_item_discarded() -> void:
	pass


func _on_movement_started() -> void:
	pass


func _on_movement_ended() -> void:
	pass


#endregion
