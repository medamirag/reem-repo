@tool
extends ReemRoom
const Data := preload("room_pine_fork_state.gd")
var state: Data = load("res://game/rooms/pine_fork/room_pine_fork.tres")
const ROUTES := {"ExitOak": "OakForest", "ExitCave": "RockCave", "ExitLake": "MeadowLake"}

func _setup_room() -> void:
	var previous := C.player.last_room if is_instance_valid(C.player) else ""
	if previous in ["Stream", "FoxRock"]: Globals.pine["origin"] = previous
	for key in ["oak", "cave", "lake"]:
		get_node(key.capitalize() + "Label").text = Globals.notebook.labels["pine_" + key]
	_sync_leaf()

func _sync_leaf() -> void:
	$Props/Sign/Leaf.rotation = 1.2 if Globals.pine.get("promised", false) else 0.0
	$Props/Sign/Leaf.modulate = Color(0.65, 0.5, 0.25) if Globals.pine.get("promised", false) else Color.WHITE

func _on_room_started() -> void:
	if not Globals.pine.get("introduced", false):
		Globals.pine["introduced"] = true
		await Lines.say("reem_pine_arrive")

func _on_object_clicked(obj: PopochiuClickable) -> void:
	if obj.script_name == "ExitLeft":
		await leave_through(obj, Globals.pine.get("origin", "Stream"))
	elif obj.script_name in ["Thaaloob", "Sign"]:
		await _conversation()
	elif ROUTES.has(obj.script_name):
		if not Globals.pine.get("met", false):
			await _conversation()
		else:
			var destination: String = ROUTES[obj.script_name]
			await leave_through(obj, destination if R.rooms_states.has(destination) else "End")

func is_exit_open(exit_name: String) -> bool:
	return exit_name == "ExitLeft" or Globals.pine.get("met", false)

func has_action(obj: PopochiuClickable) -> bool:
	if obj.script_name in ["Thaaloob", "Sign"]:
		return not Globals.pine.get("met", false) or Globals.pine.get("promised", false)
	return super(obj)

func _conversation() -> void:
	if not Globals.pine.get("met", false):
		await Lines.say("fox_pine_offer")
		var kind: bool = await Choices.ask_two(_label("pine_kind"), _label("pine_skip"))
		Globals.pine["met"] = true
		Globals.pine["promised"] = not kind
		if kind: Globals.bloom()
		else: Globals.wilt()
		_sync_leaf()
		await Lines.say("reem_pine_kind" if kind else "reem_pine_skip")
		await Lines.say("fox_pine_cave")
	elif Globals.pine.get("promised", false):
		await Lines.say("reem_pine_repair")
		var repair: bool = await Choices.ask_two(_label("pine_repair"), _label("pine_wait"))
		if repair:
			Globals.pine["promised"] = false
			Globals.heal()
			_sync_leaf()
			await Lines.say("reem_pine_fixed")

func _label(key: String) -> String:
	return Globals.notebook.labels[key]

func _on_restore_from_savegame() -> void:
	super()
	_sync_leaf()
