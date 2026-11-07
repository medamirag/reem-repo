@tool
extends ReemRoom

const Data := preload("room_rock_cave_state.gd")
const ORDER := [2, 0, 3, 1]
const ANCHORS := [Vector2(790, 425), Vector2(1070, 425), Vector2(1070, 630), Vector2(790, 630)]
const COLORS := [Color("#f6bf5a"), Color("#81cfdf"), Color("#f0a0a6"), Color("#9bd39a")]
var state: Data = load("res://game/rooms/rock_cave/room_rock_cave.tres")

func _on_room_started() -> void:
	if not Globals.cave.get("introduced", false):
		Globals.cave["introduced"] = true
		await Lines.say("reem_cave_arrive")

func _setup_room() -> void:
	_sync_scene()

func _on_restore_from_savegame() -> void:
	super()
	_sync_scene()

func _sync_scene() -> void:
	$Props/Qatqoota.position = Vector2(590, 790) if Globals.cave.get("bell", false) else Vector2(410, 790)
	$Props/CaveBasket.visible = Globals.cave.get("basket_down", false)
	for i in range(4):
		get_node("Hotspots/Anchor%d" % i).visible = Globals.cave.get("weaving", false)
	queue_redraw()

func _draw() -> void:
	if Engine.is_editor_hint():
		return
	if Globals.cave.get("bell", false):
		draw_circle(Vector2(590, 770), 125, Color(1, 0.8, 0.3, 0.25))
	if not Globals.cave.get("weaving", false) and not Globals.cave.get("threads", false):
		_draw_thread(ANCHORS[0], Vector2(875, 485), Color("#d4c3ac"), 5)
		_draw_thread(ANCHORS[2], Vector2(985, 568), Color("#d4c3ac"), 5)
		return
	var count: int = Globals.cave.get("progress", 0)
	for i in range(1, count):
		_draw_thread(ANCHORS[ORDER[i - 1]], ANCHORS[ORDER[i]], Color("#ffefc1"), 8)
	if Globals.cave.get("weaving", false):
		for i in range(4):
			_draw_symbol(ANCHORS[i], i, 28)
			_draw_symbol(Vector2(1059 - i * 88, 337), ORDER[i], 18)

func _draw_thread(start: Vector2, end: Vector2, color: Color, thickness: float) -> void:
	var edge := (end - start).normalized().orthogonal() * thickness * 0.5
	draw_colored_polygon(PackedVector2Array([start + edge, end + edge, end - edge, start - edge]), color)

func _draw_symbol(center: Vector2, symbol: int, radius: float) -> void:
	draw_circle(center, radius + 8, Color("#392e27"))
	if symbol == 0:
		draw_circle(center, radius, COLORS[symbol])
		return
	var points := PackedVector2Array()
	var sides := 3 if symbol == 1 else 4 if symbol == 2 else 5
	for i in range(sides):
		points.append(center + Vector2.UP.rotated(TAU * i / sides) * radius)
	draw_colored_polygon(points, COLORS[symbol])

func is_exit_open(exit_name: String) -> bool:
	return exit_name == "ExitLeft" or Globals.cave.get("fox_done", false)

func has_action(obj: PopochiuClickable) -> bool:
	match obj.script_name:
		"Qatqoota": return not Globals.cave.get("bell", false)
		"Ankoob": return not Globals.cave.get("threads", false)
		"Thaaloob": return Globals.cave.get("bell", false) and Globals.cave.get("threads", false) and not Globals.cave.get("fox_done", false)
		"CaveBasket": return Globals.cave.get("basket_down", false)
	if obj.script_name.begins_with("Anchor"):
		return Globals.cave.get("weaving", false)
	return super(obj)

func _on_object_clicked(obj: PopochiuClickable) -> void:
	if not has_action(obj):
		return
	match obj.script_name:
		"ExitLeft": await leave_through(obj, "PineFork")
		"ExitRight": await leave_through(obj, "HoneyOrchard" if R.rooms_states.has("HoneyOrchard") else "End")
		"Qatqoota": await _help_kitten()
		"Ankoob": await _offer_web()
		"Thaaloob": await _meet_fox()
		"CaveBasket":
			Globals.cave["basket_down"] = false
			Globals.cave["fox_done"] = true
			Globals.heal()
			_sync_scene()
			await Lines.say("reem_cave_repair")
		_:
			if obj.script_name.begins_with("Anchor"):
				await _choose_anchor(int(obj.script_name.trim_prefix("Anchor")))

func _help_kitten() -> void:
	await Lines.say("reem_cave_kitten")
	if await _choice("cave_light", "cave_mock"):
		_reward("bell", "qatqoota", "mocked")
		create_tween().tween_property($Props/Qatqoota, "position", Vector2(590, 790), 0.8)
		queue_redraw()
		await C.player.walk(Vector2(550, 886))
		await Lines.say("reem_cave_light")
	else:
		_mistake("mocked")
		await Lines.say("reem_cave_mock")

func _offer_web() -> void:
	await Lines.say("reem_cave_web", true)
	var try_again: bool = await _choice("cave_try", "cave_give_up")
	Globals.cave["weaving"] = try_again
	Globals.cave["progress"] = 0
	_sync_scene()
	if not try_again:
		_mistake("gave_up")
		await Lines.say("reem_cave_give_up")

func _choose_anchor(index: int) -> void:
	var progress: int = Globals.cave.get("progress", 0)
	progress = progress + 1 if ORDER[progress] == index else 0
	Globals.cave["progress"] = progress
	if progress == ORDER.size():
		Globals.cave["weaving"] = false
		_reward("threads", "ankoob", "gave_up")
		_sync_scene()
		await Lines.say("reem_cave_thread", true)
	else:
		queue_redraw()

func _meet_fox() -> void:
	if Globals.cave.get("basket_down", false):
		await Lines.say("reem_cave_repair")
		return
	await Lines.say("fox_cave_praise")
	if await _choice("cave_keep", "cave_put_down"):
		Globals.cave["fox_done"] = true
		Globals.bloom()
		await Lines.say("reem_cave_keep")
	else:
		Globals.cave["basket_down"] = true
		Globals.wilt()
		var had_honey := C.player.has_inventory_item("HoneyJar")
		if had_honey:
			await C.player.remove_from_inventory(I.HoneyJar)
			Globals.cave["fox_took_honey"] = true
		_sync_scene()
		await Lines.say("reem_cave_stolen" if had_honey else "reem_cave_empty")

func _choice(kind: String, wrong: String) -> bool:
	return await Choices.ask_two(Globals.notebook.labels[kind], Globals.notebook.labels[wrong])

func _mistake(flag: String) -> void:
	if not Globals.cave.get(flag, false):
		Globals.cave[flag] = true
		Globals.wilt()

func _reward(gift: String, card: String, mistake: String) -> void:
	Globals.cave[gift] = true
	Globals.friend_cards[card] = true
	if Globals.cave.get(mistake, false):
		Globals.cave[mistake] = false
		Globals.heal()
	else:
		Globals.bloom()
