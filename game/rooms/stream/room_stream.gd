@tool
extends ReemRoom
## Stream: safe repairs, three independent tasks, all rewards idempotent.
const Data := preload("room_stream_state.gd")
var state: Data = load("res://game/rooms/stream/room_stream.tres")
@export var log_rest := Vector2(540, 710)
@export var log_bridge := Vector2(930, 565)
@export var duck_rest := Vector2(760, 745)
@export var duck_crossed := Vector2(1130, 480)

func _setup_room() -> void:
	_sync_art()

func _sync_art() -> void:
	get_prop("Log").position = log_bridge if Globals.stream.get("bridge", false) else log_rest
	get_prop("Log").rotation = -0.65 if Globals.stream.get("bridge", false) else 0.0
	get_prop("Ducks").position = duck_crossed if Globals.stream.get("bridge", false) else duck_rest
	for i in range(1, 4):
		get_node("Duckling%d" % i).position = get_prop("Ducks").position + Vector2(-70 * i, 20)
	get_prop("StreamFox").get_node("BorrowedLantern").visible = Globals.stream.get("lent", false)

func _on_room_started() -> void:
	if not Globals.stream.get("introduced", false):
		Globals.stream["introduced"] = true
		await Lines.say("reem_stream_arrive")

func is_exit_open(exit_name: String) -> bool:
	return exit_name != "ExitRight" or _complete()

func _complete() -> bool:
	return Globals.stream.get("bridge", false) and Globals.stream.get("route", false) \
		and Globals.stream.get("lantern_choice", false) and not Globals.stream.get("lent", false)

func has_action(obj: PopochiuClickable) -> bool:
	match obj.script_name:
		"Log": return not Globals.stream.get("bridge", false)
		"Arnoob": return Globals.stream.get("bridge", false) and not Globals.stream.get("route", false)
		"StreamFox": return Globals.stream.get("route", false) and (not Globals.stream.get("lantern_choice", false) or Globals.stream.get("lent", false))
	return super(obj)

func _on_object_clicked(obj: PopochiuClickable) -> void:
	match obj.script_name:
		"ExitLeft": await leave_through(obj, "Gate")
		"Ducks": await Lines.say("reem_stream_thanks" if Globals.stream.get("bridge", false) else "reem_stream_ducks")
		"Log": await _bridge()
		"Arnoob":
			if Globals.stream.get("bridge", false): await _route()
		"StreamFox":
			if Globals.stream.get("route", false): await _lantern()
		"ExitRight":
			if not Globals.stream.get("bridge", false):
				await Lines.say("reem_stream_ducks")
			elif not Globals.stream.get("route", false):
				await _route()
			elif not Globals.stream.get("lantern_choice", false) or Globals.stream.get("lent", false):
				await _lantern()
			else:
				await leave_through(obj, "PineFork")

func _bridge() -> void:
	if Globals.stream.get("bridge", false): return
	await Lines.say("reem_stream_log")
	G.block()
	var tween := create_tween().set_parallel()
	tween.tween_property(get_prop("Log"), "position", log_bridge, 1.2)
	tween.tween_property(get_prop("Log"), "rotation", -0.65, 1.2)
	await tween.finished
	var crossing := create_tween().set_parallel()
	crossing.tween_property(get_prop("Ducks"), "position", duck_crossed, 1.8)
	for i in range(1, 4):
		crossing.tween_property(get_node("Duckling%d" % i), "position", duck_crossed + Vector2(-70 * i, 20), 1.8)
	await crossing.finished
	Globals.stream["bridge"] = true
	Globals.stream["feather"] = true
	Globals.friend_cards["duck"] = true
	Globals.bloom()
	G.unblock()
	await Lines.say("reem_stream_thanks")

func _route() -> void:
	if Globals.stream.get("route", false): return
	var lost: bool = Globals.stream.get("lost", false)
	await Lines.say("reem_stream_lost" if lost else "reem_stream_rabbit")
	var map: bool = await Choices.ask_two(_label("stream_map"), _label("stream_look" if lost else "stream_follow"))
	if map:
		Globals.stream["route"] = true
		if lost:
			Globals.heal()
			Globals.stream["lost"] = false
		else: Globals.bloom()
		await Lines.say("reem_stream_found" if lost else "reem_stream_map")
	elif not lost:
		Globals.stream["lost"] = true
		Globals.wilt()
		G.block()
		var tween := create_tween()
		tween.tween_property($Background, "modulate", Color(0.75, 0.8, 0.8), 0.4)
		tween.tween_property($Background, "modulate", Color.WHITE, 0.4)
		await tween.finished
		G.unblock()
		await Lines.say("reem_stream_lost")

func _lantern() -> void:
	if Globals.stream.get("lent", false):
		await Lines.say("reem_stream_ask_back")
		await C.player.add_to_inventory(I.Lantern)
		Globals.stream["lent"] = false
		Globals.heal()
		_sync_art()
		await Lines.say("fox_stream_return")
		return
	if Globals.stream.get("lantern_choice", false): return
	await Lines.say("fox_stream_offer")
	var keep: bool = await Choices.ask_two(_label("stream_keep"), _label("stream_lend"))
	Globals.stream["lantern_choice"] = true
	if keep:
		Globals.bloom()
		await Lines.say("reem_stream_keep")
	else:
		await C.player.remove_from_inventory(I.Lantern)
		Globals.stream["lent"] = true
		Globals.wilt()
		_sync_art()
		await Lines.say("fox_stream_borrow")

func _label(key: String) -> String:
	return Globals.notebook.labels[key]

func _on_restore_from_savegame() -> void:
	super()
	_sync_art()
