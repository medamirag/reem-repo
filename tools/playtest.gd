extends Node
## Automatic playtest: plays the whole game by itself, headless, so script errors and broken
## story logic show up without anyone clicking. Not part of the game.
##
## Run (from the project folder), once per path:
##   godot --headless --path . -- --playtest --path=green
##   godot --headless --path . -- --playtest --path=sand
## "green" picks the green button at every choice. "sand" picks sand at every choice and then
## fixes every mistake (watering can, late confession, wiping the stone, giving the stone back).
## Prints lines starting with [PLAYTEST]; any "SCRIPT ERROR" / "ERROR" in the output is a bug.

const SPEED := 8.0
## Real seconds one step may take before the playtest gives up.
const STEP_TIMEOUT := 90.0

var _answers: Array = []
var _path := "green"
var _step_started := 0.0
var _step_name := ""
## Folder for screenshots (--shots=/some/folder). Empty = no screenshots (headless runs).
var _shots_dir := ""
var _shot_count := 0


func _ready() -> void:
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--path="):
			_path = arg.get_slice("=", 1)
		elif arg.begins_with("--shots="):
			_shots_dir = arg.get_slice("=", 1)

	Engine.time_scale = SPEED
	_run.call_deferred()


func _process(_delta: float) -> void:
	_answer_choices()

	if not _step_name.is_empty() and Time.get_ticks_msec() / 1000.0 - _step_started > STEP_TIMEOUT:
		_fail("step '%s' took too long (stuck?) in room %s" % [_step_name, _room_name()])


#region Scenarios ##################################################################################
func _run() -> void:
	_log("start, path = %s" % _path)
	await _wait_room("Title")
	var frames: SpriteFrames = PopochiuUtils.cursor.main_cursor.sprite_frames
	for anim in ["use", "active", "talk", "look", "left", "right"]:
		var tex := frames.get_frame_texture(anim, 0)
		_expect(tex != null and tex.resource_path.contains("assets/cut/cursors"), "cursor '%s' uses the game's picture" % anim)
	await _step("start button", func(): R.current.call("_on_start_pressed"))

	if _path == "green":
		await _green_path()
	elif _path == "mixed":
		await _mixed_path()
	else:
		await _sand_path()

	_log("lines said: %s" % " ".join(Lines.said.keys()))
	_log("DONE %s" % _path)
	get_tree().quit()


func _green_path() -> void:
	await _wait_room("GrandpaRoom")
	await _click("Door")  # must not leave before Choice 1
	await _check_still_in("GrandpaRoom")
	await _click("Mirror")
	_answers = [true]
	await _click("BasketProp")
	_expect(Globals.chose_truth and Globals.mirror_broken and Globals.basket_taken, "Choice 1 green")
	await _click("Door")

	await _wait_room("Yard")
	# The Gate before the briefing: no intro, and the right exit does nothing.
	await _click("ExitRight")
	await _wait_room("Gate")
	_expect(not Globals.gate_intro_done, "no Gate intro before the briefing")
	await _click("ExitRight")
	await _check_still_in("Gate")
	await _click("ExitLeft")
	await _wait_room("Yard")
	_answers = [true]
	await _click("Jad")
	_expect(Globals.briefed and Globals.confessed and _has("HandMirror") and _has("Lantern") \
		and _has("Notebook"), "briefing + confession")
	await _click("Jad")
	await _shot_walking(Vector2(300, 870))
	await _shot_talking("jad_s1_019")
	await _shot_talking("reem_s1_020")
	await _click_item("Notebook")
	await _click("Well")
	_expect(_has("WateringCan"), "well gives the watering can")
	await _click("Well")
	await _click("ExitRight")

	await _wait_room("Gate")
	_expect(Globals.gate_intro_done, "Gate intro after the briefing")
	await _click("ExitRight")

	await _wait_room("MeadowFork")
	await _click("Sign")
	await _click_item("Notebook")
	_answers = [true]
	await _click("ExitRight")

	await _wait_room("BigTree")
	_expect(not Globals.trampled, "green path does not trample")
	await _click("ExitRight")  # must not leave yet (flowers not open)
	await _check_still_in("BigTree")
	await _click("Shahd")
	_expect(Globals.met_shahd, "met Shahd")
	await _click("Hives")
	await _shot_talking("bee_s2_021")
	await _click_item("Notebook")
	await _click("SunSpot")  # one click uses the mirror
	_expect(Globals.flowers_open and _has("HoneyJar"), "mirror opens the flowers")
	await _click("Shahd")
	_answers = [true]  # Thaaloob asks as soon as the room opens
	await _click("ExitRight")

	await _wait_room("FoxRock")
	await _wait_idle()
	if not Globals.fox_done:
		await _click("Thaaloob")
	_expect(Globals.fox_done and _has("HandMirror"), "Choice 3 green")
	await _shot_talking("fox_s2_055a")
	await _click("ExitRight")

	await _wait_room("End")
	_log_heart()
	await _wait_idle()
	await _step("back to title", func(): R.current.call("_on_back_pressed"))
	await _wait_room("Title")
	_expect(not Globals.briefed and Globals.blossoms == 0, "reset after the end screen")


