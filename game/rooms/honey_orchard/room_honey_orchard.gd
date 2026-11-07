@tool
extends ReemRoom

const Data := preload("room_honey_orchard_state.gd")
const ARRIVAL_ROOMS := ["OakForest", "RockCave", "MeadowLake"]
var state: Data = load("res://game/rooms/honey_orchard/room_honey_orchard.tres")

func _on_room_started() -> void:
	if not Globals.orchard.get("introduced", false):
		Globals.orchard["introduced"] = true
		await Lines.say("reem_orchard_arrive")

func _setup_room() -> void:
	if is_instance_valid(C.player) and C.player.last_room in ARRIVAL_ROOMS:
		Globals.orchard["origin"] = C.player.last_room
	$HillLabel.text = Globals.notebook.labels["orchard_hill"]
	$WaterfallLabel.text = Globals.notebook.labels["orchard_waterfall"]
	_sync_scene()

func _on_restore_from_savegame() -> void:
	super()
	_sync_scene()

func _sync_scene() -> void:
	$Props/DubbJar.position = Vector2(630, 790) if Globals.orchard.get("carrier", false) else Vector2(478, 617)
	$BearTear.visible = Globals.orchard.get("pulled", false) and not Globals.orchard.get("soft", false)
	$Props/Dubb.modulate = Color(0.83, 0.8, 0.86) if Globals.orchard.get("accused", false) else Color.WHITE
	$HillLabel.visible = is_exit_open("ExitRight")
	$WaterfallLabel.visible = is_exit_open("ExitWaterfall")

func is_exit_open(exit_name: String) -> bool:
	return exit_name == "ExitLeft" or (Globals.orchard.get("carrier", false) and Globals.orchard.get("verified", false))

func has_action(obj: PopochiuClickable) -> bool:
	match obj.script_name:
		"Dubb": return not Globals.orchard.get("carrier", false) or _can_report()
		"DubbJar": return not Globals.orchard.get("carrier", false)
		"Thaaloob": return not Globals.orchard.get("heard", false)
		"LostLanterns": return Globals.orchard.get("heard", false) and not Globals.orchard.get("found", false)
	return super(obj)

func _on_object_clicked(obj: PopochiuClickable) -> void:
	if not has_action(obj):
		return
	match obj.script_name:
		"ExitLeft": await leave_through(obj, Globals.orchard.get("origin", "MeadowLake"))
		"ExitRight": await leave_through(obj, "HillSlope" if R.rooms_states.has("HillSlope") else "End")
		"ExitWaterfall": await leave_through(obj, "WaterfallPath" if R.rooms_states.has("WaterfallPath") else "End")
		"Dubb":
			if not Globals.orchard.get("carrier", false):
				await _help_bear()
			elif _can_report():
				await _report()
		"DubbJar":
			if Globals.orchard.get("soft", false):
				await _free_bear()
			else:
				await _help_bear()
		"Thaaloob": await _hear_accusation()
		"LostLanterns":
			Globals.orchard["found"] = true
			await Lines.say("reem_orchard_wet")

func _can_report() -> bool:
	return Globals.orchard.get("found", false) and not Globals.orchard.get("verified", false)

func _help_bear() -> void:
	if Globals.orchard.get("soft", false):
		await Lines.say("reem_orchard_soft")
		return
	await Lines.say("reem_orchard_bear")
	if await Choices.ask_two(Globals.notebook.labels["orchard_soft"], Globals.notebook.labels["orchard_pull"]):
		Globals.orchard["soft"] = true
		_sync_scene()
		await Lines.say("reem_orchard_soft")
	else:
		if not Globals.orchard.get("pulled", false):
			Globals.orchard["pulled"] = true
			Globals.wilt()
		_sync_scene()
		await Lines.say("reem_orchard_hard")

func _free_bear() -> void:
	Globals.orchard["carrier"] = true
	Globals.friend_cards["dubb"] = true
	if Globals.orchard.get("pulled", false):
		Globals.orchard["pulled"] = false
		Globals.heal()
	else:
		Globals.bloom()
	var slide := create_tween()
	slide.tween_property($Props/DubbJar, "position", Vector2(630, 790), 0.45)
	await slide.finished
	_sync_scene()
	await Lines.say("reem_orchard_free")

func _hear_accusation() -> void:
	await Lines.say("fox_orchard_accuse")
	var inspect: bool = await Choices.ask_two(Globals.notebook.labels["orchard_look"], Globals.notebook.labels["orchard_accuse"])
	Globals.orchard["heard"] = true
	if not inspect:
		Globals.orchard["accused"] = true
		Globals.wilt()
	_sync_scene()
	await Lines.say("reem_orchard_look" if inspect else "reem_orchard_blame")

func _report() -> void:
	Globals.orchard["verified"] = true
	var accused: bool = Globals.orchard.get("accused", false)
	if accused:
		Globals.orchard["accused"] = false
		Globals.heal()
	else:
		Globals.bloom()
	_sync_scene()
	await Lines.say("reem_orchard_sorry" if accused else "reem_orchard_report")
