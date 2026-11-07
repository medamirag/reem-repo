@tool
extends ReemRoom

const LANE_FINDINGS := ["BasketA", "BasketB", "WaterJug"]
const COURT_DATES := ["DateA", "DateB", "DateC"]
@export var state: PopochiuRoomData


func _on_room_started() -> void:
	var story := Globals.ramadan
	if story.get(script_name, false):
		return
	story[script_name] = true
	var introductions := {
		"RamadanLane": "reem_ramadan_lane",
		"HedgehogCourt": "reem_ramadan_court",
		"IftarShelter": "reem_ramadan_shelter",
	}
	await Lines.say(introductions[script_name])


func _setup_room() -> void:
	_sync_lantern()


func _on_restore_from_savegame() -> void:
	super()
	_sync_lantern()


func _sync_lantern() -> void:
	var story := Globals.ramadan
	var lit: bool = story.get("lit", false)
	$Props/LanternToggle/Sprite2D.modulate = Color("#ffe2a0") if lit else Color("#9a9bb1")
	$WarmLight.visible = lit
	match script_name:
		"RamadanLane":
			for id in LANE_FINDINGS:
				get_prop(id).visible = lit and not story.get(id, false)
		"HedgehogCourt":
			for id in COURT_DATES:
				get_prop(id).visible = lit and story.get("share", false) and not story.get(id, false)
		"IftarShelter":
			$TableFood.visible = story.get("meal", false)
			$Props/Traveller.visible = story.get("meal", false)
			$Props/ServedDates.visible = story.get("meal", false)


func is_exit_open(exit_name: String) -> bool:
	if exit_name == "ExitLeft":
		return true
	if script_name == "RamadanLane":
		return Globals.ramadan.get("supplies", false)
	return Globals.ramadan.get("dates", false)


func has_action(obj: PopochiuClickable) -> bool:
	var story := Globals.ramadan
	match obj.script_name:
		"BasketA", "BasketB", "WaterJug", "DateA", "DateB", "DateC":
			return obj.visible and not story.get(obj.script_name, false)
		"Hedgehogs":
			return not story.get("dates", false)
		"FoodTable":
			return not story.get("meal", false)
		"RamadanFox":
			return not story.get("shared_last", false)
		"Traveller", "ServedDates":
			return false
	return super(obj)


func _on_object_clicked(obj: PopochiuClickable) -> void:
	if not has_action(obj):
		return
	match obj.script_name:
		"ExitLeft":
			var back := {"RamadanLane": "Yard", "HedgehogCourt": "RamadanLane", "IftarShelter": "HedgehogCourt"}
			await leave_through(obj, back[script_name])
		"ExitRight":
			var next := {"RamadanLane": "HedgehogCourt", "HedgehogCourt": "IftarShelter"}
			await leave_through(obj, next[script_name])
		"LanternToggle":
			Globals.ramadan["lit"] = not Globals.ramadan.get("lit", false)
			_sync_lantern()
			E.save_game(1)
		"Caller":
			await Lines.say("reem_ramadan_caller")
			await Lines.say("reem_ramadan_search")
		"BasketA", "BasketB", "WaterJug":
			await _find_supply(obj.script_name)
		"Hedgehogs":
			await _offer_dates()
		"DateA", "DateB", "DateC":
			await _collect_date(obj.script_name)
		"RamadanFox":
			await _share_last_date()
		"FoodTable":
			await _serve_iftar()


func _find_supply(id: String) -> void:
	var story := Globals.ramadan
	story[id] = true
	_sync_lantern()
	for supply in LANE_FINDINGS:
		if not story.get(supply, false):
			E.save_game(1)
			return
	story["supplies"] = true
	Globals.bloom()
	await Lines.say("reem_ramadan_found", true)
	E.save_game(1)


func _offer_dates() -> void:
	var story := Globals.ramadan
	if story.get("share", false):
		await Lines.say("reem_ramadan_dates")
		return
	await Lines.say("reem_ramadan_court")
	if await Choices.ask_two(Globals.notebook.labels["ramadan_share"], Globals.notebook.labels["ramadan_keep"]):
		story["share"] = true
		_sync_lantern()
		await Lines.say("reem_ramadan_dates")
	else:
		if not story.get("kept", false):
			story["kept"] = true
			Globals.wilt()
		await Lines.say("reem_ramadan_keep", true)
	E.save_game(1)


func _collect_date(id: String) -> void:
	var story := Globals.ramadan
	story[id] = true
	_sync_lantern()
	for date in COURT_DATES:
		if not story.get(date, false):
			E.save_game(1)
			return
	story["dates"] = true
	Globals.friend_cards["hedgehog_family"] = true
	if story.get("kept", false):
		story["kept"] = false
		Globals.heal()
	else:
		Globals.bloom()
	await Lines.say("reem_ramadan_shared")
	E.save_game(1)


func _share_last_date() -> void:
	Globals.ramadan["shared_last"] = true
	await Lines.say("fox_ramadan_date")
	E.save_game(1)


func _serve_iftar() -> void:
	var story := Globals.ramadan
	if not story.get("dates", false) or not story.get("supplies", false):
		await Lines.say("reem_ramadan_dates")
		return
	if not story.get("shared_last", false):
		await _share_last_date()
	story["meal"] = true
	Globals.bloom()
	_sync_lantern()
	await Lines.say("reem_ramadan_feast")
	E.save_game(1)
