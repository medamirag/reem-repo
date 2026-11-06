@tool
extends ReemRoom
## Station 2, room 6: FoxRock (game_spec.md). Thaaloob the fox offers a "magic" shining stone in
## exchange for Grandpa's hand mirror (Choice 3). Green: Reem refuses (Bloom). Sand: she trades;
## wiping the stone in the inventory shows it is just a pebble covered in honey (Wilt), and she
## asks Thaaloob for the mirror back (Heal). Exits: left → BigTree; right → PineFork,
## only when fox_done.

const Data := preload('room_fox_rock_state.gd')

var state: Data = load("res://game/rooms/fox_rock/room_fox_rock.tres")


#region Virtual ####################################################################################
func _on_room_started() -> void:
	# game_spec.md: "On first entering (or first click on Thaaloob)".
	if not Globals.fox_intro_done:
		await _meet_thaaloob()


func _on_object_clicked(obj: PopochiuClickable) -> void:
	match obj.script_name:
		"Thaaloob":
			await _talk_to_thaaloob()
		"ExitLeft":
			await leave_through(obj, "BigTree")
		"ExitRight":
			if Globals.fox_done:
				await Lines.say("reem_s2_070")
				await leave_through(obj, "PineFork")


func is_exit_open(exit_name: String) -> bool:
	return exit_name != "ExitRight" or Globals.fox_done


func has_action(obj: PopochiuClickable) -> bool:
	if obj.script_name == "Thaaloob":
		return not Globals.fox_intro_done or (Globals.stone_wiped and not Globals.mirror_recovered)
	return super(obj)


#endregion

#region Private ####################################################################################
func _talk_to_thaaloob() -> void:
	if not Globals.fox_intro_done:
		await C.player.walk_to_clicked()
		await _meet_thaaloob()
		return

	if Globals.stone_wiped and not Globals.mirror_recovered:
		await C.player.walk_to_clicked()
		RoomHelpers.face(C.player, false)
		await Lines.say("reem_s2_057b")
		await Lines.say("fox_s2_058b")
		await C.player.remove_from_inventory(I.Stone)
		await C.player.add_to_inventory(I.HandMirror)
		await Lines.say("reem_s2_059b")
		Globals.heal()
		Globals.mirror_recovered = true
		Globals.fox_done = true


func _meet_thaaloob() -> void:
	Globals.fox_intro_done = true
	G.block()
	await C.player.walk(C.Thaaloob.to_global(C.Thaaloob.walk_to_point))
	G.unblock()
	RoomHelpers.face(C.player, false)

	await Lines.say("fox_s2_050")
	await Lines.say("reem_s2_051")
	await Lines.say("fox_s2_052")
	await Lines.say("fox_s2_053")

	var went_green: bool = await Choices.ask_two(Labels.CHOICE3_GREEN, Labels.CHOICE3_SAND)
	if went_green:
		await Lines.say("reem_s2_054a")
		await Lines.say("fox_s2_055a")
		Globals.bloom()
		Globals.fox_done = true
	else:
		await Lines.say("reem_s2_054b")
		await C.player.remove_from_inventory(I.HandMirror)
		await C.player.add_to_inventory(I.Stone)
		Globals.traded = true


#endregion
