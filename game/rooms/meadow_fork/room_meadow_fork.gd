@tool
extends ReemRoom
## MeadowFork. The shortcut and main road are the two inputs for Choice 2.

const Data := preload("room_meadow_fork_state.gd")
const SIGN_FONT_SIZE := 29
const SIGN_COLOR := Color(0.19, 0.09, 0.025)

@export var road_route := PackedVector2Array([
	Vector2(810, 921), Vector2(1135, 916), Vector2(1450, 866),
	Vector2(1670, 780), Vector2(1780, 696), Vector2(1800, 630),
	Vector2(1750, 576), Vector2(1640, 549), Vector2(1480, 534),
	Vector2(1400, 511), Vector2(1405, 482), Vector2(1530, 449),
	Vector2(1618, 425), Vector2(1601, 407), Vector2(1492, 388),
])

var state: Data = load("res://game/rooms/meadow_fork/room_meadow_fork.tres")


#region Virtual ####################################################################################
func _setup_room() -> void:
	_write_sign()
	$Props/GiantFlower.visible = Globals.unlocked_packs.get("5", false)

	$ShortcutFlowers.show_bent(Globals.trampled and not Globals.flowers_fixed)

	Globals.notebook_hint = func() -> void: await Lines.say("reem_s2_002")


func _on_room_started() -> void:
	if state.visited_times == 1:
		await Lines.say("reem_s2_001")


func _on_object_clicked(obj: PopochiuClickable) -> void:
	match obj.script_name:
		"GiantFlower":
			if obj.visible:
				await Lines.say("reem_ant_offer", true)
				if await Choices.ask_two(Globals.notebook.labels["ant_go"], Globals.notebook.labels["ant_stay"]):
					await leave_through(obj, "GiantBloom")
		"Sign":
			await Lines.say("reem_s2_002")
		"FlowersFork":
			# One click does everything (game_spec.md 1): with the watering can, she waters.
			if _can_water():
				await _water()
			elif not Globals.fork_choice_done:
				await _choose_route(true)
		"ExitLeft":
			await leave_through(obj, "Gate")
		"ExitRight", "MainRoad":
			if Globals.fork_choice_done:
				await _follow_road()
			else:
				await _choose_route(false)


func _on_item_used_on(obj: PopochiuClickable, item: PopochiuInventoryItem) -> void:
	if obj.script_name != "FlowersFork" or item.script_name != "WateringCan":
		return
	if not (Globals.trampled and Globals.told_to_fix and not Globals.flowers_fixed):
		return

	await _water()


func has_action(obj: PopochiuClickable) -> bool:
	if obj.script_name == "GiantFlower":
		return obj.visible
	if obj.script_name == "FlowersFork":
		return not Globals.fork_choice_done or _can_water()
	return super(obj)


#endregion

#region Private ####################################################################################
func _can_water() -> bool:
	return Globals.trampled and Globals.told_to_fix and not Globals.flowers_fixed \
		and C.player.has_inventory_item("WateringCan")


func _water() -> void:
	await C.player.walk_to_clicked()
	A.sfx_water_pour.play()
	ReemEffects.burst(self, C.player.position + Vector2(55, -90), "water")
	await Lines.say("reem_s2_013b")
	$ShortcutFlowers.show_bent(false)
	Globals.flowers_fixed = true
	Globals.heal()


func _write_sign() -> void:
	var label: Label = $Props/Sign/SignText
	label.add_theme_font_override("font", ArabicText.get_font())
	label.add_theme_font_size_override("font_size", SIGN_FONT_SIZE)
	label.add_theme_color_override("font_color", SIGN_COLOR)
	ArabicText.make_rtl(label)
	label.text = Labels.SIGN.replace("، ", "،\n")


func _choose_route(shortcut: bool) -> void:
	G.block()
	await C.player.walk(get_marker_position("ChoiceSpot"))
	G.unblock()
	await Lines.say("reem_s2_003")
	Globals.fork_choice_done = true

	if not shortcut:
		await Lines.say("reem_s2_004a")
		Globals.bloom()
		await _follow_road()
		return

	await Lines.say("reem_s2_004b")
	G.block()
	await scripted_walk(get_marker_position("ShortcutStart"))
	await _walk_into_meadow(get_marker_position("AcrossFlowers"))
	A.sfx_trample.play()
	$ShortcutFlowers.show_bent(true)
	Globals.trampled = true
	Globals.wilt()
	await _walk_into_meadow(get_marker_position("FlowersFarSide"))
	G.unblock()
	R.goto_room("BigTree")


func _follow_road() -> void:
	G.block()
	await C.player.walk(get_marker_position("ChoiceSpot"))
	for point in road_route:
		await _walk_into_meadow(point)
	G.unblock()
	R.goto_room("BigTree")


func _walk_into_meadow(point: Vector2) -> void:
	const SPEED := 455.0
	var sprite := C.player.get_node("Sprite2D") as Sprite2D
	var fraction := clampf(inverse_lerp(388.0, 920.0, point.y), 0.0, 1.0)
	var scale_at_distance := height * reem_height_ratio * lerpf(0.19, 1.0, fraction) / sprite.texture.get_height()
	var duration := C.player.position.distance_to(point) / SPEED
	if duration > 0.01:
		create_tween().tween_property(sprite, "scale", Vector2.ONE * scale_at_distance, duration)
	await scripted_walk(point, SPEED)


#endregion
