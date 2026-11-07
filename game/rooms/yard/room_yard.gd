@tool
extends ReemRoom
## Station 1, room 2: Yard (game_spec.md). Grandpa (Jad) sits on his bench under the olive tree.
## He briefs Reem and gives her the Lantern and the Notebook. If she told the truth about the
## mirror (Choice 1 green) she confesses right after; if she hid it, she comes back later when
## she needs the mirror (needs_mirror, set in BigTree). The Well gives the WateringCan.
## Exits: the house door (left) → GrandpaRoom; right edge → Gate.

const Data := preload('room_yard_state.gd')

var state: Data = load("res://game/rooms/yard/room_yard.tres")


#region Virtual ####################################################################################
func _setup_room() -> void:
	$Props/TreeDayEntry.visible = Globals.festival.get("completed", false)
	$Props/RamadanEntry.visible = Globals.unlocked_packs.get("3", false)


func _on_object_clicked(obj: PopochiuClickable) -> void:
	match obj.script_name:
		"TreeDayEntry":
			if obj.visible:
				await leave_through(obj, "TreeDay")
		"RamadanEntry":
			if not obj.visible:
				return
			await Lines.say("reem_ramadan_offer")
			if await Choices.ask_two(Globals.notebook.labels["ramadan_go"], Globals.notebook.labels["ramadan_stay"]):
				await leave_through(obj, "RamadanLane")
		"Jad":
			await _talk_to_jad()
		"Well":
			await _use_well()
		"ExitLeft":
			A.sfx_door.play()
			await leave_through(obj, "GrandpaRoom")
		"ExitRight":
			await leave_through(obj, "Gate")


func has_action(obj: PopochiuClickable) -> bool:
	if obj.script_name in ["RamadanEntry", "TreeDayEntry"]:
		return obj.visible
	if obj.script_name == "Well":
		return not C.player.has_inventory_item("WateringCan")
	return super(obj)


#endregion

#region Private ####################################################################################
func _talk_to_jad() -> void:
	await C.player.walk_to_clicked()
	RoomHelpers.face(C.player, false)

	if not Globals.briefed:
		await _briefing()
		# game_spec.md: "Then, if chose_truth and not confessed" — straight after the briefing.
		if Globals.chose_truth and not Globals.confessed:
			await _confess_truth()
		return

	if Globals.chose_truth and not Globals.confessed:
		await _confess_truth()
	elif Globals.mirror_hidden and not Globals.confessed:
		if Globals.needs_mirror:
			await _confess_late()
		else:
			await Lines.say("jad_s1_019")
	else:
		await Lines.say("jad_s1_019")


## Talk to Jad, first time (briefed == false).
func _briefing() -> void:
	await Lines.say("reem_s1_010")
	await Lines.say("jad_s1_011")
	await Lines.say("reem_s1_012")
	await Lines.say("jad_s1_013")
	await Lines.say("reem_s1_014")
	await Lines.say("jad_s1_015")
	await C.player.add_to_inventory(I.Lantern)
	await Lines.say("reem_s1_016")
	await Lines.say("jad_s1_017")
	await C.player.add_to_inventory(I.Notebook)
	await Lines.say("reem_s1_018")
	await Lines.say("jad_s1_019")
	Globals.briefed = true


## Choice 1 was green: Reem tells Grandpa about the mirror right after the briefing.
func _confess_truth() -> void:
	await Choices.ask_one(Labels.CONFESS)
	await Lines.say("reem_s1_021a")
	await Lines.say("jad_s1_022a")
	await Lines.say("jad_s1_023")
	await Lines.say("jad_s1_024")
	await C.player.add_to_inventory(I.HandMirror)
	Globals.confessed = true
	Globals.bloom()


## Choice 1 was sand, and Shahd's flowers need a mirror (needs_mirror): Reem finally confesses.
func _confess_late() -> void:
	await Lines.say("reem_s1_021b")
	await Lines.say("jad_s1_022b")
	await Lines.say("jad_s1_023b")
	await Lines.say("reem_s1_024b")
	await Lines.say("jad_s1_024")
	await C.player.add_to_inventory(I.HandMirror)
	Globals.confessed = true
	Globals.mirror_hidden = false
	Globals.heal()


func _use_well() -> void:
	if C.player.has_inventory_item("WateringCan"):
		return

	await C.player.walk_to_clicked()
	await C.player.grab()
	await Lines.say("reem_s1_020")
	await C.player.add_to_inventory(I.WateringCan)


#endregion
