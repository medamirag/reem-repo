@tool
extends ReemRoom

const LITTER := ["Paper", "Bottle", "Tin"]
const SHAPES := ["Circle", "Diamond", "Triangle"]
const PATTERN := [1, 0, 2]
@export var state: PopochiuRoomData


func _on_room_started() -> void:
	var story := Globals.gull
	var introduction := ""
	match script_name:
		"GullShore": introduction = "reem_gull_shore"
		"TideCave": introduction = "reem_gull_cave"
		"GullLighthouse":
			story["storm"] = not story.get("lit", false)
			introduction = "reem_gull_storm"
	if not story.get(script_name, false):
		story[script_name] = true
		await Lines.say(introduction)


func _setup_room() -> void:
	_sync()


func _on_restore_from_savegame() -> void:
	super()
	_sync()


func _sync() -> void:
	var story := Globals.gull
	match script_name:
		"GullShore":
			$HighWater.visible = not story.get("low", false)
			for item in LITTER:
				get_prop(item).visible = not story.get(item, false)
		"TideCave":
			$Example.visible = story.get("pattern", false) and not story.get("lens", false)
			for index in $Example.get_child_count():
				$Example.get_child(index).modulate.a = 0.45 if index < story.get("step", 0) else 1.0
			$Props/Octopus/Sprite2D.modulate = Color("#c6e1dc") if story.get("lens", false) else Color.WHITE
		"GullLighthouse":
			$Beam.visible = story.get("lit", false)
			$ShellPile.position.y = 761.0 if story.get("piled", false) else 791.0
			$ShellPile.rotation = 0.25 if story.get("piled", false) else 0.0


func is_exit_open(exit_name: String) -> bool:
	var story := Globals.gull
	if script_name == "GullShore":
		if exit_name == "ExitLeft":
			return not story.get("storm", false)
		return story.get("low", false) and story.get("clean", false)
	return true


func has_action(obj: PopochiuClickable) -> bool:
	var story := Globals.gull
	match obj.script_name:
		"Turtle": return not story.get("clean", false)
		"ReturnBoat": return not story.get("storm", false)
		"Paper", "Bottle", "Tin": return story.get("collect", false) and not story.get(obj.script_name, false)
		"Octopus": return not story.get("lens", false)
		"Circle", "Diamond", "Triangle": return story.get("pattern", false) and not story.get("lens", false)
		"Gull": return not story.get("shared", false)
		"Lamp": return not story.get("lit", false)
		"IslandFox": return not story.get("fox_trade", false)
	return super(obj)


func _on_object_clicked(obj: PopochiuClickable) -> void:
	if not has_action(obj):
		return
	match obj.script_name:
		"ReturnBoat": await leave_through(obj, "MeadowLake")
		"ExitLeft":
			var previous := {"GullShore": "MeadowLake", "TideCave": "GullShore", "GullLighthouse": "TideCave"}
			await leave_through(obj, previous[script_name])
		"ExitRight":
			var following := {"GullShore": "TideCave", "TideCave": "GullLighthouse"}
			await leave_through(obj, following[script_name])
		"Turtle": await _talk_to_turtle()
		"TideRock": await _toggle_tide()
		"Paper", "Bottle", "Tin": await _pick_up_litter(obj.script_name)
		"Octopus": await _show_pattern()
		"Circle", "Diamond", "Triangle": await _choose_shape(obj.script_name)
		"Gull": await _share_shells()
		"Lamp": await _repair_lamp()
		"IslandFox":
			Globals.gull["fox_trade"] = true
			await Lines.say("fox_gull_trade")
			E.save_game(1)


func _talk_to_turtle() -> void:
	var story := Globals.gull
	if story.get("collect", false):
		await Lines.say("reem_gull_collect")
		return
	await Lines.say("reem_gull_turtle")
	if await Choices.ask_two(Globals.notebook.labels["gull_collect"], Globals.notebook.labels["gull_leave"]):
		story["collect"] = true
		await Lines.say("reem_gull_collect")
	else:
		if not story.get("left_litter", false):
			story["left_litter"] = true
			Globals.wilt()
		await Lines.say("reem_gull_leave")
	E.save_game(1)


func _pick_up_litter(id: String) -> void:
	var story := Globals.gull
	story[id] = true
	_sync()
	for item in LITTER:
		if not story.get(item, false):
			E.save_game(1)
			return
	story["clean"] = true
	Globals.friend_cards["gull_turtle"] = true
	_reward("left_litter")
	await Lines.say("reem_gull_clean")
	E.save_game(1)


func _toggle_tide() -> void:
	var low: bool = not Globals.gull.get("low", false)
	Globals.gull["low"] = low
	_sync()
	await Lines.say("reem_gull_low" if low else "reem_gull_high")
	E.save_game(1)


func _show_pattern() -> void:
	Globals.gull["pattern"] = true
	Globals.gull["step"] = 0
	_sync()
	await Lines.say("reem_gull_pattern")


func _choose_shape(id: String) -> void:
	var story := Globals.gull
	var step := int(story.get("step", 0))
	if SHAPES.find(id) != PATTERN[step]:
		story["step"] = 0
		_sync()
		await Lines.say("reem_gull_retry")
		return
	story["step"] = step + 1
	if story["step"] == PATTERN.size():
		story["lens"] = true
		Globals.friend_cards["gull_octopus"] = true
		Globals.bloom()
		_sync()
		await Lines.say("reem_gull_lens")
	else:
		_sync()
	E.save_game(1)


func _share_shells() -> void:
	var story := Globals.gull
	await Lines.say("reem_gull_shells")
	if await Choices.ask_two(Globals.notebook.labels["gull_share"], Globals.notebook.labels["gull_pile"]):
		story["shared"] = true
		Globals.friend_cards["gull_bird"] = true
		_reward("piled")
		_sync()
		await Lines.say("reem_gull_share")
	else:
		if not story.get("piled", false):
			story["piled"] = true
			Globals.wilt()
		_sync()
		await Lines.say("reem_gull_pile")
	E.save_game(1)


func _repair_lamp() -> void:
	var story := Globals.gull
	if not story.get("lens", false):
		await Lines.say("reem_gull_lens_hint")
		return
	story["lit"] = true
	story["storm"] = false
	Globals.bloom()
	_sync()
	await Lines.say("reem_gull_light")
	E.save_game(1)


func _reward(mistake: String) -> void:
	if Globals.gull.get(mistake, false):
		Globals.gull[mistake] = false
		Globals.heal()
	else:
		Globals.bloom()