## Choice 1 sand (hide the mirror), then green at Choice 2 and Choice 3: the needs_mirror
## branch without trampled flowers.
func _mixed_path() -> void:
	await _wait_room("GrandpaRoom")
	_answers = [false]
	await _click("BasketProp")
	await _click("Door")
	await _wait_room("Yard")
	await _click("Jad")
	await _click("ExitRight")
	await _wait_room("Gate")
	await _click("ExitRight")
	await _wait_room("MeadowFork")
	_answers = [true]
	await _click("ExitRight")
	await _wait_room("BigTree")
	await _click("Shahd")
	_expect(Globals.met_shahd and not Globals.told_to_fix, "met Shahd straight away")
	await _click("SunSpot")
	_expect(Globals.needs_mirror, "needs the mirror")
	await _click("ExitRight")
	await _check_still_in("BigTree")
	await _click("ExitLeft")
	await _wait_room("MeadowFork")
	await _click("ExitLeft")
	await _wait_room("Gate")
	await _click("ExitLeft")
	await _wait_room("Yard")
	await _click("Jad")
	_expect(Globals.confessed and _has("HandMirror") and Globals.wilts == 0, "late confession")
	await _click("ExitRight")
	await _wait_room("Gate")
	await _click("ExitRight")
	await _wait_room("MeadowFork")
	await _click("ExitRight")
	await _wait_room("BigTree")
	await _use("HandMirror", "SunSpot")
	_expect(Globals.flowers_open, "flowers open")
	_answers = [true]
	await _click("ExitRight")
	await _wait_room("FoxRock")
	await _wait_idle()
	_expect(Globals.fox_done, "Choice 3 green")
	await _click("ExitRight")
	await _wait_room("End")
	_log_heart()
	await _wait_idle()
	await _step("back to title", func(): R.current.call("_on_back_pressed"))
	await _wait_room("Title")


func _sand_path() -> void:
	await _wait_room("GrandpaRoom")
	_answers = [false]
	await _click("BasketProp")
	_expect(Globals.mirror_hidden and Globals.wilts == 1, "Choice 1 sand")
	await _click("Door")

	await _wait_room("Yard")
	await _click("Jad")
	_expect(Globals.briefed and not Globals.confessed and not _has("HandMirror"), "briefing only")
	await _click("Jad")  # replays jad_s1_019 (needs_mirror is false)
	await _click("Well")
	await _click("ExitLeft")
	await _wait_room("GrandpaRoom")
	await _click("Door")
	await _wait_room("Yard")
	await _click("ExitRight")

	await _wait_room("Gate")
	await _click("ExitRight")

	await _wait_room("MeadowFork")
	_answers = [false]
	await _click("ExitRight")

	await _wait_room("BigTree")
	_expect(Globals.trampled and Globals.wilts == 2, "Choice 2 sand")
	await _click("Shahd")
	_expect(Globals.told_to_fix, "Shahd asks to fix the flowers")
	await _click("Shahd")
	await _click("ExitLeft")

	await _wait_room("MeadowFork")
	await _click("FlowersFork")  # one click waters
	_expect(Globals.flowers_fixed and Globals.wilts == 1, "watering fixes the flowers")
	await _click("ExitRight")

	await _wait_room("BigTree")
	await _click("Shahd")
	_expect(Globals.met_shahd, "met Shahd after fixing")
	await _click("FlowersShade")
	_expect(Globals.needs_mirror, "needs the mirror")
	await _click_item("Notebook")
	await _click("ExitLeft")
	await _wait_room("MeadowFork")
	await _click("ExitLeft")
	await _wait_room("Gate")
	await _click("ExitLeft")

	await _wait_room("Yard")
	await _click("Jad")
	_expect(Globals.confessed and not Globals.mirror_hidden and _has("HandMirror") \
		and Globals.wilts == 0, "late confession heals")
	await _click("ExitRight")
	await _wait_room("Gate")
	await _click("ExitRight")
	await _wait_room("MeadowFork")
	await _click("ExitRight")

	await _wait_room("BigTree")
	await _use("HandMirror", "FlowersShade")
	_expect(Globals.flowers_open and _has("HoneyJar"), "mirror opens the flowers")
	_answers = [false]  # Thaaloob asks as soon as the room opens
	await _click("ExitRight")

	await _wait_room("FoxRock")
	await _wait_idle()
	if not Globals.traded:
		await _click("Thaaloob")
	_expect(Globals.traded and _has("Stone") and not _has("HandMirror"), "Choice 3 sand")
	await _click("ExitRight")  # must not leave yet
	await _check_still_in("FoxRock")
	await _click_item("Stone")
	_expect(Globals.stone_wiped and Globals.wilts == 1, "stone wiped")
	await _click("Thaaloob")
	_expect(Globals.mirror_recovered and Globals.fox_done and _has("HandMirror") \
		and not _has("Stone") and Globals.wilts == 0, "mirror recovered")
	await _click("ExitRight")

	await _wait_room("End")
	_log_heart()
	await _wait_idle()
	await _step("back to title", func(): R.current.call("_on_back_pressed"))
	await _wait_room("Title")


