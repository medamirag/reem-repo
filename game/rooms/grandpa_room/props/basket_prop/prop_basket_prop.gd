@tool
extends PopochiuProp
## The basket on the floor under the mirror. game_spec.md GrandpaRoom, "Click BasketProp":
## picks it up, which makes the mirror fall and break, then offers Choice 1.

const CHOICE1_GREEN := "أُخبِرُ جدّي بالحقيقة"  # game_spec.md short label (GrandpaRoom Choice 1, green)
const CHOICE1_SAND := "أُخبّئُ المرآة"  # game_spec.md short label (GrandpaRoom Choice 1, sand)

#region Virtual ####################################################################################
func _on_click() -> void:
	if Globals.basket_taken:
		E.command_fallback()
		return

	await C.player.walk_to_clicked()
	await C.player.face_clicked()
	await C.player.grab()
	await Lines.say("reem_s1_004")

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

	var went_green: bool = await Choices.ask_two(CHOICE1_GREEN, CHOICE1_SAND)

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
