@tool
extends ReemRoom

const SEEDS := ["SeedSmall", "SeedMiddle", "SeedLarge"]
@export var state: PopochiuRoomData
@export var storage_slots := PackedVector2Array([Vector2(482, 779), Vector2(920, 491), Vector2(1240, 779)])


func _on_room_started() -> void:
	var story := Globals.ants
	if story.get(script_name, false):
		return
	story[script_name] = true
	match script_name:
		"GiantBloom": await Lines.say("reem_ant_tiny", true)
		"DewBank": await Lines.say("reem_ant_dew", true)
		"AntCity": await Lines.say("reem_ant_city", true)


func _setup_room() -> void:
	_sync_ants()


func _on_restore_from_savegame() -> void:
	super()
	_sync_ants()


func _sync_ants() -> void:
	var story := Globals.ants
	match script_name:
		"GiantBloom":
			$Props/HeavySeed.visible = not story.get("carried", false)
			$StoredSeed.visible = story.get("carried", false)
		"DewBank":
			$Props/LeafBridge.rotation = 0.0 if story.get("aligned", false) else -0.43
		"AntCity":
			for index in SEEDS.size():
				if index < story.get("stored", 0):
					get_prop(SEEDS[index]).position = storage_slots[index]
			$Rain.visible = story.get("stored", 0) == 3 and not story.get("safe", false)


func is_exit_open(exit_name: String) -> bool:
	if exit_name == "ExitLeft":
		return true
	if script_name == "GiantBloom":
		return Globals.ants.get("carried", false)
	return Globals.ants.get("crossing", false) and Globals.ants.get("aligned", false)


func has_action(obj: PopochiuClickable) -> bool:
	var story := Globals.ants
	match obj.script_name:
		"Worker": return not story.get("carried", false)
		"HeavySeed": return story.get("share", false) and not story.get("carried", false)
		"LeafBridge": return not story.get("crossing", false)
		"Beetle": return not story.get("crossing", false)
		"TinyFox": return not story.get("fox", false)
		"Queen": return story.get("stored", 0) < 3
		"SeedSmall", "SeedMiddle", "SeedLarge":
			return story.get("ordering", false) and SEEDS.find(obj.script_name) >= story.get("stored", 0)
		"Tunnel": return story.get("stored", 0) == 3 and not story.get("safe", false)
	return super(obj)


func _on_object_clicked(obj: PopochiuClickable) -> void:
	if not has_action(obj):
		return
	var story := Globals.ants
	match obj.script_name:
		"ExitLeft":
			var back := {"GiantBloom": "MeadowFork", "DewBank": "GiantBloom", "AntCity": "DewBank"}
			await leave_through(obj, back[script_name])
		"ExitRight":
			var next := {"GiantBloom": "DewBank", "DewBank": "AntCity"}
			await leave_through(obj, next[script_name])
		"Worker": await _offer_help()
		"HeavySeed": await _carry_seed()
		"LeafBridge":
			story["aligned"] = not story.get("aligned", false)
			_sync_ants()
			if story["aligned"]:
				await Lines.say("reem_ant_bridge", true)
			E.save_game(1)
		"Beetle": await _ask_guard()
		"TinyFox":
			story["fox"] = true
			await Lines.say("fox_ant_hurry")
			E.save_game(1)
		"Queen":
			story["ordering"] = true
			await Lines.say("reem_ant_order", true)
		"SeedSmall", "SeedMiddle", "SeedLarge":
			await _store_seed(obj.script_name)
		"Tunnel": await _enter_tunnel()


func _offer_help() -> void:
	var story := Globals.ants
	if story.get("share", false):
		await Lines.say("reem_ant_carry", true)
		return
	await Lines.say("reem_ant_worker", true)
	if await Choices.ask_two(Globals.notebook.labels["ant_share"], Globals.notebook.labels["ant_leave"]):
		story["share"] = true
		await Lines.say("reem_ant_carry", true)
	else:
		if not story.get("left", false):
			story["left"] = true
			Globals.wilt()
		await Lines.say("reem_ant_leave", true)
	E.save_game(1)


func _carry_seed() -> void:
	var story := Globals.ants
	story["carried"] = true
	Globals.friend_cards["ant_worker"] = true
	if story.get("left", false):
		story["left"] = false
		Globals.heal()
	else:
		Globals.bloom()
	_sync_ants()
	await Lines.say("reem_ant_helped", true)
	E.save_game(1)


func _ask_guard() -> void:
	await Lines.say("reem_ant_guard", true)
	if not Globals.ants.get("aligned", false):
		return
	Globals.ants["crossing"] = true
	Globals.friend_cards["ant_beetle"] = true
	Globals.bloom()
	E.save_game(1)


func _store_seed(id: String) -> void:
	var step: int = Globals.ants.get("stored", 0)
	if id != SEEDS[step]:
		await Lines.say("reem_ant_try", true)
		return
	Globals.ants["stored"] = step + 1
	A.sfx_ui_click.play()
	_sync_ants()
	if step + 1 == SEEDS.size():
		await Lines.say("reem_ant_rain", true)
	E.save_game(1)


func _enter_tunnel() -> void:
	G.block()
	await C.player.walk(Vector2(1650, C.player.position.y))
	G.unblock()
	Globals.ants["safe"] = true
	Globals.friend_cards["ant_queen"] = true
	Globals.bloom()
	_sync_ants()
	await Lines.say("reem_ant_safe", true)
	E.save_game(1)
