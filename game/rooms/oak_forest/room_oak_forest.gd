@tool
extends ReemRoom

const Data := preload("room_oak_forest_state.gd")
var state: Data = load("res://game/rooms/oak_forest/room_oak_forest.tres")

func _on_room_started() -> void:
	if not Globals.oak.get("introduced", false):
		Globals.oak["introduced"] = true
		await Lines.say("reem_oak_arrive")

func _setup_room() -> void:
	_sync_acorns()

func _on_restore_from_savegame() -> void:
	super()
	_sync_acorns()

func _sync_acorns() -> void:
	for index in range(1, 4):
		var acorn := get_node("Props/Acorn%d" % index) as Node2D
		var found: bool = Globals.oak.get("Acorn%d" % index, false)
		if found:
			acorn.position = Vector2(640 + index * 47, 745)
		acorn.visible = not found or not Globals.oak.get("nuts", false) or index < 3

func is_exit_open(exit_name: String) -> bool:
	return exit_name == "ExitLeft" or (Globals.oak.get("nuts", false) and Globals.oak.get("leaves", false))

func has_action(obj: PopochiuClickable) -> bool:
	match obj.script_name:
		"Sinjoob": return not Globals.oak.get("nuts", false)
		"Qunfood": return not Globals.oak.get("leaves", false)
	if obj.script_name.begins_with("Acorn"):
		return Globals.oak.get("search", false) and not Globals.oak.get(obj.script_name, false)
	return super(obj)

func _on_object_clicked(obj: PopochiuClickable) -> void:
	match obj.script_name:
		"ExitLeft":
			await leave_through(obj, "PineFork")
		"ExitRight":
			if is_exit_open("ExitRight"):
				await leave_through(obj, "HoneyOrchard" if R.rooms_states.has("HoneyOrchard") else "End")
		"Sinjoob":
			await _help_sinjoob()
		"Qunfood":
			await _help_qunfood()
		_:
			if obj.script_name.begins_with("Acorn") and has_action(obj):
				Globals.oak[obj.script_name] = true
				_sync_acorns()

func _help_sinjoob() -> void:
	if Globals.oak.get("nuts", false):
		return
	Globals.oak["search"] = true
	if not (Globals.oak.get("Acorn1", false) and Globals.oak.get("Acorn2", false) and Globals.oak.get("Acorn3", false)):
		await Lines.say("reem_oak_search")
		return
	await Lines.say("reem_oak_found")
	if await Choices.ask_two(Globals.notebook.labels["oak_share"], Globals.notebook.labels["oak_keep"]):
		_reward("nuts", "sinjoob", "kept")
		_sync_acorns()
		await Lines.say("reem_oak_share")
	else:
		_mistake("kept")
		await Lines.say("reem_oak_keep")

func _help_qunfood() -> void:
	if Globals.oak.get("leaves", false):
		return
	await Lines.say("reem_oak_meet")
	if await Choices.ask_two(Globals.notebook.labels["oak_greet"], Globals.notebook.labels["oak_avoid"]):
		_reward("leaves", "qunfood", "avoided")
		await Lines.say("reem_oak_greet")
	else:
		_mistake("avoided")
		await Lines.say("reem_oak_avoid")

func _mistake(key: String) -> void:
	if not Globals.oak.get(key, false):
		Globals.oak[key] = true
		Globals.wilt()

func _reward(key: String, friend_id: String, mistake: String) -> void:
	Globals.oak[key] = true
	Globals.friend_cards[friend_id] = true
	if Globals.oak.get(mistake, false):
		Globals.oak[mistake] = false
		Globals.heal()
	else:
		Globals.bloom()