#endregion

#region Helpers ####################################################################################
func _step(name: String, action: Callable) -> void:
	_step_name = name
	_step_started = Time.get_ticks_msec() / 1000.0
	await action.call()
	await _wait_idle()
	_step_name = ""


func _click(obj_name: String) -> void:
	var obj := _find(obj_name)
	if obj == null:
		_fail("no object '%s' in room %s" % [obj_name, _room_name()])
		return

	_log("click %s (%s)" % [obj_name, _room_name()])
	var room_before := _room_name()
	var y_before: float = C.player.global_position.y if is_instance_valid(C.player) else 0.0
	await _step("click " + obj_name, func():
		E.clicked = obj
		obj.last_click_button = MOUSE_BUTTON_LEFT
		await obj.on_click()
		E.clicked = null
	)
	# User rule: Reem only moves left and right (the trample shortcut leaves the room).
	if _room_name() == room_before and is_instance_valid(C.player) and C.player.is_inside_tree() \
			and absf(C.player.global_position.y - y_before) > 1.0:
		_log("FAIL: Reem moved up/down when clicking %s (%.0f -> %.0f)" % [
			obj_name, y_before, C.player.global_position.y
		])
	await _shot("after_" + obj_name)


func _use(item_name: String, obj_name: String) -> void:
	var obj := _find(obj_name)
	var item: PopochiuInventoryItem = I.get_item_instance(item_name)
	if obj == null or item == null:
		_fail("cannot use %s on %s in room %s" % [item_name, obj_name, _room_name()])
		return

	_log("use %s on %s (%s)" % [item_name, obj_name, _room_name()])
	await _step("use %s on %s" % [item_name, obj_name], func():
		I.active = item
		E.clicked = obj
		obj.last_click_button = MOUSE_BUTTON_LEFT
		await obj.on_item_used(item)
		E.clicked = null
		I.active = null
	)
	await _shot("after_%s_on_%s" % [item_name, obj_name])


func _click_item(item_name: String) -> void:
	var item: PopochiuInventoryItem = I.get_item_instance(item_name)
	if not _has(item_name):
		_fail("item %s is not in the inventory" % item_name)
		return

	_log("click item %s (%s)" % [item_name, _room_name()])
	await _step("click item " + item_name, func():
		I.clicked = item
		item.last_click_button = MOUSE_BUTTON_LEFT
		await item.on_click()
		I.active = null
	)


func _find(obj_name: String) -> PopochiuClickable:
	var room := R.current
	if not is_instance_valid(room):
		return null
	if room.has_character(obj_name):
		return C.get_character(obj_name)
	var prop := room.get_node_or_null("Props/" + obj_name) as PopochiuClickable
	if prop:
		return prop
	return room.get_node_or_null("Hotspots/" + obj_name) as PopochiuClickable


func _wait_room(room_name: String) -> void:
	_step_name = "wait for room " + room_name
	_step_started = Time.get_ticks_msec() / 1000.0
	while not (
		is_instance_valid(R.current) and R.current.script_name == room_name and E.in_room
		and R.current.is_current
	):
		await get_tree().process_frame
	_log("entered %s" % room_name)
	if is_instance_valid(R.current) and R.current.has_player:
		_expect(C.player.get_node_or_null("WalkRig") != null, "walk rig present in " + room_name)
	await _wait_idle()
	await _shot(room_name)
	_step_name = ""


