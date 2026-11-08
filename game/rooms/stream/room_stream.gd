@tool
extends ReemRoom
## Stream: safe repairs, three independent tasks, all rewards idempotent.
const Data := preload("room_stream_state.gd")
var state: Data = load("res://game/rooms/stream/room_stream.tres")
const OPEN_BANK := preload("res://assets/art/backgrounds/bg7_stream.png")
const KNOCK := "res://game/audio/stream_wood_knock.wav"
const PEEP := "res://game/audio/stream_peep.wav"
const QUACK := "res://game/audio/stream_quack.wav"
const CROSS_TIME := 2.65
const DUCK_GAP := 0.52

@export var bridge_route := PackedVector2Array([
	Vector2(824, 686), Vector2(834, 633), Vector2(969, 577),
	Vector2(1100, 523), Vector2(1230, 476), Vector2(1265, 444),
])
@export var duck_far_bank := Vector2(1348, 440)
@export var ducklings_near := PackedVector2Array([
	Vector2(810, 715), Vector2(746, 737), Vector2(681, 755),
])

var crossing_active := false


func _setup_room() -> void:
	RoomHelpers.fit_background($BridgeBuilt, width, height)
	_sync_art()


func _sync_art() -> void:
	var built: bool = Globals.stream.get("bridge", false)
	$Background.texture = $BridgeBuilt.texture if built else OPEN_BANK
	RoomHelpers.fit_background($Background, width, height)
	get_prop("Log").visible = not built and not Globals.stream.get("planks_carried", false)
	get_prop("Ducks").position = duck_far_bank
	for index in 3:
		var duckling := _duckling(index)
		duckling.position = _gathering_spot(index) if built else ducklings_near[index]
		duckling.scale = Vector2.ONE * (0.72 if built else 1.0)
		duckling.rotation = 0.0
	get_prop("StreamFox").get_node("BorrowedLantern").visible = Globals.stream.get("lent", false)


func _duckling(index: int) -> Node2D:
	return get_node("Duckling%d" % (index + 1)) as Node2D


func _gathering_spot(index: int) -> Vector2:
	return duck_far_bank + Vector2(-43 + index * 46, 14 + (index % 2) * 7)


func _on_room_started() -> void:
	if not Globals.stream.get("introduced", false):
		Globals.stream["introduced"] = true
		_sound(QUACK)
		await Lines.say("reem_stream_arrive")

func is_exit_open(exit_name: String) -> bool:
	return exit_name != "ExitRight" or _complete()

func _complete() -> bool:
	return Globals.stream.get("bridge", false) and Globals.stream.get("route", false) \
		and Globals.stream.get("lantern_choice", false) and not Globals.stream.get("lent", false)

func has_action(obj: PopochiuClickable) -> bool:
	match obj.script_name:
		"Log": return obj.visible
		"BridgeWater": return Globals.stream.get("planks_carried", false) and not Globals.stream.get("bridge", false)
		"Arnoob": return Globals.stream.get("bridge", false) and not Globals.stream.get("route", false)
		"StreamFox": return Globals.stream.get("route", false) and (not Globals.stream.get("lantern_choice", false) or Globals.stream.get("lent", false))
	return super(obj)

func _on_object_clicked(obj: PopochiuClickable) -> void:
	match obj.script_name:
		"ExitLeft": await leave_through(obj, "Gate")
		"Ducks":
			_sound(QUACK)
			await Lines.say("reem_stream_thanks" if Globals.stream.get("bridge", false) else "reem_stream_ducks")
		"Log": await _pick_planks()
		"BridgeWater": await _bridge()
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

func _sound(path: String) -> void:
	$BridgeSounds.stream = load(path)
	$BridgeSounds.play()


func _pick_planks() -> void:
	if not get_prop("Log").visible:
		return
	G.block()
	await C.player.walk(get_prop("Log").to_global(get_prop("Log").walk_to_point))
	await _bend(false)
	Globals.stream["planks_carried"] = true
	get_prop("Log").hide()
	G.unblock()
	await Lines.say("reem_stream_log")
	E.save_game(1)


func _bend(knock: bool) -> void:
	var sprite := C.player.get_node("Sprite2D") as Sprite2D
	var bow := create_tween()
	bow.tween_property(sprite, "rotation", deg_to_rad(12.0), 0.24)
	if knock:
		bow.tween_callback(_sound.bind(KNOCK))
	bow.tween_property(sprite, "rotation", 0.0, 0.27)
	await bow.finished


func _bridge() -> void:
	if not has_action(get_hotspot("BridgeWater")):
		return
	G.block()
	var water := get_hotspot("BridgeWater")
	await C.player.walk(water.to_global(water.walk_to_point))
	await _bend(true)
	var fade := create_tween()
	fade.tween_property($BridgeBuilt, "modulate:a", 1.0, 0.5)
	await fade.finished

	crossing_active = true
	var path := Curve2D.new()
	for point in bridge_route:
		path.add_point(point)
	var crossing := create_tween().set_parallel()
	for index in 3:
		crossing.tween_method(_waddle.bind(index, path), 0.0, 1.0, CROSS_TIME).set_delay(index * DUCK_GAP)
		crossing.tween_callback(_sound.bind(PEEP)).set_delay(index * DUCK_GAP + 0.18)
	await crossing.finished
	crossing_active = false
	await _gather_family()

	Globals.stream["bridge"] = true
	Globals.stream.erase("planks_carried")
	Globals.stream["feather"] = true
	Globals.friend_cards["duck"] = true
	_sync_art()
	$BridgeBuilt.modulate.a = 0.0
	G.unblock()
	await Lines.say("reem_stream_thanks")
	Globals.bloom()
	E.save_game(1)


func _waddle(t: float, index: int, path: Curve2D) -> void:
	var duckling := _duckling(index)
	var phase := t * TAU * 8.0
	var point := path.sample_baked(path.get_baked_length() * clampf((t - 0.13) / 0.73, 0.0, 1.0))
	if t < 0.13:
		point = ducklings_near[index].lerp(bridge_route[0], t / 0.13)
	elif t > 0.86:
		point = bridge_route[-1].lerp(_gathering_spot(index), (t - 0.86) / 0.14)
	var hop := sin(PI * clampf((t - 0.12) / 0.15, 0.0, 1.0))
	hop += sin(PI * clampf((t - 0.81) / 0.15, 0.0, 1.0))
	var step := sin(phase) * sin(PI * t)
	duckling.position = point + Vector2(step * 3.0, -absf(step) * 5.0 - hop * 15.0)
	duckling.scale = Vector2.ONE * lerpf(1.0, 0.72, t)
	duckling.rotation = deg_to_rad(step * 8.0)


func _gather_family() -> void:
	_sound(QUACK)
	var duck := get_prop("Ducks").get_node("Sprite2D") as Sprite2D
	var wing := duck.get_node("Wing") as Polygon2D
	wing.show()
	var flap := create_tween()
	for index in 2:
		flap.tween_property(wing, "rotation", -0.7, 0.15)
		flap.parallel().tween_property(duck, "rotation", -0.08, 0.15)
		flap.tween_property(wing, "rotation", 0.0, 0.16)
		flap.parallel().tween_property(duck, "rotation", 0.0, 0.16)
	await flap.finished
	wing.hide()


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
