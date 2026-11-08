@tool
extends ReemRoom

const Data := preload("room_meadow_lake_state.gd")
var state: Data = load("res://game/rooms/meadow_lake/room_meadow_lake.tres")

func _on_room_started() -> void:
	if not Globals.lake.get("introduced", false):
		Globals.lake["introduced"] = true
		await Lines.say("reem_lake_arrive")

func _setup_room() -> void:
	_sync_scene()

func _on_restore_from_savegame() -> void:
	super()
	_sync_scene()

func _sync_scene() -> void:
	var reunited: bool = Globals.lake.get("reunited", false)
	$MotherStandIn.visible = reunited
	$Props/Ghazlana.position = Vector2(1000, 803) if reunited else Vector2(825, 790)
	$SongNotes.visible = Globals.lake.get("flute", false)
	$WarmCup.visible = Globals.lake.get("flute", false)
	for index in range(1, 4):
		var mark := get_node("Props/Print%d/Mark" % index) as Polygon2D
		mark.color = Color("#a76532") if Globals.lake.get("tracking", false) and index == Globals.lake.get("tracks", 0) + 1 else Color("#6d4633")

func is_exit_open(exit_name: String) -> bool:
	return exit_name == "ExitLeft" or (Globals.lake.get("flute", false) and Globals.lake.get("reunited", false))

func has_action(obj: PopochiuClickable) -> bool:
	match obj.script_name:
		"Dafdoof": return not Globals.lake.get("flute", false)
		"Ghazlana": return not Globals.lake.get("reunited", false)
	if obj.script_name.begins_with("Print"):
		return Globals.lake.get("tracking", false) and not Globals.lake.get("reunited", false)
	return super(obj)

func _on_object_clicked(obj: PopochiuClickable) -> void:
	if not has_action(obj):
		return
	match obj.script_name:
		"ExitLeft": await leave_through(obj, "PineFork")
		"ExitRight": await leave_through(obj, "HoneyOrchard" if R.rooms_states.has("HoneyOrchard") else "End")
		"Dafdoof": await _help_frog()
		"WoodenBoat": await _visit_boat()
		"Ghazlana":
			Globals.lake["tracking"] = true
			_sync_scene()
			await Lines.say("reem_lake_gazelle")
		_:
			if obj.script_name.begins_with("Print"):
				await _follow_print(int(obj.script_name.trim_prefix("Print")))

func _help_frog() -> void:
	await Lines.say("reem_lake_frog")
	if not C.player.has_inventory_item("HoneyJar") and not Globals.lake.get("reserve", false):
		await Lines.say("reem_lake_need_honey")
		return
	if await Choices.ask_two(Globals.notebook.labels["lake_share"], Globals.notebook.labels["lake_keep"]):
		Globals.lake["flute"] = true
		Globals.lake["reserve"] = false
		Globals.friend_cards["dafdoof"] = true
		if Globals.lake.get("kept", false):
			Globals.lake["kept"] = false
			Globals.heal()
		else:
			Globals.bloom()
		_sync_scene()
		await Lines.say("reem_lake_share")
	else:
		if not Globals.lake.get("kept", false):
			Globals.lake["kept"] = true
			Globals.wilt()
		await Lines.say("reem_lake_keep")

func _visit_boat() -> void:
	if not C.player.has_inventory_item("HoneyJar") and not Globals.lake.get("reserve", false) and not Globals.lake.get("flute", false):
		await Lines.say("reem_lake_boat")
		Globals.lake["reserve"] = true
		await Lines.say("reem_lake_reserve")
		return
	if Globals.unlocked_packs.get("1", false) and R.rooms_states.has("GullShore"):
		await Lines.say("reem_gull_board")
		if await Choices.ask_two(Globals.notebook.labels["gull_board"], Globals.notebook.labels["gull_stay"]):
			await leave_through(get_prop("WoodenBoat"), "GullShore")
	else:
		await Lines.say("reem_lake_boat")

func _follow_print(index: int) -> void:
	if index != Globals.lake.get("tracks", 0) + 1:
		return
	Globals.lake["tracks"] = index
	if index < 3:
		_sync_scene()
		await Lines.say("reem_lake_tracks")
		return
	Globals.lake["reunited"] = true
	Globals.friend_cards["ghazlana"] = true
	Globals.bloom()
	_sync_scene()
	await Lines.say("reem_lake_reunion")