## Saves what is on screen right now as a PNG (only with --shots=folder and a real display).
func _shot(label: String) -> void:
	if _shots_dir.is_empty() or DisplayServer.get_name() == "headless":
		return
	await RenderingServer.frame_post_draw
	_shot_count += 1
	var path := "%s/%s_%02d_%s.png" % [_shots_dir, _path, _shot_count, label]
	get_viewport().get_texture().get_image().save_png(path)
	_log("screenshot " + path)


## Waits until nothing is happening: the GUI is not blocked, nobody is talking or walking, and
## the room's own start sequence (ReemRoom.started) is over.
func _wait_idle() -> void:
	var quiet_frames := 0
	while quiet_frames < 20:
		await get_tree().process_frame
		# Screens that hide Popochiu's GUI (title, end) leave it blocked on purpose.
		var gui_hidden: bool = is_instance_valid(R.current) and R.current.hide_gui
		var busy := (G.is_blocked and not gui_hidden) or E.playing_queue
		if is_instance_valid(C.player) and C.player.is_inside_tree():
			busy = busy or C.player.is_moving or C.player.is_talking
		if is_instance_valid(R.current) and "started" in R.current and not R.current.started:
			busy = true
		quiet_frames = 0 if busy else quiet_frames + 1


## Screenshot while a line is being spoken (to check the moving mouth), only with --shots.
func _shot_talking(line_id: String) -> void:
	if _shots_dir.is_empty():
		return
	Lines.say(line_id)
	for wait in [0.3, 0.45]:
		await get_tree().create_timer(wait).timeout
		await _shot("talking_" + line_id)
	await _wait_idle()


## Screenshot of Reem in the middle of a walk (to check the walk rig), only with --shots.
func _shot_walking(target: Vector2) -> void:
	if _shots_dir.is_empty():
		return
	C.player.walk(target)
	await get_tree().create_timer(0.5).timeout
	await _shot("walking")
	await _wait_idle()


func _check_still_in(room_name: String) -> void:
	await get_tree().create_timer(1.0).timeout
	_expect(_room_name() == room_name, "stays in %s" % room_name)


func _answer_choices() -> void:
	if not is_instance_valid(G.gui):
		return
	for child in G.gui.get_children():
		if child is ChoicePopup and not child.has_meta("answered") and child.is_node_ready():
			child.set_meta("answered", true)
			var green: bool = true if _answers.is_empty() else _answers.pop_front()
			if not child.sand_button.visible:
				green = true
			_log("choice -> %s" % ("green" if green else "sand"))
			await _shot("choice")
			if green:
				child.call_deferred("_on_green_pressed")
			else:
				child.call_deferred("_on_sand_pressed")


func _log_heart() -> void:
	_log("heart at the end: blossoms=%d wilts=%d picture=%s" % [
		Globals.blossoms, Globals.wilts, Globals.end_heart_picture()
	])
	_log("flags at the end: %s" % _flags())


func _has(item_name: String) -> bool:
	return is_instance_valid(C.player) and C.player.has_inventory_item(item_name)


func _room_name() -> String:
	return R.current.script_name if is_instance_valid(R.current) else "<none>"


func _flags() -> String:
	var out := []
	for flag in [
		"basket_taken", "mirror_broken", "chose_truth", "mirror_hidden", "briefed", "confessed",
		"trampled", "told_to_fix", "flowers_fixed", "met_shahd", "needs_mirror", "flowers_open",
		"fox_done", "traded", "stone_wiped", "mirror_recovered",
	]:
		if Globals.get(flag):
			out.append(flag)
	return " ".join(out)


func _expect(condition: bool, what: String) -> void:
	if condition:
		_log("ok: " + what)
	else:
		_log("FAIL: %s (flags: %s, blossoms=%d wilts=%d)" % [
			what, _flags(), Globals.blossoms, Globals.wilts
		])


func _fail(message: String) -> void:
	_log("FAIL: " + message)
	_log("ABORTED %s" % _path)
	get_tree().quit(1)
	# Stop here: never return to the scenario that called this.
	await get_tree().create_timer(3600.0).timeout


func _log(message: String) -> void:
	print("[PLAYTEST] ", message)


#endregion
