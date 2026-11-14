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
##
## Real-player mode (a real 1920x1080 window, no --headless):
##   godot --path . -- --playtest --real --path=green
## Every click, item use and choice is a real mouse move + press + release at the thing's place on
## screen, so a hidden, covered or unreachable clickable fails. A screenshot is saved after every
## step and every spoken line in tests/screenshots/<path>/, and each screenshot is checked for
## layout problems (lines starting with "FAIL: lint").

const SPEED := 8.0
## Real-player mode plays slower so dialogue and movement are visible in the screenshots.
const REAL_SPEED := 3.0
## Real seconds one step may take before the playtest gives up.
const STEP_TIMEOUT := 90.0

var _answers: Array = []
var _path := "green"
var _step_started := 0.0
var _step_name := ""
## Folder for screenshots (--shots=/some/folder). Empty = no screenshots (headless runs).
var _shots_dir := ""
var _shot_count := 0
## Real-player mode (--real): real mouse clicks, screenshots and layout checks.
var _real := false
## Layout problems already reported (so each is logged once per room).
var _lint_seen := {}
## How many lines had been spoken at the last check (a new one gets its own screenshot).
var _said_count := 0


func _ready() -> void:
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--path="):
			_path = arg.get_slice("=", 1)
		elif arg.begins_with("--shots="):
			_shots_dir = arg.get_slice("=", 1)
		elif arg == "--real":
			_real = true

	Engine.time_scale = SPEED
	if _real:
		_setup_real_mode()
	_run.call_deferred()


func _process(_delta: float) -> void:
	_answer_choices()
	if _real and Lines.said.size() != _said_count:
		_said_count = Lines.said.size()
		_shot_line(Lines.said.keys()[-1])

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
	if _path == "mirror_ui":
		await _mirror_ui_path()
		_log("DONE mirror_ui")
		get_tree().quit()
		return
	if _path == "reem_animation":
		await _reem_animation_path()
		_log("DONE reem_animation")
		get_tree().quit()
		return
	if _path == "stream_bridge":
		await _stream_bridge_path()
		_log("DONE stream_bridge")
		get_tree().quit()
		return
	if _path == "meadow_shortcut":
		await _meadow_shortcut_path()
		_log("DONE meadow_shortcut")
		get_tree().quit()
		return
	if _path == "highlight":
		await _highlight_path()
		_log("DONE highlight")
		get_tree().quit()
		return
	if _path == "valley_map":
		await _valley_map_path()
		_log("DONE valley_map")
		get_tree().quit()
		return
	if _path == "hud_layout":
		await _hud_layout_path()
		_log("DONE hud_layout")
		get_tree().quit()
		return
	if _path == "notebook_map_focus":
		await _notebook_map_focus()
		_log("DONE notebook_map_focus")
		get_tree().quit()
		return
	if _path == "notebook_clicks":
		await _notebook_clicks_path()
		_log("DONE notebook_clicks")
		get_tree().quit()
		return
	if _path in ["stream", "stream_sand"]:
		await _stream_path(_path == "stream_sand")
		_log("DONE " + _path)
		get_tree().quit()
		return
	if _path == "stream_words":
		await Globals.new_game()
		R.goto_room("Stream")
		await _wait_room("Stream")
		for sample in [[Vector2(0.25, 0.69), "word_bridge_planks"], [Vector2(0.702, 0.35), "word_duck"], [Vector2(0.423, 0.626), "word_duckling"], [Vector2(0.677, 0.65), "word_rabbit"], [Vector2(0.92, 0.38), "word_reed"], [Vector2(.335,.14), "word_sun"], [Vector2(.10,.06), "word_olive"]]:
			await _hold_at(sample[0], 0.7)
			_expect(Globals.discovered_words.has(sample[1]), "Stream real hold discovers " + sample[1])
		_expect(not Globals.stream.get("bridge", false), "word holds do not solve bridge")
		_log("DONE stream_words")
		get_tree().quit()
		return
	if _path in ["pine", "pine_sand"]:
		await _pine_path(_path == "pine_sand")
		_log("DONE " + _path)
		get_tree().quit()
		return
	if _path in ["oak", "oak_sand"]:
		await _oak_path(_path == "oak_sand")
		_log("DONE " + _path)
		get_tree().quit()
		return
	if _path in ["cave", "cave_sand", "cave_empty"]:
		await _cave_path(_path != "cave", _path == "cave_sand")
		_log("DONE " + _path)
		get_tree().quit()
		return
	if _path in ["lake", "lake_sand"]:
		await Globals.new_game()
		Globals.pine["met"] = true
		R.goto_room("PineFork")
		await _wait_room("PineFork")
		await _click("ExitLake")
		await _complete_lake(_path == "lake_sand", true)
		await _wait_room("End")
		_log("DONE " + _path)
		get_tree().quit()
		return
	if _path in ["orchard", "orchard_sand"]:
		await Globals.new_game()
		Globals.oak["nuts"] = true
		Globals.oak["leaves"] = true
		R.goto_room("OakForest")
		await _wait_room("OakForest")
		await _click("ExitRight")
		await _complete_orchard(_path == "orchard_sand", "OakForest")
		await _wait_room("End")
		_log("DONE " + _path)
		get_tree().quit()
		return
	if _path in ["hill", "hill_sand"]:
		await Globals.new_game()
		Globals.orchard["carrier"] = true
		Globals.orchard["verified"] = true
		R.goto_room("HoneyOrchard")
		await _wait_room("HoneyOrchard")
		await _click("ExitRight")
		await _complete_hill(_path == "hill_sand", true)
		await _wait_room("End")
		_log("DONE " + _path)
		get_tree().quit()
		return
	if _path in ["waterfall", "waterfall_sand"]:
		await _waterfall_path(_path == "waterfall_sand")
		_log("DONE " + _path)
		get_tree().quit()
		return
	if _path in ["narrow_pass", "narrow_pass_sand"]:
		var repair := _path == "narrow_pass_sand"
		await Globals.new_game()
		var origin := "WaterfallPath" if repair else "HillSlope"
		if repair:
			Globals.waterfall["lantern_hanger"] = true
			Globals.cave["fox_took_honey"] = true
		else:
			Globals.hill["feathers"] = true
		R.goto_room(origin)
		await _wait_room(origin)
		await _click("ExitRight")
		await _complete_pass(repair)
		await _wait_room("End")
		_log("DONE " + _path)
		get_tree().quit()
		return
	if _path == "festival":
		await Globals.new_game()
		Globals.friend_cards["qarqoor"] = true
		Globals.waterfall["lantern_hanger"] = true
		Globals.narrow_pass["fox_joins"] = true
		Globals.orchard["carrier"] = true
		Globals.wilt()
		Globals.heal()
		Globals.wilt()
		R.goto_room("HilltopFestival")
		await _wait_room("HilltopFestival")
		_expect(R.current.guests.has("qarqoor") and R.current.guests.has("thaaloob") and not R.current.guests.has("dafdoof"), "festival shows helped friends only")
		await _complete_festival()
		await _wait_room("End")
		_expect(Globals.end_heart_picture() == "heart_wilt" and Lines.said.has("jad_festival_repair") and Lines.said.has("jad_festival_wilt"), "ending reflects repairs and pending wilts")
		await _step("return from ending", func(): R.current.call("_on_back_pressed"))
		await _wait_room("Title")
		await _step("continue festival", func(): R.current.call("_on_continue_pressed"))
		await _wait_room("HilltopFestival")
		_expect(Globals.festival.get("completed") and Globals.unlocked_packs.size() == 6, "completed festival and unlocks survive continue")
		_log("DONE festival")
		get_tree().quit()
		return
	if _path == "gull":
		await _gull_path()
		_log("DONE gull")
		get_tree().quit()
		return
	if _path == "ramadan":
		await _ramadan_path()
		_log("DONE ramadan")
		get_tree().quit()
		return
	if _path == "market":
		await _market_path()
		_log("DONE market")
		get_tree().quit()
		return
	if _path == "snow":
		await _snow_path()
		_log("DONE snow")
		get_tree().quit()
		return
	if _path == "mother_day":
		await _mother_day_path()
		_log("DONE mother_day")
		get_tree().quit()
		return
	if _path == "tree_day":
		await _tree_day_path()
		_log("DONE tree_day")
		get_tree().quit()
		return
	if _path == "parent":
		await _parent_path()
		_log("DONE parent")
		get_tree().quit()
		return
	if _path == "stars":
		await _star_path()
		_log("DONE stars")
		get_tree().quit()
		return
	if _path == "ants":
		await _ant_path()
		_log("DONE ants")
		get_tree().quit()
		return
	if _path == "station_shots":
		await Globals.new_game()
		R.goto_room("Stream")
		await _wait_room("Stream")
		await C.player.add_to_inventory(I.Notebook)
		await C.player.add_to_inventory(I.Lantern)
		await _click("Log")
		await _click("BridgeWater")
		await _shot("bridge_crossed")
		await _hold_at(Vector2(.335,.14), .7)
		await _shot("sun_word")
		R.goto_room("PineFork")
		await _wait_room("PineFork")
		if "--static-shots" in OS.get_cmdline_user_args():
			_log("DONE station_shots")
			get_tree().quit()
			return
		_answers = [false]
		await _click("Thaaloob")
		await _shot("promise_leaf")
		Globals.notebook.open_notebook()
		await _shot("pine_hint")
		Globals.notebook.close_notebook()
		_answers = [true]
		await _click("Sign")
		await _shot("promise_healed")
		_log("DONE station_shots")
		get_tree().quit()
		return
	if _path == "dialogue_timing":
		await Globals.new_game()
		R.goto_room("PineFork")
		await _wait_room("PineFork")
		Lines.say("fox_stream_return")
		await get_tree().create_timer(0.8).timeout
		_expect(Lines.busy and C.Thaaloob.is_talking, "silent text remains readable")
		C.Thaaloob.stop_talking()
		await get_tree().process_frame
		await get_tree().process_frame
		_expect(not Lines.busy, "manual skip completes silent line")
		Lines.say("fox_pine_offer")
		await get_tree().create_timer(2.0).timeout
		_expect(Lines.busy and C.Thaaloob.is_talking, "old skip timer cannot close next line")
		await _step("wait for next silent line", func():
			while Lines.busy:
				await get_tree().process_frame
		)
		_expect(not Lines.busy, "next silent line completes")
		_log("DONE dialogue_timing")
		get_tree().quit()
		return
	if _path == "notebook":
		await _notebook_path()
		_log("DONE notebook")
		get_tree().quit()
		return
	if _path == "settings":
		await _settings_path()
		_log("DONE settings")
		get_tree().quit()
		return
	await _step("start button", func(): R.current.call("_on_start_pressed"))

	if _path == "green":
		await _green_path()
	elif _path == "mixed":
		await _mixed_path()
	elif _path == "save":
		await _save_path()
	elif _path == "words":
		await _words_path()
	else:
		await _sand_path()

	_log("lines said: %s" % " ".join(Lines.said.keys()))
	_log("DONE %s" % _path)
	get_tree().quit()


func _mother_day_path() -> void:
	await Globals.new_game()
	Globals.festival["completed"] = true
	R.goto_room("Yard")
	await _wait_room("Yard")
	await _click("MotherDayEntry")
	await _wait_room("MotherGarden")
	var wilts := Globals.wilts
	_answers = [false]
	await _click("CraftTable")
	_expect(Globals.wilts == wilts + 1 and not R.current.get_node("FlowerCard").visible, "keeping the flowers leaves the card blank")
	_answers = [true]
	await _click("CraftTable")
	await _click("BlankCard")
	_expect(Globals.wilts == wilts and Globals.friend_cards.has("mother_day") and R.current.get_node("FlowerCard").visible, "decorating the card repairs the wilt and awards the keepsake")
	await _click("ExitLeft")
	await _wait_room("Yard")


func _tree_day_path() -> void:
	await Globals.new_game()
	Globals.festival["completed"] = true
	R.goto_room("Yard")
	await _wait_room("Yard")
	await _click("TreeDayEntry")
	await _wait_room("TreeDay")
	var wilts := Globals.wilts
	_answers = [false]
	await _click("Arnoob")
	_expect(Globals.wilts == wilts + 1 and not R.current.get_node("NewLeaves").visible, "keeping water leaves the seedling drooping")
	_answers = [true]
	await _click("Arnoob")
	await _click("Seedling")
	_expect(Globals.wilts == wilts and Globals.friend_cards.has("tree_day") and R.current.get_node("NewLeaves").visible, "watering repairs the wilt and awards the tree card")
	await _click("ExitLeft")
	await _wait_room("Yard")


func _parent_path() -> void:
	await Globals.new_game()
	Globals.oak["nuts"] = true
	var settings := Globals.settings
	settings.open_settings()
	settings.call("_show_parent_gate")
	var panel: VBoxContainer = settings.get("_parent_rows")
	var answer := panel.get_child(3) as LineEdit
	answer.text = "0"
	answer.text_submitted.emit(answer.text)
	_expect(panel.get_child(3) is LineEdit, "wrong sum keeps Parent Corner gated")
	answer = panel.get_child(3) as LineEdit
	answer.text = str(settings.get("_parent_answer"))
	answer.text_submitted.emit(answer.text)
	var scroll := panel.get_child(1) as ScrollContainer
	_expect(scroll != null and scroll.get_child(0).get_child_count() == 2, "parent sees only a completed lesson and its question")
	settings.close_settings()
	_expect(not panel.visible, "closing Settings clears access to Parent Corner")


func _star_path() -> void:
	await Globals.new_game()
	Globals.unlocked_packs["6"] = true
	R.goto_room("HilltopFestival")
	await _wait_room("HilltopFestival")
	_answers = [true]
	await _click("ExitMountain")
	await _wait_room("OwlPerch")
	var wilts := Globals.wilts
	_answers = [false]
	await _click("Bat")
	_expect(Globals.wilts == wilts + 1, "rushing past the bat wilts once")
	_answers = [true]
	await _click("Bat")
	_expect(Globals.wilts == wilts and Globals.friend_cards.has("observatory_bat"), "listening repairs the choice and earns the bat card")
	await _click("Owl")
	await _wait_room("ObservatoryDome")
	await _click("Astronomer")
	await _click("CircleStar")
	_expect(Globals.stars.get("chart", 0) == 0, "wrong shape preserves chart progress")
	await _click("DiamondStar")
	Globals.reset()
	R.goto_room("Title")
	await _wait_room("Title")
	await _step("continue star chart", func(): R.current.call("_on_continue_pressed"))
	await _wait_room("ObservatoryDome")
	_expect(Globals.stars.get("chart", 0) == 1, "star chart progress survives Continue")
	for id in ["CircleStar", "TriangleStar", "CrescentStar"]:
		await _click(id)
	await _click("ExitRight")
	await _wait_room("StarRidge")
	await _click("TrailFox")
	await _click("Caravan")
	for id in ["DiamondMarker", "CircleMarker", "TriangleMarker"]:
		await _click(id)
	_expect(Globals.stars.get("safe", false) and Globals.friend_cards.has("observatory_owl"), "the owl card is saved and the caravan reaches shelter")


func _ant_path() -> void:
	await Globals.new_game()
	Globals.unlocked_packs["5"] = true
	R.goto_room("MeadowFork")
	await _wait_room("MeadowFork")
	_answers = [true]
	await _click("GiantFlower")
	await _wait_room("GiantBloom")
	_expect(R.current.reem_height_ratio < 0.3, "giant flower leads to a tiny Reem")
	var previous_wilts := Globals.wilts
	_answers = [false]
	await _click("Worker")
	_expect(Globals.wilts == previous_wilts + 1, "leaving the worker wilts once")
	_answers = [true]
	await _click("Worker")
	await _click("HeavySeed")
	_expect(Globals.friend_cards.has("ant_worker") and Globals.wilts == previous_wilts, "carrying the seed repairs and earns the card")
	await _click("ExitRight")
	await _wait_room("DewBank")
	await _click("TinyFox")
	await _click("Beetle")
	_expect(not R.current.is_exit_open("ExitRight"), "guard waits for aligned leaf")
	await _click("LeafBridge")
	await _click("Beetle")
	_expect(Globals.friend_cards.has("ant_beetle") and R.current.is_exit_open("ExitRight"), "aligned bridge unlocks colony")
	await _click("ExitRight")
	await _wait_room("AntCity")
	await _click("Queen")
	await _click("SeedLarge")
	_expect(Globals.ants.get("stored", 0) == 0, "wrong seed leaves the order unchanged")
	await _click("SeedSmall")
	Globals.reset()
	R.goto_room("Title")
	await _wait_room("Title")
	await _step("continue ant colony", func(): R.current.call("_on_continue_pressed"))
	await _wait_room("AntCity")
	_expect(Globals.ants.get("stored", 0) == 1 and Globals.ants.get("crossing"), "seed order and bridge survive continue")
	await _click("SeedMiddle")
	await _click("SeedLarge")
	_expect(R.current.get_node("Rain").visible, "rain appears after seeds are stored")
	await _click("Tunnel")
	_expect(Globals.ants.get("safe") and Globals.friend_cards.has("ant_queen") and not R.current.get_node("Rain").visible, "tunnel shelters Reem and earns queen card")
	await _click("ExitLeft")
	await _wait_room("DewBank")


func _snow_path() -> void:
	await Globals.new_game()
	Globals.unlocked_packs["4"] = true
	R.goto_room("HillSlope")
	await _wait_room("HillSlope")
	_answers = [true]
	await _click("ExitSnow")
	await _wait_room("SnowEdge")
	var previous_wilts := Globals.wilts
	_answers = [false]
	await _click("Goldfinch")
	_expect(Globals.wilts == previous_wilts + 1, "keeping the bundle wilts")
	_answers = [true]
	await _click("Goldfinch")
	await _click("BirdShelter")
	_expect(Globals.snow.get("warm") and Globals.wilts == previous_wilts and Globals.friend_cards.has("goldfinch"), "warming the bird repairs and earns a card")
	await _click("ExitRight")
	await _wait_room("SnowTracks")
	await _click("Arnoob")
	await _click("SnowFox")
	await _click("RabbitPrint")
	_expect(not Globals.snow.get("track", 0), "rabbit prints leave deer progress unchanged")
	await _click("Hoof1")
	Globals.reset()
	R.goto_room("Title")
	await _wait_room("Title")
	await _step("continue snow tracks", func(): R.current.call("_on_continue_pressed"))
	await _wait_room("SnowTracks")
	_expect(Globals.snow.get("track") == 1, "hoofprint progress survives continue")
	await _click("Hoof3")
	_expect(Globals.snow.get("track") == 1, "out-of-order hoofprint leaves progress unchanged")
	await _click("Hoof2")
	await _click("Hoof3")
	await _click("ExitRight")
	await _wait_room("SledHill")
	await _click("Sled")
	_expect(Globals.snow.get("slid") and C.player.position.x > 1000.0, "sled ride reaches the bottom safely")
	await _click("SnowDeer")
	_expect(Globals.snow.get("rescued") and Globals.friend_cards.has("snow_deer"), "deer reaches shelter and card is earned")
	await _click("ExitLeft")
	await _wait_room("SnowTracks")


func _market_path() -> void:
	await Globals.new_game()
	Globals.unlocked_packs["2"] = true
	R.goto_room("Gate")
	await _wait_room("Gate")
	_answers = [true]
	await _click("ExitMarket")
	await _wait_room("MarketGate")
	await _click("HoneyStall")
	_expect(Globals.market.get("coins") == 5, "honey sale offers five coins even without inventory honey")
	await _click("ExitRight")
	await _wait_room("MarketStalls")
	await _click("Baker")
	await _click("Coin1")
	await _click("Pay")
	_expect(Globals.market.get("coins") == 5 and Globals.market.get("picked").is_empty(), "wrong amount returns all coins")
	for coin in ["Coin2", "Coin3", "Coin4"]:
		await _click(coin)
	await _click("Pay")
	_expect(Globals.market.get("bread") and Globals.market.get("coins") == 2, "bread costs exactly three coins")
	var previous_wilts := Globals.wilts
	_answers = [false]
	await _click("MarketCat")
	_expect(Globals.wilts == previous_wilts + 1, "keeping bread wilts once")
	_answers = [true]
	await _click("MarketCat")
	_expect(Globals.friend_cards.has("market_cat") and Globals.wilts == previous_wilts, "sharing repairs and earns cat card")
	await _click("ExitRight")
	await _wait_room("ScaleCourtyard")
	_answers = [false]
	await _click("MarketFox")
	_expect(Globals.wilts == previous_wilts + 1, "accepting the unfair deal wilts")
	Globals.reset()
	R.goto_room("Title")
	await _wait_room("Title")
	await _step("continue market", func(): R.current.call("_on_continue_pressed"))
	await _wait_room("ScaleCourtyard")
	_expect(Globals.market.get("trusted") and Globals.market.get("coins") == 2, "market payment and mistake survive continue")
	_answers = [true]
	await _click("MarketFox")
	await _click("LeftWeight")
	await _click("Lever")
	_expect(not Globals.market.get("tested", false), "one weight cannot prove the scale")
	await _click("RightWeight")
	await _click("Lever")
	_expect(Globals.market.get("tested") and R.current.get_node("ScaleBeam").rotation > 0.0, "equal weights show the unfair tilt")
	await _click("Witness")
	await _click("LeftWeight")
	await _click("RightWeight")
	await _click("Lever")
	_expect(Globals.market.get("fair") and Globals.wilts == previous_wilts, "second experiment proves the repair and heals")
	await _click("ExitLeft")
	await _wait_room("MarketStalls")


func _ramadan_path() -> void:
	await Globals.new_game()
	Globals.unlocked_packs["3"] = true
	R.goto_room("Yard")
	await _wait_room("Yard")
	_answers = [true]
	await _click("RamadanEntry")
	await _wait_room("RamadanLane")
	_expect(not R.current.get_prop("BasketA").visible, "lantern starts dark")
	await _click("LanternToggle")
	_expect(R.current.get_prop("BasketA").visible, "lantern reveals hidden supplies")
	for supply in ["BasketA", "BasketB", "WaterJug"]:
		await _click(supply)
	_expect(Globals.ramadan.get("supplies"), "all supplies unlock the courtyard")
	await _click("ExitRight")
	await _wait_room("HedgehogCourt")
	var previous_wilts := Globals.wilts
	_answers = [false]
	await _click("Hedgehogs")
	_expect(Globals.wilts == previous_wilts + 1, "keeping the dates wilts")
	Globals.reset()
	R.goto_room("Title")
	await _wait_room("Title")
	await _step("continue Ramadan", func(): R.current.call("_on_continue_pressed"))
	await _wait_room("HedgehogCourt")
	_expect(Globals.ramadan.get("kept") and Globals.ramadan.get("lit"), "dates choice and lantern survive continue")
	_answers = [true]
	await _click("Hedgehogs")
	for date in ["DateA", "DateB", "DateC"]:
		await _click(date)
	_expect(Globals.wilts == previous_wilts and Globals.friend_cards.has("hedgehog_family"), "sharing repairs and earns a card")
	await _click("ExitRight")
	await _wait_room("IftarShelter")
	_expect(not R.current.get_prop("Traveller").visible, "traveller joins when meal is ready")
	await _click("FoodTable")
	_expect(Globals.ramadan.get("meal") and Globals.ramadan.get("shared_last") and R.current.get_prop("Traveller").visible, "shared iftar is ready")
	await _click("ExitLeft")
	await _wait_room("HedgehogCourt")


func _gull_path() -> void:
	await Globals.new_game()
	Globals.unlocked_packs["1"] = true
	Globals.lake["reserve"] = true
	R.goto_room("MeadowLake")
	await _wait_room("MeadowLake")
	_answers = [true]
	await _click("WoodenBoat")
	await _wait_room("GullShore")
	var previous_wilts := Globals.wilts
	_expect(not R.current.is_exit_open("ExitRight"), "high tide blocks the cave route")
	_answers = [false]
	await _click("Turtle")
	_expect(Globals.wilts == previous_wilts + 1, "leaving litter wilts")
	_answers = [true]
	await _click("Turtle")
	for item in ["Paper", "Bottle", "Tin"]:
		await _click(item)
	_expect(Globals.friend_cards.has("gull_turtle") and Globals.wilts == previous_wilts, "clean beach earns card and repairs wilt")
	await _click("TideRock")
	_expect(R.current.is_exit_open("ExitRight"), "low tide opens the dry cave trail")
	Globals.reset()
	R.goto_room("Title")
	await _wait_room("Title")
	await _step("continue from shore", func(): R.current.call("_on_continue_pressed"))
	await _wait_room("GullShore")
	_expect(Globals.gull.get("clean") and Globals.gull.get("low"), "shore cleanup and tide survive continue")
	await _click("ExitRight")
	await _wait_room("TideCave")
	await _click("Octopus")
	await _click("Triangle")
	_expect(Globals.gull.get("step") == 0, "wrong shape restarts without penalty")
	for shape in ["Diamond", "Circle", "Triangle"]:
		await _click(shape)
	_expect(Globals.gull.get("lens") and Globals.friend_cards.has("gull_octopus"), "matching pattern earns lens")
	await _click("ExitRight")
	await _wait_room("GullLighthouse")
	_expect(Globals.gull.get("storm"), "storm delays return boat")
	_answers = [false]
	await _click("Gull")
	_answers = [true]
	await _click("Gull")
	await _click("IslandFox")
	await _click("Lamp")
	_expect(Globals.gull.get("lit") and not Globals.gull.get("storm") and Globals.friend_cards.has("gull_bird"), "lighthouse restores return route")
	_expect(Globals.wilts == previous_wilts, "sharing shells repairs wilt")
	await _click("ExitLeft")
	await _wait_room("TideCave")
	await _click("ExitLeft")
	await _wait_room("GullShore")
	await _click("ReturnBoat")
	await _wait_room("MeadowLake")


func _waterfall_path(wrong: bool) -> void:
	await Globals.new_game()
	Globals.orchard["carrier"] = true
	Globals.orchard["verified"] = true
	R.goto_room("HoneyOrchard")
	await _wait_room("HoneyOrchard")
	await _click("ExitWaterfall")
	await _complete_waterfall(wrong)
	await _wait_room("End")


func _complete_waterfall(wrong: bool) -> void:
	await _wait_room("WaterfallPath")
	var previous_wilts := Globals.wilts
	_expect(not R.current.is_exit_open("ExitRight"), "waterfall exit waits for Qarqoor")
	_answers = [not wrong]
	await _click("Qarqoor")
	if wrong:
		_expect(Globals.waterfall.get("threw") and Globals.wilts == previous_wilts + 1, "throwing the fruit wilts once")
		Globals.reset()
		R.goto_room("Title")
		await _wait_room("Title")
		await _step("restore waterfall choice", func(): R.current.call("_on_continue_pressed"))
		await _wait_room("WaterfallPath")
		_expect(Globals.waterfall.get("threw"), "waterfall mistake survives save")
		_answers = [true]
		await _click("Qarqoor")
	await _hold_at(Vector2(840.0 / 1920, 869.0 / 1080), 0.7)
	_expect(Globals.discovered_words.has("word_fruit") and not Globals.waterfall.get("lantern_hanger", false), "fruit hold teaches without playing")
	await _click("Fruit")
	_expect(Globals.waterfall.get("lantern_hanger") and Globals.friend_cards.has("qarqoor") and Globals.wilts == previous_wilts, "playing earns lantern help and repairs earlier choice")
	var previous_blossoms := Globals.blossoms
	await _click("Fruit")
	_expect(Globals.blossoms == previous_blossoms, "lantern reward cannot repeat")
	await _click("ExitRight")
	await _complete_pass(false)


func _complete_pass(wrong: bool) -> void:
	await _wait_room("NarrowPass")
	var origin: String = C.player.last_room
	var previous_wilts := Globals.wilts
	_expect(Globals.narrow_pass.get("origin") == origin, "pass remembers incoming branch")
	_expect(not R.current.is_exit_open("ExitRight"), "pass waits until Thaaloob is free")
	_answers = [not wrong]
	await _click("Thaaloob")
	if wrong:
		_expect(Globals.wilts == previous_wilts + 1, "leaving Thaaloob wilts once")
		Globals.reset()
		R.goto_room("Title")
		await _wait_room("Title")
		await _step("restore pass choice", func(): R.current.call("_on_continue_pressed"))
		await _wait_room("NarrowPass")
		_expect(Globals.narrow_pass.get("left_fox") and Globals.narrow_pass.get("origin") == origin, "pass mistake and return branch survive save")
		_answers = [true]
		await _click("Thaaloob")
	var had_taken_honey: bool = Globals.cave.get("fox_took_honey", false)
	await _click("LooseStone")
	_expect(Globals.narrow_pass.get("fox_joins") and Globals.wilts == previous_wilts, "Thaaloob joins and earlier wilt heals")
	if had_taken_honey:
		_expect(_has("HoneyJar") and not Globals.cave.get("fox_took_honey", false), "Thaaloob returns the stolen honey")
	var previous_blossoms := Globals.blossoms
	await _click("LooseStone")
	_expect(Globals.blossoms == previous_blossoms, "rescue reward cannot repeat")
	await _click("ExitRight")
	await _complete_festival()


func _complete_festival() -> void:
	await _wait_room("HilltopFestival")
	_expect(not R.current.is_exit_open("ExitRight"), "ending waits for big lantern")
	await _click("BigLantern")
	_expect(Globals.festival.get("completed") and Globals.unlocked_packs.size() == 6, "lighting the lantern completes festival and unlocks packs")
	await _click("ExitRight")


func _complete_hill(wrong: bool, check_details := false) -> void:
	await _wait_room("HillSlope")
	var previous_wilts := Globals.wilts
	_expect(not R.current.is_exit_open("ExitRight"), "hill exit waits for feathers")
	_answers = [not wrong]
	await _click("Tawoos")
	if wrong:
		_expect(Globals.hill.get("flattered") and Globals.wilts == previous_wilts + 1, "flattery wilts and display stays empty")
		E.save_game(1)
		Globals.reset()
		R.goto_room("Title")
		await _wait_room("Title")
		await _step("restore hill choice", func(): R.current.call("_on_continue_pressed"))
		await _wait_room("HillSlope")
		_expect(Globals.hill.get("flattered"), "flattery survives save")
		_answers = [true]
		await _click("Tawoos")
	if check_details:
		await _hold_at(Vector2(970.0 / 1920, 650.0 / 1080), 0.7)
		_expect(Globals.discovered_words.has("word_frame") and not Globals.hill.get("feathers", false), "display hold teaches without completing")
	await _click("Display")
	_expect(Globals.hill.get("feathers") and Globals.friend_cards.has("tawoos") and Globals.wilts == previous_wilts, "feathers and Tawoos card earned")
	var before := Globals.blossoms
	await _click("Display")
	_expect(Globals.blossoms == before, "display reward cannot repeat")
	await _click("ExitRight")
	await _complete_pass(false)


func _complete_orchard(wrong: bool, origin: String) -> void:
	await _wait_room("HoneyOrchard")
	_expect(Globals.orchard.get("origin") == origin, "orchard remembers arrival branch")
	var previous_wilts := Globals.wilts
	_expect(not R.current.is_exit_open("ExitRight"), "orchard exit waits for rescue and evidence")
	_answers = [not wrong]
	await _click("Dubb")
	_answers = [not wrong]
	await _click("Thaaloob")
	if wrong:
		_expect(Globals.wilts == previous_wilts + 2, "pulling and accusation each wilt")
		E.save_game(1)
		Globals.reset()
		R.goto_room("Title")
		await _wait_room("Title")
		await _step("restore orchard mistakes", func(): R.current.call("_on_continue_pressed"))
		await _wait_room("HoneyOrchard")
		_expect(Globals.orchard.get("pulled") and Globals.orchard.get("accused"), "both orchard mistakes survive save")
		_answers = [true]
		await _click("Dubb")
	await _click("DubbJar")
	await _click("LostLanterns")
	await _click("Dubb")
	_expect(Globals.wilts == previous_wilts and Globals.orchard.get("carrier") and Globals.orchard.get("verified"), "Dubb freed and evidence reported")
	_expect(Globals.friend_cards.has("dubb") and R.current.is_exit_open("ExitWaterfall"), "Dubb card and both routes unlocked")
	await _click("ExitWaterfall" if wrong else "ExitRight")
	if wrong:
		await _complete_waterfall(false)
	else:
		await _complete_hill(false)


func _complete_lake(wrong: bool, check_details := false) -> void:
	await _wait_room("MeadowLake")
	var prior_wilts := Globals.wilts
	_expect(not R.current.is_exit_open("ExitRight"), "lake exit waits for both friends")
	if not _has("HoneyJar"):
		await _click("Dafdoof")
		await _click("WoodenBoat")
		_expect(Globals.lake.get("reserve"), "boat supplies a spoonful without a jar")
	_answers = [not wrong]
	await _click("Dafdoof")
	if wrong:
		_expect(Globals.lake.get("kept") and Globals.wilts == prior_wilts + 1, "withholding honey wilts once")
		E.save_game(1)
		Globals.reset()
		R.goto_room("Title")
		await _wait_room("Title")
		await _step("restore lake choice", func(): R.current.call("_on_continue_pressed"))
		await _wait_room("MeadowLake")
		_expect(Globals.lake.get("kept"), "lake mistake survives save")
		_answers = [true]
		await _click("Dafdoof")
	_expect(Globals.lake.get("flute") and Globals.wilts == prior_wilts, "frog shares the flute and branch is healthy")
	await _click("Ghazlana")
	if check_details:
		await _hold_at(Vector2(730.0 / 1920, 846.0 / 1080), 0.7)
		_expect(Globals.discovered_words.has("word_hoofprint") and Globals.lake.get("tracks", 0) == 0, "hoofprint hold teaches without advancing")
		await _click("Print3")
		_expect(Globals.lake.get("tracks", 0) == 0, "out-of-order hoofprint keeps current clue")
	for id in [1, 2, 3]:
		await _click("Print%d" % id)
	_expect(Globals.lake.get("reunited") and Globals.friend_cards.has("dafdoof") and Globals.friend_cards.has("ghazlana"), "gazelle reunited and both cards earned")
	await _click("ExitRight")
	await _complete_orchard(false, "MeadowLake")


func _cave_path(wrong: bool, has_honey: bool) -> void:
	await Globals.new_game()
	Globals.pine["met"] = true
	R.goto_room("PineFork")
	await _wait_room("PineFork")
	await _click("ExitCave")
	await _wait_room("RockCave")
	var visual := R.current.get_node("Props/Ankoob/Visual")
	var legs: Array = visual.get("_legs")
	_expect(legs.size() == 8, "Ankoob has exactly eight legs")
	var mirrored := 0
	for leg: Sprite2D in legs:
		if leg.flip_h:
			mirrored += 1
	_expect(mirrored == 4, "Ankoob has four mirrored legs")
	_expect(not R.current.is_exit_open("ExitRight"), "Cave exit waits for both puzzles and fox")
	if wrong:
		if has_honey:
			await C.player.add_to_inventory(I.HoneyJar)
		_answers = [false]
		await _click("Qatqoota")
		_answers = [false]
		await _click("Ankoob")
		_expect(Globals.wilts == 2, "Cave mistakes wilt once")
	_answers = [true]
	await _click("Qatqoota")
	_answers = [true]
	await _click("Ankoob")
	await _click("Anchor2")
	await _click("Anchor1")
	_expect(Globals.cave.get("progress") == 0, "wrong anchor resets the attempt")
	for id in [2, 0, 3, 1]:
		await _click("Anchor%d" % id)
	_expect(Globals.cave.get("bell") and Globals.cave.get("threads") and Globals.wilts == 0, "Cave gifts earned")
	_answers = [not wrong]
	await _click("Thaaloob")
	if wrong:
		_expect(Globals.cave.get("fox_took_honey", false) == has_honey and not _has("HoneyJar"), "fox takes the jar only if present")
		E.save_game(1)
		Globals.reset()
		R.goto_room("Title")
		await _wait_room("Title")
		await _step("restore Cave basket", func(): R.current.call("_on_continue_pressed"))
		await _wait_room("RockCave")
		_expect(Globals.cave.get("basket_down") and Globals.cave.get("fox_took_honey", false) == has_honey and not _has("HoneyJar"), "honey custody survives save")
		await _click("CaveBasket")
	_expect(Globals.wilts == 0 and Globals.friend_cards.has("qatqoota") and Globals.friend_cards.has("ankoob"), "Cave branches healthy and both cards earned")
	await _click("ExitRight")
	await _complete_orchard(false, "RockCave")
	await _wait_room("End")


func _oak_path(wrong: bool) -> void:
	await Globals.new_game()
	Globals.pine["met"] = true
	R.goto_room("PineFork")
	await _wait_room("PineFork")
	await _click("ExitOak")
	await _wait_room("OakForest")
	_expect(not R.current.is_exit_open("ExitRight"), "Oak exit waits for both friends")
	await _click("Sinjoob")
	await _hold_at(Vector2(325.0 / 1920, 720.0 / 1080), 0.7)
	_expect(Globals.discovered_words.has("word_acorn") and not Globals.oak.get("Acorn1", false), "acorn hold teaches without collecting")
	for name in ["Acorn3", "Acorn1", "Acorn2", "Acorn1"]:
		await _click(name)
	_answers = [not wrong]
	await _click("Sinjoob")
	_answers = [not wrong]
	await _click("Qunfood")
	if wrong:
		_expect(Globals.wilts == 2 and not R.current.is_exit_open("ExitRight"), "Oak mistakes wilt and remain repairable")
		E.save_game(1)
		Globals.reset()
		R.goto_room("Title")
		await _wait_room("Title")
		await _step("restore Oak mistakes", func(): R.current.call("_on_continue_pressed"))
		await _wait_room("OakForest")
		_expect(Globals.oak.get("kept") and Globals.oak.get("avoided") and Globals.wilts == 2, "Oak choices survive save")
		_answers = [false]
		await _click("Sinjoob")
		_expect(Globals.wilts == 2, "repeating a mistake adds no wilt")
		_answers = [true]
		await _click("Sinjoob")
		_answers = [true]
		await _click("Qunfood")
	_expect(Globals.wilts == 0 and Globals.oak.get("nuts") and Globals.oak.get("leaves"), "Oak gifts and healthy branches")
	_expect(Globals.friend_cards.has("sinjoob") and Globals.friend_cards.has("qunfood"), "both Oak cards earned")
	var blossoms := Globals.blossoms
	await _click("Sinjoob")
	await _click("Qunfood")
	_expect(Globals.blossoms == blossoms, "Oak rewards cannot repeat")
	await _click("ExitRight")
	await _complete_orchard(false, "OakForest")
	await _wait_room("End")


func _pine_path(wrong: bool) -> void:
	await Globals.new_game()
	Globals.pine["origin"] = "Stream"
	R.goto_room("PineFork")
	await _wait_room("PineFork")
	_expect(Globals.notebook.hint_context() == "pine_meet", "Pine meeting hint")
	_expect(not R.current.is_exit_open("ExitCave"), "Pine routes wait for conversation")
	_answers = [not wrong]
	await _click("Thaaloob")
	_expect(Globals.pine.get("met") and R.current.is_exit_open("ExitCave"), "cave allowed after either choice")
	if wrong:
		_expect(Globals.wilts == 1 and Globals.pine.get("promised"), "promise wilts")
		_expect(R.current.get_node("Props/Sign/Leaf").rotation > 1.0, "sign leaf droops")
		E.save_game(1)
		Globals.reset()
		R.goto_room("Title")
		await _wait_room("Title")
		await _step("restore Pine promise", func(): R.current.call("_on_continue_pressed"))
		await _wait_room("PineFork")
		_expect(Globals.pine.get("promised") and Globals.wilts == 1, "Pine promise survives save")
		_answers = [false]
		await _click("Sign")
		_expect(Globals.wilts == 1, "thinking adds no penalty")
		_answers = [true]
		await _click("Sign")
		_expect(Globals.wilts == 0 and not Globals.pine.get("promised"), "Pine promise repaired")
	var before := Globals.blossoms
	await _click("Thaaloob")
	await _click("Sign")
	_expect(Globals.blossoms == before and Globals.wilts == 0, "Pine reward cannot repeat")
	for sample in [[Vector2(.21,.30),"word_pine"],[Vector2(.29,.28),"word_cone"],[Vector2(.55,.40),"word_cave"],[Vector2(.91,.45),"word_lake"]]:
		await _hold_at(sample[0], .7)
		_expect(Globals.discovered_words.has(sample[1]), "Pine real hold discovers " + sample[1])
	await _click("ExitLake")
	await _complete_lake(false)
	await _wait_room("End")


## Remove this provisional finish as adjacent valley stations are built.
func _finish_pine() -> void:
	await _wait_room("PineFork")
	_answers = [true]
	await _click("Thaaloob")
	await _click("ExitLake")
	await _complete_lake(false)


func _stream_bridge_path() -> void:
	await Globals.new_game()
	R.goto_room("Stream")
	await _wait_room("Stream")
	_expect(not Globals.stream.get("bridge", false), "bridge starts unbuilt")
	await _shot("stream_bridge_before")
	await _click("Log")
	_expect(Globals.stream.get("planks_carried", false), "click picks up planks")
	if _real:
		_capture_stream_crossing()
	await _click("BridgeWater")
	_expect(Globals.stream.get("bridge", false) and Globals.stream.get("feather", false), "ducklings cross and award the feather")
	_expect(Globals.blossoms == 1 and Globals.friend_cards.has("duck"), "crossing awards one blossom and the duck card")
	await _shot("stream_bridge_after")


func _capture_stream_crossing() -> void:
	while _room_name() == "Stream" and not R.current.crossing_active:
		await get_tree().process_frame
	if _room_name() != "Stream":
		return
	await get_tree().create_timer(1.62).timeout
	await _shot("stream_bridge_crossing")


func _stream_path(wrong: bool) -> void:
	await _step("new Stream journey", func(): R.current.call("_on_start_pressed"))
	await _wait_room("GrandpaRoom")
	_answers = [true]
	await _click("BasketProp")
	await _click("Door")
	await _wait_room("Yard")
	_answers = [true]
	await _click("Jad")
	await _click("ExitRight")
	await _wait_room("Gate")
	await _click("ExitStream")
	await _wait_room("Stream")
	_expect(not R.current.is_exit_open("ExitRight"), "Stream exit locked before tasks")
	_expect(Globals.notebook.hint_context() == "stream_bridge", "bridge hints")
	await _click("Ducks")
	var before := Globals.blossoms
	await _click("Log")
	await _click("BridgeWater")
	_expect(Globals.stream.get("bridge") and Globals.stream.get("feather") and Globals.friend_cards.has("duck"), "ducks crossed, card and feather earned")
	await _click("BridgeWater")
	_expect(Globals.blossoms == before + 1, "bridge reward cannot repeat")
	_expect(Globals.notebook.hint_context() == "stream_map", "route hints")
	_answers = [not wrong]
	await _click("Arnoob")
	if wrong:
		_expect(Globals.stream.get("lost") and Globals.wilts == 1, "rushing wilts once")
		_answers = [false]
		await _click("Arnoob")
		_expect(Globals.wilts == 1, "looking around adds no penalty")
		_answers = [true]
		await _click("Arnoob")
		_expect(Globals.wilts == 0, "map repairs wrong turn")
	_expect(Globals.stream.get("route"), "route resolved")
	_answers = [not wrong]
	await _click("StreamFox")
	if wrong:
		_expect(Globals.wilts == 1 and not _has("Lantern"), "lending has visible inventory consequence")
		_expect(not R.current.is_exit_open("ExitRight"), "cannot leave lantern behind")
		_expect(Globals.notebook.hint_context() == "stream_lantern", "lantern repair hint")
		# Save in the unresolved state, then reload: custody and repair must survive.
		E.save_game(1)
		await _click("ExitLeft")
		await _wait_room("Gate")
		R.goto_room("Title")
		await _wait_room("Title")
		await _step("continue Stream save", func(): R.current.call("_on_continue_pressed"))
		await _wait_room("Gate")
		await _click("ExitStream")
		await _wait_room("Stream")
		_expect(Globals.stream.get("lent") and not _has("Lantern"), "saved lantern custody")
		await _click("StreamFox")
		_expect(Globals.wilts == 0 and _has("Lantern"), "lantern returned and branch healed")
	before = Globals.blossoms
	await _click("StreamFox")
	_expect(Globals.blossoms == before, "fox reward cannot repeat")
	_expect(R.current.is_exit_open("ExitRight"), "Stream exit unlocked")
	var targets: Array = Globals.word_discovery.get_room_targets()
	_expect(targets.any(func(t): return t.word == "word_duck"), "duck word target present")
	_expect(targets.any(func(t): return t.word == "word_rabbit"), "rabbit word target present")
	await _click("ExitRight")
	await _finish_pine()
	await _wait_room("End")
	await Globals.new_game()
	_expect(Globals.stream.is_empty() and not Globals.friend_cards.has("duck"), "New journey resets Stream and card")


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

	await _finish_pine()
	await _wait_room("End")
	_log_heart()
	await _wait_idle()
	await _step("back to title", func(): R.current.call("_on_back_pressed"))
	await _wait_room("Title")
	_expect(Globals.festival.get("completed"), "returning to title keeps the festival save")
	await _step("replay from title", func(): R.current.call("_on_start_pressed"))
	await _wait_room("GrandpaRoom")
	_expect(not Globals.briefed and Globals.blossoms == 0, "new journey resets the story")


## Word discovery with real mouse events: holds show words, a short click still works, no words
## during dialogue, F2 shows the areas.
func _words_path() -> void:
	await _wait_room("GrandpaRoom")
	await _hold_at(Vector2(0.15, 0.30), 0.7)
	_expect(Globals.discovered_words.has("word_window"), "hold on the window shows its word")
	_expect(_bubble_text() == "نَافِذَة", "bubble shows نَافِذَة (got '%s')" % _bubble_text())
	await _shot("word_window")
	# Hold on Reem wherever she stands (her middle, about a third of her height above her feet).
	var reem_middle: Vector2 = C.player.position - Vector2(0, R.current.height * 0.14)
	await _hold_at(reem_middle / Vector2(R.current.width, R.current.height), 0.7)
	_expect(Globals.discovered_words.has("word_girl"), "hold on Reem shows بنت")
	await _hold_at(Vector2(0.45, 0.62), 0.2)
	_expect(not Globals.discovered_words.has("word_jug"), "a short press on the jug is not a hold")
	await _hold_at(Vector2(0.416, 0.45), 0.7)
	_expect(Globals.discovered_words.has("word_basket") and not Globals.basket_taken,
		"holding the basket names it and does not take it")
	_expect(Globals.discovered_words.size() == 3, "3 words discovered")

	# Short click on the basket: the normal click must still happen.
	_answers = [true]
	await _hold_at(Vector2(0.416, 0.45), 0.1)
	var waited := 0.0
	while not Globals.basket_taken and waited < 20.0:
		await get_tree().create_timer(0.25).timeout
		waited += 0.25
	_expect(Globals.basket_taken, "a short click on the basket still picks it up")
	await _wait_idle()

	# No words while someone is talking.
	Lines.say("reem_s1_007a")
	await get_tree().create_timer(0.1).timeout
	await _hold_at(Vector2(0.47, 0.75), 0.7)
	_expect(not Globals.discovered_words.has("word_table"), "no word during dialogue")
	await _wait_idle()
	await _hold_at(Vector2(0.47, 0.75), 0.7)
	_expect(Globals.discovered_words.has("word_table"), "word after the dialogue")

	_send_key(KEY_F2)
	await get_tree().process_frame
	_expect(Globals.word_discovery._debug, "F2 shows the areas")
	await _shot("word_debug")
	_send_key(KEY_F2)
	await get_tree().process_frame
	_expect(not Globals.word_discovery._debug, "F2 again hides them")

	await _click("Door")
	await _wait_room("Yard")
	await _hold_at(Vector2(0.79, 0.55), 0.7)
	_expect(Globals.discovered_words.has("word_grandfather"), "hold on Grandpa shows جدّ")
	await _hold_at(Vector2(0.355, 0.50), 0.7)
	_expect(Globals.discovered_words.has("word_bucket"), "the bucket wins over the well")
	await _shot("word_bucket")
	_log("discovered: %s" % " ".join(Globals.discovered_words.keys()))


## Moves the mouse to `fraction` of the screen, presses, waits `seconds`, releases (real events).
func _hold_at(fraction: Vector2, seconds: float) -> void:
	# Room pixels -> viewport (through the camera) -> window pixels.
	var room_pos := fraction * Vector2(R.current.width, R.current.height)
	var window_pos := get_viewport().get_screen_transform() * (get_viewport().get_canvas_transform() * room_pos)
	var motion := InputEventMouseMotion.new()
	motion.position = window_pos
	motion.global_position = window_pos
	Input.parse_input_event(motion)
	await get_tree().physics_frame
	await get_tree().physics_frame
	var press := InputEventMouseButton.new()
	press.button_index = MOUSE_BUTTON_LEFT
	press.pressed = true
	press.position = window_pos
	press.global_position = window_pos
	Input.parse_input_event(press)
	# Real time, not game time: holds are measured in real milliseconds.
	var until := Time.get_ticks_msec() + int(seconds * 1000.0)
	while Time.get_ticks_msec() < until:
		await get_tree().process_frame
	var release := press.duplicate() as InputEventMouseButton
	release.pressed = false
	Input.parse_input_event(release)
	await get_tree().process_frame
	await get_tree().process_frame


func _send_key(keycode: Key) -> void:
	for pressed in [true, false]:
		var key := InputEventKey.new()
		key.keycode = keycode
		key.pressed = pressed
		Input.parse_input_event(key)


func _bubble_text() -> String:
	for node in Globals.word_discovery.get_children():
		if node is PanelContainer and node.get_child_count() > 0:
			return (node.get_child(0) as Label).text
	return ""


## Choice 1 sand (hide the mirror), then green at Choice 2 and Choice 3: the needs_mirror
## branch without trampled flowers.
func _meadow_shortcut_path() -> void:
	await Globals.new_game()
	R.goto_room("MeadowFork")
	await _wait_room("MeadowFork")
	await _shot("meadow_before_choice")
	await _click("FlowersFork")
	await _wait_room("BigTree")
	_expect(Globals.trampled and Globals.wilts == 1, "the shortcut tramples flowers and wilts once")
	R.goto_room("MeadowFork")
	await _wait_room("MeadowFork")
	_expect(R.current.get_node("ShortcutFlowers").bent, "trampled flowers stay bent on return")
	await _shot("meadow_bent_flowers")
	Globals.fork_choice_done = false
	Globals.trampled = false
	Globals.wilts = 0
	R.current.call("_setup_room")
	await _click("MainRoad")
	await _wait_room("BigTree")
	_expect(not Globals.trampled and Globals.blossoms == 1, "the road keeps flowers upright and earns a blossom")


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
	await _finish_pine()
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
	await _click("FlowersFork")

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

	await _finish_pine()
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
		if _real and await _real_click_object(obj):
			return
		E.clicked = obj
		obj.last_click_button = MOUSE_BUTTON_LEFT
		await obj.on_click()
		E.clicked = null
	)
	# Watering the shortcut approaches the flowers along the curved meadow road.
	var meadow_watering := room_before == "MeadowFork" and obj_name == "FlowersFork" and Globals.flowers_fixed
	if not meadow_watering and _room_name() == room_before and is_instance_valid(C.player) and C.player.is_inside_tree() \
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
		if _real and await _real_click_item(item) and I.active == item and await _real_click_object(obj):
			I.active = null
			return
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
		if not (_real and await _real_click_item(item)):
			I.clicked = item
			item.last_click_button = MOUSE_BUTTON_LEFT
			await item.on_click()
		await _shot("item_" + item_name)
		if Globals.notebook.is_open:
			_expect(true, "Notebook inventory click opens its pages")
			if _real:
				# Close it the way a player does: the × button.
				var close: Control = Globals.notebook.close_button
				await _real_move(_to_window(close, close.size / 2.0))
				await _real_press_at(_to_window(close, close.size / 2.0))
				await get_tree().create_timer(0.3).timeout
				_expect(not Globals.notebook.is_open, "the notebook's × button closes it")
				if "--trace" in OS.get_cmdline_user_args():
					_log("trace after notebook: words(pressing=%s passthrough=%s)" % [
						Globals.word_discovery._pressing, Globals.word_discovery._passthrough
					])
			Globals.notebook.close_notebook()
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
	if _path == "stream_bridge" and not label.begins_with("stream_bridge_"):
		return
	if _shots_dir.is_empty() or DisplayServer.get_name() == "headless":
		return
	await RenderingServer.frame_post_draw
	_shot_count += 1
	var path := "%s/%s_%02d_%s.png" % [_shots_dir, _path, _shot_count, label]
	if _real:
		path = "%s/%03d_%s_%s.png" % [_shots_dir, _shot_count, _room_name(), label.validate_filename()]
	get_viewport().get_texture().get_image().save_png(path)
	_log("screenshot " + path)
	if _real:
		_lint(path.get_file())


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
		# A real click returns before the game reacts. Popochiu keeps E.clicked set until the
		# whole reaction has ended; an open choice counts as busy too.
		if _real and (E.clicked != null or Lines.busy):
			busy = true
		if is_instance_valid(G.gui):
			for child in G.gui.get_children():
				if child is ChoicePopup and child.visible:
					busy = true
		quiet_frames = 0 if busy else quiet_frames + 1


## Screenshot while a line is being spoken (to check the moving mouth), only with --shots.
func _shot_talking(line_id: String) -> void:
	# Real-player mode already photographs every line as it is spoken; replaying one would change
	# what the player sees (a click during a line only skips it).
	if _shots_dir.is_empty() or _real:
		return
	Lines.say(line_id)
	for wait in [0.3, 0.45]:
		await get_tree().create_timer(wait).timeout
		await _shot("talking_" + line_id)
	await _wait_idle()


## Screenshot of Reem in the middle of a walk (to check the walk rig), only with --shots.
func _shot_walking(target: Vector2) -> void:
	if _shots_dir.is_empty() or _real:
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
			# The path may answer or close the choice itself while the screenshot is taken.
			if not is_instance_valid(child) or not child.is_inside_tree():
				continue
			if _real:
				_real_press_choice(child, child.green_button if green else child.sand_button)
				continue
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

#region Real-player mode (--real) ##################################################################
const SCREEN_SIZE := Vector2i(1920, 1080)
## How far (game pixels) Reem's feet may be outside the walkable area before it counts as floating.
const GROUND_TOLERANCE := 12.0
## A prop or character taller or wider than this share of the screen is reported as oversized.
const OVERSIZED_SHARE := Vector2(0.6, 0.75)


func _setup_real_mode() -> void:
	if DisplayServer.get_name() == "headless":
		_log("FAIL: --real needs a window: run without --headless")
		_real = false
		return
	Engine.time_scale = REAL_SPEED
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	DisplayServer.window_set_size(SCREEN_SIZE)
	DisplayServer.window_set_position(Vector2i.ZERO)
	_shots_dir = ProjectSettings.globalize_path("res://tests/screenshots/" + _path)
	DirAccess.make_dir_recursive_absolute(_shots_dir)
	for file in DirAccess.get_files_at(_shots_dir):
		if file.ends_with(".png"):
			DirAccess.remove_absolute(_shots_dir.path_join(file))
	await get_tree().process_frame
	var size := DisplayServer.window_get_size()
	_log("real mode: window %dx%d, screenshots in %s" % [size.x, size.y, _shots_dir])
	if size != SCREEN_SIZE:
		_log("WARN: the screen is smaller than 1920x1080, so the window is %dx%d" % [size.x, size.y])


## A point of a node (in its own local coordinates) as window pixels, the way a mouse sees it.
func _to_window(node: CanvasItem, local := Vector2.ZERO) -> Vector2:
	return get_viewport().get_screen_transform() * (node.get_global_transform_with_canvas() * local)


## The interaction polygon of a clickable in viewport pixels (empty if it has none).
func _viewport_polygon(obj: PopochiuClickable) -> PackedVector2Array:
	var out := PackedVector2Array()
	var poly_node := obj.get_node_or_null("InteractionPolygon") as CollisionPolygon2D
	if poly_node == null:
		return out
	var xform := poly_node.get_global_transform_with_canvas()
	for p in poly_node.polygon:
		out.append(xform * p)
	return out


## Where a player would click a clickable, in window pixels: on its exit arrow if it has one,
## otherwise at the middle of its interaction polygon (moved inside it for odd shapes).
func _click_point(obj: PopochiuClickable) -> Vector2:
	var arrow := obj.get_node_or_null("ExitArrow") as ExitArrow
	if arrow and arrow.is_visible_in_tree():
		return _to_window(arrow)
	var poly := _viewport_polygon(obj)
	if poly.is_empty():
		return _to_window(obj)
	var middle := Vector2.ZERO
	for p in poly:
		middle += p
	middle /= poly.size()
	if not Geometry2D.is_point_in_polygon(middle, poly):
		var bounds := Rect2(poly[0], Vector2.ZERO)
		for p in poly:
			bounds = bounds.expand(p)
		var best := middle
		var best_distance := INF
		for i in 13:
			for j in 13:
				var candidate := bounds.position + bounds.size * Vector2((i + 1) / 14.0, (j + 1) / 14.0)
				if Geometry2D.is_point_in_polygon(candidate, poly) and candidate.distance_to(middle) < best_distance:
					best = candidate
					best_distance = candidate.distance_to(middle)
		middle = best
	return get_viewport().get_screen_transform() * middle


func _real_move(window_pos: Vector2) -> void:
	var motion := InputEventMouseMotion.new()
	motion.position = window_pos
	motion.global_position = window_pos
	Input.warp_mouse(window_pos)
	Input.parse_input_event(motion)
	for i in 3:
		await get_tree().physics_frame
	await get_tree().process_frame


func _real_press_at(window_pos: Vector2) -> void:
	var press := InputEventMouseButton.new()
	press.button_index = MOUSE_BUTTON_LEFT
	press.pressed = true
	press.position = window_pos
	press.global_position = window_pos
	Input.parse_input_event(press)
	await get_tree().process_frame
	var release := press.duplicate() as InputEventMouseButton
	release.pressed = false
	Input.parse_input_event(release)
	await get_tree().process_frame


## Moves the mouse onto `obj` and clicks it like a player. Returns false (after logging a FAIL)
## when the player could not click it: hidden, disabled, covered by the GUI or by another object.
func _real_click_object(obj: PopochiuClickable) -> bool:
	var what := "%s (%s)" % [obj.script_name, _room_name()]
	if not obj.is_visible_in_tree() or not obj.clickable:
		_expect(false, "real click: %s is hidden or not clickable" % what)
		return false
	var at := _click_point(obj)
	var screen := Rect2(Vector2.ZERO, Vector2(DisplayServer.window_get_size()))
	if not screen.has_point(at):
		_expect(false, "real click: %s is off screen at %s" % [what, at.round()])
		return false
	_check_reachable(obj)
	await _real_move(at)
	var control := get_viewport().gui_get_hovered_control()
	if control != null:
		_expect(false, "real click: %s is covered by the GUI (%s) at %s" % [what, control.name, at.round()])
		return false
	if E.hovered != obj:
		var other: String = E.hovered.script_name if is_instance_valid(E.hovered) else "nothing"
		_expect(false, "real click: %s is under %s at %s" % [what, other, at.round()])
		return false
	await _real_press_at(at)
	# The click starts the room's reaction (walking, talking); wait until it has begun or ended.
	await get_tree().create_timer(0.2).timeout
	if "--trace" in OS.get_cmdline_user_args():
		for i in 8:
			_log("trace %s: clicked=%s hovered=%s moving=%s blocked=%s words(pressing=%s passthrough=%s) paused=%s" % [
				obj.script_name,
				E.clicked.script_name if is_instance_valid(E.clicked) else "null",
				E.hovered.script_name if is_instance_valid(E.hovered) else "null",
				C.player.is_moving if is_instance_valid(C.player) else false, G.is_blocked,
				Globals.word_discovery._pressing, Globals.word_discovery._passthrough, get_tree().paused,
			])
			await get_tree().create_timer(0.15, true, false, true).timeout
	return true


## Reports a clickable whose walk-to point is off the walkable ground (Reem cannot get there).
func _check_reachable(obj: PopochiuClickable) -> void:
	if not (is_instance_valid(R.current) and R.current.has_player) or obj.walk_to_point == Vector2.ZERO:
		return
	if obj is PopochiuCharacter and obj == C.player:
		return
	var target := obj.get_global_transform_with_canvas() * obj.walk_to_point
	if _ground_distance(target) > GROUND_TOLERANCE * 4.0:
		_lint_once("offroad:" + obj.script_name, "%s: walk-to point %s is off the walkable path" % [
			obj.script_name, target.round()
		])


## Clicks an inventory item in the bar like a player (the bar slides in when the mouse reaches it).
## Moves the mouse to the top of the screen, as a player does, until the inventory bar has slid
## down and `item` is fully on screen and still. Returns false if it never shows.
func _reveal_item(item: PopochiuInventoryItem) -> bool:
	var screen := Rect2(Vector2.ZERO, Vector2(DisplayServer.window_get_size()))
	var last := Vector2(-9999, -9999)
	var still := 0
	var until := Time.get_ticks_msec() + 3000
	while Time.get_ticks_msec() < until:
		var top := _to_window(item, item.size / 2.0)
		await _real_move(Vector2(clampf(top.x, 10.0, screen.size.x - 10.0), 12.0))
		var rect := Rect2(_to_window(item), _to_window(item, item.size) - _to_window(item))
		still = still + 1 if rect.position.distance_to(last) < 0.5 else 0
		last = rect.position
		if item.is_visible_in_tree() and screen.encloses(rect) and still >= 3:
			return true
	return false


func _real_click_item(item: PopochiuInventoryItem) -> bool:
	var what := "item %s (%s)" % [item.script_name, _room_name()]
	if not await _reveal_item(item):
		_expect(false, "real click: %s never came into view in the inventory bar" % what)
		return false
	var until := Time.get_ticks_msec() + 3000
	while Time.get_ticks_msec() < until:
		var at := _to_window(item, item.size / 2.0)
		await _real_move(at)
		var control := get_viewport().gui_get_hovered_control()
		if item.is_visible_in_tree() and (control == item or (control != null and item.is_ancestor_of(control))):
			await _real_press_at(at)
			await get_tree().create_timer(0.2).timeout
			if "--trace" in OS.get_cmdline_user_args():
				for i in 6:
					_log("trace item %s: active=%s clicked=%s notebook_open=%s words(pressing=%s passthrough=%s) paused=%s hovered_control=%s" % [
						item.script_name,
						I.active.script_name if is_instance_valid(I.active) else "null",
						I.clicked.script_name if is_instance_valid(I.clicked) else "null",
						Globals.notebook.is_open, Globals.word_discovery._pressing,
						Globals.word_discovery._passthrough, get_tree().paused,
						get_viewport().gui_get_hovered_control().name if get_viewport().gui_get_hovered_control() else "null",
					])
					await get_tree().create_timer(0.15, true, false, true).timeout
			return true
		await get_tree().create_timer(0.1).timeout
	var hovered := get_viewport().gui_get_hovered_control()
	_expect(false, "real click: %s could not be reached in the inventory bar (mouse is over %s)" % [
		what, hovered.name if hovered else "nothing"
	])
	return false


## Clicks a choice button like a player; falls back to pressing it in code (after a FAIL).
func _real_press_choice(popup: ChoicePopup, button: TextureButton) -> void:
	for i in 10:
		await get_tree().process_frame
	if not is_instance_valid(popup):
		return
	var at := _to_window(button, button.size / 2.0)
	await _real_move(at)
	var control := get_viewport().gui_get_hovered_control()
	if control == button or (control != null and button.is_ancestor_of(control)):
		await _real_press_at(at)
		await get_tree().create_timer(0.3).timeout
		if not is_instance_valid(popup) or not popup.is_inside_tree() or not popup.visible:
			return
	_expect(false, "real click: choice button %s could not be clicked (mouse over %s)" % [
		button.name, control.name if control else "nothing"
	])
	if is_instance_valid(popup):
		if button == popup.green_button:
			popup.call_deferred("_on_green_pressed")
		else:
			popup.call_deferred("_on_sand_pressed")


## A screenshot shortly after a line starts, once its text has been laid out.
func _shot_line(line_id: String) -> void:
	# Real time, not game time: give the text time to finish typing out before the screenshot.
	var until := Time.get_ticks_msec() + 600
	while Time.get_ticks_msec() < until:
		await get_tree().process_frame
	await _shot("line_" + line_id)


#region Layout checks
func _lint_once(key: String, message: String) -> void:
	var full := _room_name() + ":" + key
	if _lint_seen.has(full):
		return
	_lint_seen[full] = true
	_log("FAIL: lint %s in %s (screenshot %s)" % [message, _room_name(), _last_shot])


var _last_shot := ""


func _lint(shot: String) -> void:
	_last_shot = shot
	if not is_instance_valid(R.current):
		return
	_lint_ground()
	_lint_oversized()
	_lint_text(G.gui)
	# HUD and cursor checks only make sense when nothing is going on (no line, choice or page).
	var talking := Lines.busy or (is_instance_valid(C.player) and C.player.is_inside_tree() and C.player.is_talking)
	if not talking and not _popup_open():
		_lint_hud_overlap()
		_lint_cursor()


## True while a choice or the notebook pages cover the room.
func _popup_open() -> bool:
	if Globals.notebook and Globals.notebook.is_open:
		return true
	for child in G.gui.get_children():
		if child is ChoicePopup and child.visible:
			return true
	return false


## Every enabled walkable area of the current room as polygons in viewport pixels.
func _walk_polygons() -> Array[PackedVector2Array]:
	var out: Array[PackedVector2Array] = []
	for wa in get_tree().get_nodes_in_group("walkable_areas"):
		if not (wa is PopochiuWalkableArea) or not wa.enabled or not R.current.is_ancestor_of(wa):
			continue
		var xform: Transform2D = (wa as Node2D).get_global_transform_with_canvas()
		for poly: PackedVector2Array in wa.interaction_polygon:
			var points := PackedVector2Array()
			for p in poly:
				points.append(xform * (p + wa.interaction_polygon_position))
			out.append(points)
	return out


## 0 inside the walkable ground, otherwise the distance (viewport pixels) to its nearest edge.
func _ground_distance(point: Vector2) -> float:
	var best := INF
	for poly in _walk_polygons():
		if Geometry2D.is_point_in_polygon(point, poly):
			return 0.0
		for i in poly.size():
			var closest := Geometry2D.get_closest_point_to_segment(point, poly[i], poly[(i + 1) % poly.size()])
			best = minf(best, point.distance_to(closest))
	return best


func _lint_ground() -> void:
	if not R.current.has_player or not is_instance_valid(C.player) or not C.player.is_inside_tree():
		return
	if C.player.is_moving or not C.player.visible or _walk_polygons().is_empty():
		return
	var feet := C.player.get_global_transform_with_canvas().origin
	var off := _ground_distance(feet)
	if off > GROUND_TOLERANCE:
		_lint_once("ground", "Reem is not standing on the ground (feet %s, %.0f px off the walkable path)" % [
			feet.round(), off
		])


func _lint_oversized() -> void:
	var limit := Vector2(get_viewport().get_visible_rect().size) * OVERSIZED_SHARE
	for node in R.current.find_children("*", "Sprite2D", true, false):
		var sprite := node as Sprite2D
		if not sprite.is_visible_in_tree() or sprite.texture == null or sprite.z_index < 0:
			continue
		var lower := String(sprite.name).to_lower()
		if lower.contains("background") or lower.begins_with("fg") or lower.contains("foreground"):
			continue
		var r := sprite.get_rect()
		var xform := sprite.get_global_transform_with_canvas()
		var size := (xform * r.end - xform * r.position).abs()
		if size.x > limit.x or size.y > limit.y:
			_lint_once("big:" + str(sprite.get_path()), "%s looks oversized (%.0fx%.0f on a 1920x1080 screen)" % [
				_owner_name(sprite), size.x, size.y
			])


func _owner_name(node: Node) -> String:
	var n := node
	while n != null and not (n is PopochiuClickable) and n != R.current:
		n = n.get_parent()
	return (n as PopochiuClickable).script_name if n is PopochiuClickable else String(node.name)


## Clickable things the HUD (inventory bar, map, heart tree, buttons) sits on top of.
func _lint_hud_overlap() -> void:
	var screen := get_viewport().get_visible_rect()
	var hud: Array[Control] = []
	for node in G.gui.find_children("*", "Control", true, false):
		var c := node as Control
		if not c.is_visible_in_tree() or c.mouse_filter == Control.MOUSE_FILTER_IGNORE:
			continue
		var r := c.get_global_rect()
		if r.size.x <= 0 or r.size.y <= 0 or r.get_area() > screen.get_area() * 0.25:
			continue
		# Pop-ups (choices, settings, notebook pages) cover the room on purpose while open.
		var in_popup := false
		var up: Node = c
		while up != null and up != G.gui:
			if up is ChoicePopup or String(up.name) in ["Popups", "NotebookPages"]:
				in_popup = true
				break
			up = up.get_parent()
		if not in_popup:
			hud.append(c)
	# The game's own screen buttons live on their own layers, outside Popochiu's GUI.
	for c: Control in [Globals.valley_map.map_button, Globals.notebook.open_button,
			Globals.settings.open_button, Globals.hotspot_highlight.button]:
		if is_instance_valid(c) and c.is_visible_in_tree():
			hud.append(c)
	for node in R.current.find_children("*", "", true, false):
		if not (node is PopochiuClickable):
			continue
		var obj := node as PopochiuClickable
		if not obj.is_visible_in_tree() or not obj.clickable or obj == C.player:
			continue
		var poly := _viewport_polygon(obj)
		if poly.is_empty():
			continue
		var box := Rect2(poly[0], Vector2.ZERO)
		for p in poly:
			box = box.expand(p)
		for c in hud:
			var overlap := box.intersection(c.get_global_rect())
			if overlap.get_area() > box.get_area() * 0.3:
				_lint_once("hud:%s:%s" % [obj.script_name, c.name], "%s is under the HUD (%s covers %.0f%% of it)" % [
					obj.script_name, c.name, overlap.get_area() * 100.0 / box.get_area()
				])


func _lint_text(root: Node) -> void:
	var screen := get_viewport().get_visible_rect().grow(-2)
	for node in root.find_children("*", "Control", true, false):
		var c := node as Control
		if not c.is_visible_in_tree():
			continue
		var text := ""
		if c is Label:
			text = (c as Label).text
		elif c is RichTextLabel:
			text = (c as RichTextLabel).get_parsed_text()
		elif c is Button:
			text = (c as Button).text
		if text.strip_edges().is_empty():
			continue
		var r := c.get_global_rect()
		var short := text.strip_edges().left(24)
		if not screen.encloses(r):
			_lint_once("offscreen:" + short, "text \"%s\" goes off the screen (%s)" % [short, r])
		if c is Label and (c as Label).get_line_count() > (c as Label).get_visible_line_count():
			_lint_once("cut:" + short, "text \"%s\" is cut off (%d of %d lines visible)" % [
				short, (c as Label).get_visible_line_count(), (c as Label).get_line_count()
			])
		if c is RichTextLabel and not (c as RichTextLabel).fit_content \
				and (c as RichTextLabel).get_content_height() > c.size.y + 2:
			_lint_once("cut:" + short, "text \"%s\" is taller than its box (%d > %d px)" % [
				short, (c as RichTextLabel).get_content_height(), c.size.y
			])
		var parent := c.get_parent() as Control
		if parent and (parent is Panel or parent is PanelContainer or parent is NinePatchRect) \
				and not parent.get_global_rect().grow(2).encloses(r):
			_lint_once("box:" + short, "text \"%s\" spills out of its box %s" % [short, parent.name])
		if _has_arabic(text):
			if c.get("text_direction") == Control.TEXT_DIRECTION_LTR:
				_lint_once("ltr:" + short, "Arabic text \"%s\" is set left-to-right" % short)
			var font := c.get_theme_font("normal_font" if c is RichTextLabel else "font")
			var font_name := font.resource_path if font else ""
			if font and not font_name.is_empty() and not font_name.to_lower().contains("cairo"):
				_lint_once("font:" + short, "Arabic text \"%s\" uses %s instead of Cairo" % [short, font_name.get_file()])
			var font_size := c.get_theme_font_size("normal_font_size" if c is RichTextLabel else "font_size")
			if font_size > 0 and font_size < 24:
				_lint_once("small:" + short, "Arabic text \"%s\" is small (%d px)" % [short, font_size])


func _has_arabic(text: String) -> bool:
	for i in text.length():
		var code := text.unicode_at(i)
		if code >= 0x0600 and code <= 0x06FF:
			return true
	return false


func _lint_cursor() -> void:
	var cursor = PopochiuUtils.cursor.main_cursor
	if cursor == null or G.is_blocked or E.playing_queue:
		return
	if (cursor as AnimatedSprite2D).animation == &"wait" and (cursor as AnimatedSprite2D).is_visible_in_tree():
		_lint_once("cursor", "the cursor is stuck on the wait shape while nothing is happening")


#endregion
#endregion


func _save_path() -> void:
	await _wait_room("GrandpaRoom")
	_answers = [true]
	await _click("BasketProp")
	Globals.discovered_words["word_window"] = true
	await _click("Door")
	await _wait_room("Yard")
	_expect(FileAccess.file_exists("user://save_1.json"), "room change autosaved")
	var saved_position: Vector2 = C.player.global_position
	Globals.reset()
	Globals.discovered_words.clear()
	await I.clean_inventory(C.player)
	R.goto_room("Title")
	await _wait_room("Title")
	_expect(R.current.get_node("ContinueButton").visible, "title offers Continue")
	await _step("continue saved journey", func(): R.current.call("_on_continue_pressed"))
	await _wait_room("Yard")
	_expect(Globals.chose_truth and Globals.basket_taken and Globals.mirror_broken, "saved story flags restored")
	_expect(_has("Basket"), "saved inventory restored")
	_expect(Globals.discovered_words.has("word_window"), "discovered words restored")
	_expect(C.player.global_position.is_equal_approx(saved_position), "saved player position restored")
	await _click("ExitLeft")
	await _wait_room("GrandpaRoom")
	_expect(not R.current.get_prop("BasketProp").visible, "taken basket remains hidden")
	R.goto_room("Title")
	await _wait_room("Title")
	await _step("new journey", func(): R.current.call("_on_start_pressed"))
	await _wait_room("GrandpaRoom")
	_expect(not Globals.basket_taken and not _has("Basket"), "new journey resets flags and inventory")
	_expect(R.current.get_prop("BasketProp").visible, "new journey restores basket")


## Tests real settings controls, persisted preferences, and a story hold behind the modal.
func _settings_path() -> void:
	var prefs := Globals.settings
	var original := [prefs.music_enabled, prefs.voice_volume, prefs.effects_volume, prefs.text_size]
	var title_blocked: bool = G.is_blocked
	prefs.open_button.pressed.emit()
	_expect(prefs.is_open and get_tree().paused, "settings opens on Title and pauses story")
	prefs.music_control.button_pressed = true
	prefs.voice_control.value = 25
	prefs.effects_control.value = 75
	prefs.text_control.select(2)
	prefs.text_control.item_selected.emit(2)
	_expect(not AudioServer.is_bus_mute(AudioServer.get_bus_index(ReemSettings.MUSIC_BUS)), "music toggle controls its own bus")
	_expect(is_equal_approx(db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index(ReemSettings.VOICE_BUS))), 0.25), "voice volume applies independently")
	_expect(is_equal_approx(db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index(ReemSettings.EFFECTS_BUS))), 0.75), "effects volume applies independently")
	_expect(ArabicText.get_theme().default_font_size == 56, "larger story text selected")
	var config := ConfigFile.new()
	_expect(config.load(ReemSettings.CONFIG_PATH) == OK and config.get_value("text", "size") == 56, "settings saved immediately")
	prefs.text_size = 40
	prefs.load_preferences()
	_expect(prefs.text_size == 56 and prefs.music_enabled, "preferences reload from disk")
	await _shot("settings")
	prefs.close_button.pressed.emit()
	_expect(not prefs.is_open and not get_tree().paused and G.is_blocked == title_blocked, "closing Settings preserves Title blocking")
	await _step("start with preferences", func(): R.current.call("_on_start_pressed"))
	await _wait_room("GrandpaRoom")
	_expect(prefs.text_size == 56, "new journey keeps preferences")
	_expect(Lines._voice.bus == ReemSettings.VOICE_BUS and Globals.word_discovery._voice.bus == ReemSettings.VOICE_BUS, "dialogue and word voices use voice bus")
	_expect(A.sfx_pickup.bus == ReemSettings.EFFECTS_BUS and A.amb_farm.bus == ReemSettings.EFFECTS_BUS, "effects and ambience use effects bus")
	prefs.open_settings()
	await _hold_at(Vector2(0.416, 0.45), 0.7)
	_expect(not Globals.basket_taken and Globals.discovered_words.is_empty(), "settings consumes holds without changing story")
	_send_key(KEY_ESCAPE)
	await get_tree().process_frame
	_expect(not prefs.is_open and not get_tree().paused and not G.is_blocked, "Escape restores playable room")
	await _hold_at(Vector2(0.15, 0.30), 0.7)
	var bubble_label: Label = Globals.word_discovery._shown_nodes[1].get_child(0)
	_expect(bubble_label.get_theme_font_size("font_size") == 101, "word bubble scales with text preference")
	var popup: ChoicePopup = Choices.ChoicePopupScene.instantiate()
	popup.setup(Labels.CHOICE1_GREEN, Labels.CHOICE1_SAND)
	G.gui.add_child(popup)
	_expect(popup.green_label.get_theme_font_size("normal_font_size") == 56, "choice labels use larger Arabic text")
	popup.queue_free()
	await get_tree().process_frame
	prefs.music_enabled = original[0]
	prefs.voice_volume = original[1]
	prefs.effects_volume = original[2]
	prefs.text_size = original[3]
	prefs._apply()
	prefs.save_preferences()


func _valley_map_path() -> void:
	var map = Globals.valley_map
	map.open_map()
	_expect(not map.is_open and not map.map_button.visible, "map unavailable on title")
	await _step("start map test", func(): R.current.call("_on_start_pressed"))
	await _wait_room("GrandpaRoom")
	await _wait_idle()
	var key := InputEventKey.new()
	key.pressed = true
	key.keycode = KEY_M
	Input.parse_input_event(key)
	await get_tree().process_frame
	_expect(map.is_open and get_tree().paused and map.pin.visible, "M opens map with current pin")
	_expect(Globals.on_save().map_intro_seen, "first map introduction saved")
	map.markers[7].pressed.emit()
	_expect(map.destination.is_empty() and map.name_label.text == map.words.word_map_pine.text, "unvisited place shows name without travel")
	_expect(map.markers[16].icon.resource_path.ends_with("map_lock.svg"), "unavailable pack has a lock")
	key = InputEventKey.new()
	key.pressed = true
	key.keycode = KEY_ESCAPE
	Input.parse_input_event(key)
	await get_tree().process_frame
	_expect(not map.is_open and not get_tree().paused, "Escape closes map")
	_answers = [true]
	await _click("BasketProp")
	await _click("Door")
	await _wait_room("Yard")
	await _wait_idle()
	map.map_button.pressed.emit()
	map.markers[1].pressed.emit()
	_expect(map.choices.visible and map.destination == "GrandpaRoom", "visited place asks before travel")
	map.choices.get_child(1).pressed.emit()
	_expect(map.is_open and map.destination.is_empty(), "No keeps Reem on the map")
	map.markers[1].pressed.emit()
	map.choices.get_child(0).pressed.emit()
	await _wait_room("GrandpaRoom")
	_expect(not map.is_open, "Yes closes map and travels")


## Real-mouse check (run with --real): after opening the notebook from the inventory and closing
## it with ×, the next click on the room and the next notebook click must still work.
## Checks every room scene, without playing it: no clickable thing (hidden ones too, since they
## can appear later) may sit under an always-on screen button (map, notebook, settings, hint).
## Runs in a second, headless too. Characters placed by scripts are not in the scenes, so the
## real-player paths still catch those.
func _hud_layout_path() -> void:
	await _wait_idle()
	var buttons := {}
	buttons["MapButton"] = Rect2(Globals.valley_map.map_button.position, Globals.valley_map.map_button.size)
	buttons["NotebookButton"] = Rect2(Globals.notebook.open_button.position, Globals.notebook.open_button.get_combined_minimum_size().max(Globals.notebook.open_button.size))
	buttons["SettingsButton"] = Rect2(Globals.settings.open_button.position, Globals.settings.open_button.get_combined_minimum_size().max(Globals.settings.open_button.size))
	var highlight := Globals.hotspot_highlight
	if highlight:
		buttons["HighlightButton"] = Rect2(highlight.button.position, highlight.button.get_combined_minimum_size())
	for name: String in buttons:
		_log("%s at %s" % [name, buttons[name]])
	var problems := 0
	for room: String in DirAccess.get_directories_at("res://game/rooms"):
		var path := "res://game/rooms/%s/room_%s.tscn" % [room, room]
		if not ResourceLoader.exists(path):
			continue
		var scene := (load(path) as PackedScene).instantiate()
		for node in scene.find_children("*", "", true, false):
			if not (node is PopochiuClickable):
				continue
			var poly_node := node.get_node_or_null("InteractionPolygon") as CollisionPolygon2D
			if poly_node == null or poly_node.polygon.is_empty():
				continue
			var xform := Transform2D.IDENTITY
			var up: Node = poly_node
			while up != null and up != scene:
				if up is Node2D:
					xform = (up as Node2D).transform * xform
				up = up.get_parent()
			var box := Rect2(xform * poly_node.polygon[0], Vector2.ZERO)
			for p in poly_node.polygon:
				box = box.expand(xform * p)
			for name: String in buttons:
				var overlap := box.intersection(buttons[name])
				# A corner under a button is fine (the edge exits reach the hint button's corner);
				# a fifth of the thing, or its middle, is not.
				if overlap.get_area() > box.get_area() * 0.2 or buttons[name].has_point(box.get_center()):
					problems += 1
					_log("FAIL: %s/%s is under the %s (%.0f%% of it, box %s)" % [
						room, node.name, name, overlap.get_area() * 100.0 / box.get_area(), box
					])
		scene.free()
	_expect(problems == 0, "no clickable thing in any room sits under a screen button")


func _notebook_map_focus() -> void:
	await Globals.new_game()
	R.goto_room("Yard")
	await _wait_room("Yard")
	await C.player.add_to_inventory(I.Notebook)
	await _wait_idle()
	Globals.notebook.open_notebook()
	_expect(Globals.notebook.is_open, "the notebook opens")
	await _shot("notebook_map_tabs")
	var tab: Button = Globals.notebook.page_buttons.map
	if _real:
		await _real_move(_to_window(tab, tab.size / 2.0))
		await _real_press_at(_to_window(tab, tab.size / 2.0))
	else:
		tab.pressed.emit()
	var map := Globals.valley_map
	_expect(map.is_open and not Globals.notebook.is_open and not map.notice.visible, "the shared map opens without labels")
	if not map.is_open:
		return
	await _shot("notebook_map_default")
	var marker: Button = map.markers[0]
	if _real:
		await _real_move(_to_window(marker, marker.size / 2.0))
		await _real_press_at(_to_window(marker, marker.size / 2.0))
	else:
		marker.pressed.emit()
	await get_tree().process_frame
	_expect(map.notice.visible and map.notice.size.y < 300, "tapping a place opens one compact parchment label")
	await _shot("notebook_map_place")
	map.close_map()


func _notebook_clicks_path() -> void:
	await _step("start", func(): R.current.call("_on_start_pressed"))
	await _wait_room("GrandpaRoom")
	_answers = [true]
	await _click("BasketProp")
	await _click("Door")
	await _wait_room("Yard")
	_answers = [true]
	await _click("Jad")
	for round in 2:
		await _click_item("Notebook")
		_log("left button held after closing the notebook: %s" % Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT))
		var had_can := _has("WateringCan")
		await _click("Well")
		_expect(had_can or _has("WateringCan"), "a click on the Well works after the notebook (round %d)" % (round + 1))
	_expect(Globals.notebook.is_open == false, "notebook closed at the end")


func _notebook_path() -> void:
	var book := Globals.notebook
	book.open_notebook()
	_expect(not book.is_open, "notebook locked before Grandpa gives it")
	await _step("start notebook test", func(): R.current.call("_on_start_pressed"))
	await _wait_room("GrandpaRoom")
	_answers = [true]
	await _click("BasketProp")
	await _click("Door")
	await _wait_room("Yard")
	_answers = [true]
	await _click("Jad")
	await _hold_at(Vector2(0.355, 0.50), 0.7)
	var item: PopochiuInventoryItem = I.get_item_instance("Notebook")
	await item.on_click()
	_expect(book.is_open and get_tree().paused, "inventory notebook opens and pauses story")
	_expect(book.hint_context() == "yard", "hints follow current puzzle state")
	var first_text: String = book.hint_label.text
	book.more_button.pressed.emit()
	_expect(book.hint_label.text != first_text and Globals.hint_steps.yard == 1, "second hint is clearer")
	book.more_button.pressed.emit()
	_expect(Globals.hint_steps.yard == 2 and book.more_button.disabled, "third hint gives answer and stops escalation")
	book.page_buttons.words.pressed.emit()
	_expect(book.word_buttons.has("word_bucket") and book.word_buttons.size() == 1, "words page shows only discovered words")
	book.word_buttons.word_bucket.pressed.emit()
	_expect(book._voice.bus == ReemSettings.VOICE_BUS and book._voice.stream != null, "word replay uses existing recording and voice volume")
	book.page_buttons.cards.pressed.emit()
	_expect(Globals.friend_cards.is_empty(), "cards are not given before helping")
	book.page_buttons.map.pressed.emit()
	var map := Globals.valley_map
	_expect(map.is_open and not book.is_open, "notebook opens the shared map")
	for place: Dictionary in map.places:
		if place.room == "MeadowFork":
			map.select_place(place)
			_expect(map.destination.is_empty(), "map rejects unvisited destination")
	for place: Dictionary in map.places:
		if place.room == "GrandpaRoom":
			map.select_place(place)
			map._travel()
			break
	await _wait_room("GrandpaRoom")
	_expect(not book.is_open and not get_tree().paused and Globals.briefed, "map travels without resetting story")
	await _click("Door")
	await _wait_room("Yard")
	await _click("ExitRight")
	await _wait_room("Gate")
	await _click("ExitRight")
	await _wait_room("MeadowFork")
	await _click("ExitRight")
	await _wait_room("BigTree")
	await _click("Shahd")
	book.open_notebook()
	_expect(book.hint_context() == "mirror", "mirror puzzle has its own hint context")
	book.close_notebook()
	await _click("SunSpot")
	_expect(Globals.friend_cards.has("shahd"), "helping Shahd earns her card")
	book.open_notebook()
	book.show_page("cards")
	_expect(book._body.get_child_count() == 4, "earned card shows picture, name, fact and replay")
	await _shot("notebook_card")
	book.close_notebook()
	E.save_game(1)
	Globals.hint_steps.clear()
	Globals.friend_cards.clear()
	R.goto_room("Title")
	await _wait_room("Title")
	await _step("restore notebook progress", func(): R.current.call("_on_continue_pressed"))
	await _wait_room("BigTree")
	_expect(Globals.hint_steps.get("yard") == 2 and Globals.friend_cards.has("shahd"), "save restores hints and friend cards")
	book.open_notebook()
	var old_words: int = Globals.discovered_words.size()
	await _hold_at(Vector2(0.25, 0.75), 0.7)
	_expect(Globals.discovered_words.size() == old_words, "notebook holds do not reach story")
	_send_key(KEY_ESCAPE)
	await get_tree().process_frame
	_expect(not book.is_open and not get_tree().paused and not G.is_blocked, "Escape closes notebook and restores play")
	R.goto_room("Title")
	await _wait_room("Title")
	await _step("new journey resets notebook", func(): R.current.call("_on_start_pressed"))
	await _wait_room("GrandpaRoom")
	_expect(Globals.friend_cards.is_empty() and Globals.hint_steps.is_empty(), "new journey resets cards and hints")
	_expect(Globals.discovered_words.has("word_bucket"), "new journey retains discovered words")


func _highlight_ids() -> Array:
	return Globals.hotspot_highlight.targets.map(func(target: Dictionary): return target.id)


func _highlight_path() -> void:
	var highlight := Globals.hotspot_highlight
	highlight.reveal()
	_expect(highlight.targets.is_empty(), "no highlight on title")
	await _step("start highlight test", func(): R.current.call("_on_start_pressed"))
	await _wait_room("GrandpaRoom")
	highlight.button.pressed.emit()
	_expect(_highlight_ids().has("Mirror") and _highlight_ids().has("BasketProp"), "highlight includes actionable props")
	_expect(not _highlight_ids().has("Reem") and not _highlight_ids().has("Door"), "highlight excludes player and locked exit")
	_expect(not Globals.basket_taken and Globals.discovered_words.is_empty(), "highlight changes no story flags or words")
	await _shot("hotspot_highlight")
	highlight._remaining = 0.01
	await get_tree().process_frame
	await get_tree().process_frame
	_expect(highlight.targets.is_empty(), "glow disappears without blocking play")
	_send_key(KEY_H)
	await get_tree().process_frame
	_expect(not highlight.targets.is_empty(), "H repeats highlight without a cooldown")
	I.active = I.Basket
	await get_tree().process_frame
	_expect(highlight.targets.is_empty(), "no highlight during item use")
	I.active = null
	_answers = [true]
	await _click("BasketProp")
	highlight.reveal()
	_expect(not _highlight_ids().has("Mirror") and not _highlight_ids().has("BasketProp") and _highlight_ids().has("Door"), "glow follows updated puzzle state")
	Globals.settings.open_settings()
	# Two frames: the glow's own _process must run once after settings opened.
	await get_tree().process_frame
	await get_tree().process_frame
	_expect(highlight.targets.is_empty(), "settings clears the glow")
	Globals.settings.close_settings()
	await _click("Door")
	await _wait_room("Yard")
	highlight.reveal()
	_expect(_highlight_ids().has("Jad") and _highlight_ids().has("Well"), "highlight includes NPC and background hotspot")
	await _click("ExitRight")
	await _wait_room("Gate")
	highlight.reveal()
	_expect(_highlight_ids().has("ExitLeft") and not _highlight_ids().has("ExitRight"), "locked Gate exit stays unmarked")


## Focused Reem check: Yard only in a window; headless additionally checks room reuse.
func _reem_animation_path() -> void:
	Engine.time_scale = 1.0 if _real else 4.0
	await Globals.new_game()
	R.goto_room("Yard")
	await _wait_room("Yard")
	var rig: ReemWalkRig = C.player.get_node("WalkRig")
	_expect(rig.visible and not C.player.get_node("Sprite2D").visible, "persistent cutout replaces original")
	_expect(rig.get_node("Skeleton2D/Body/Head") is Bone2D, "Reem uses Skeleton2D and bones")
	_expect(R.current.has_node("DepthLayers"), "Yard has three depth layers")
	await _shot("idle")
	rig.blink()
	await get_tree().create_timer(.04).timeout
	_expect(rig._blinking, "blink closes eyes")
	await _shot("blink")
	await get_tree().create_timer(.2).timeout
	_expect(not rig._blinking, "blink reopens eyes")
	C.player.walk(C.player.position + Vector2(650, 0))
	for frame in 12:
		await get_tree().create_timer(.07).timeout
		await _shot("walk_%02d" % frame)
	await _wait_idle()
	_expect(not rig.walking, "walk stops in idle")
	Lines.say("reem_s1_010")
	await get_tree().create_timer(.35).timeout
	_expect(rig.talking, "voice drives mouth")
	await _shot("talking")
	await _wait_idle()
	_expect(not rig.talking, "mouth closes after voice")
	for mood in ["sad", "surprised", "happy"]:
		C.player.animate_line(mood, "")
		await get_tree().create_timer(.3).timeout
		_expect(rig.expression == mood, "line tone drives " + mood)
		await _shot(mood)
	rig.wave()
	await get_tree().create_timer(.5).timeout
	await _shot("wave")
	await get_tree().create_timer(1.3).timeout
	Globals.bloom()
	if not _real:
		await C.player.add_to_inventory(I.WateringCan)
	ReemEffects.burst(R.current, C.player.position + Vector2(50, -80), "water")
	await get_tree().create_timer(.15).timeout
	await _shot("effects")
	if _real:
		Globals.briefed = true
		_log("ok: ready for two manual clicks: Well, then Jad")
		_step_name = "manual Yard clicks"
		_step_started = Time.get_ticks_msec() / 1000.0
		while not C.player.has_inventory_item("WateringCan") or not Lines.said.has("jad_s1_019"):
			await get_tree().process_frame
		await _wait_idle()
		_step_name = ""
		_expect(C.player.has_inventory_item("WateringCan"), "real Well click awards watering can")
		_expect(Lines.said.has("jad_s1_019"), "real Grandpa click speaks his line")
		await _shot("after_real_clicks")
	else:
		R.goto_room("Stream")
		await _wait_room("Stream")
		_expect(C.player.get_node("WalkRig") == rig, "same rig survives room transition")
		_expect(R.current.has_node("DepthLayers"), "Stream has three depth layers")
		E.save_game(1)
		var saved_position: Vector2 = C.player.position
		R.goto_room("Title")
		await _wait_room("Title")
		await _step("continue animated Reem save", func(): R.current.call("_on_continue_pressed"))
		await _wait_room("Stream")
		_expect(C.player.has_inventory_item("WateringCan"), "inventory survives Continue")
		_expect(C.player.position.is_equal_approx(saved_position), "position survives Continue")
		_expect(C.player.get_node("WalkRig").visible, "cutout visible after Continue")


## Reported mirror scene only; no story route or other playable room.
func _mirror_ui_path() -> void:
	Engine.time_scale = 1.0 if DisplayServer.get_name() != "headless" else 4.0
	if _real:
		DisplayServer.window_move_to_foreground()
	await Globals.new_game()
	R.rooms_states["GrandpaRoom"].visited_times = 1
	R.goto_room("GrandpaRoom")
	await _wait_room("GrandpaRoom")
	var room: ReemRoom = R.current
	_expect(room.y_sort_enabled and room.get_node("Props").y_sort_enabled and room.get_node("Characters").y_sort_enabled, "room sorts props and characters by baseline Y")
	await _click("Mirror")
	_expect(absf(C.player.position.x - 570) < 3, "Reem approaches beside mirror")
	_answers = [true]
	await _click("BasketProp")
	var mirror := room.get_prop("Mirror")
	_expect(Globals.mirror_broken and Globals.basket_taken, "basket still falls and breaks mirror")
	_expect(C.player.position.x < mirror.position.x - 200, "Reem feet stay one step left of mirror")
	_expect(mirror.position.y > mirror.fall_target.y and mirror.get_node("Sprite2D").position.y < 0, "fallen mirror sorts from its bottom edge")
	var dialog = G.gui.get_node("DialogOverheadHighRes")
	Lines.say("reem_s1_006")
	await get_tree().create_timer(.35).timeout
	var bar: ReemSubtitleBar = dialog.subtitle
	_expect(dialog.modulate.a > 0 and not dialog.rich_text_label.visible, "one subtitle bar replaces overhead dialogue")
	_expect(bar.text_label.text == Lines.get_text("reem_s1_006"), "whole original Arabic line is present")
	_expect(bar.text_label.text_direction == Control.TEXT_DIRECTION_RTL and bar.text_label.get_theme_font("font") == ReemSubtitleBar.BOLD, "subtitle uses bold RTL Cairo")
	var screen_height := get_viewport().get_visible_rect().size.y
	_expect(bar.panel.get_global_rect().position.y > screen_height * .7 and bar.panel.get_global_rect().end.y <= screen_height, "subtitle stays at bottom inside screen")
	_expect(bar.text_label.get_line_count() <= 2 and bar.text_label.get_visible_line_count() == bar.text_label.get_line_count(), "subtitle wraps without cutting lines")
	await _shot("mirror_subtitles_fixed")
	await _wait_idle()
	# Offscreen narration uses exactly the same component and style.
	Lines.say("reem_s1_006", true)
	await get_tree().create_timer(.35).timeout
	var narration: NarrationBox = null
	for layer in Lines.get_children():
		for child in layer.get_children():
			if child is NarrationBox:
				narration = child
	_expect(narration != null and narration.text_label.text == Lines.get_text("reem_s1_006"), "narration uses the same full-text subtitle component")
	_expect(dialog.modulate.a == 0, "offscreen narration leaves no floating character text")
	await _shot("mirror_narration_fixed")
	await _wait_idle()
	G.block()
	PopochiuUtils.cursor.show_cursor("wait", true)
	await get_tree().process_frame
	await get_tree().process_frame
	_expect(not PopochiuUtils.cursor.visible and Input.mouse_mode == Input.MOUSE_MODE_VISIBLE, "wait cursor cannot appear while blocked")
	G.unblock()
	while Lines.busy:
		await get_tree().process_frame
	_expect(not Lines.busy, "narration closes cleanly")
	if DisplayServer.get_name() == "headless":
		var longest := ""
		for line_id in Lines._lines:
			var candidate := Lines.get_text(line_id)
			if candidate.length() > longest.length():
				longest = candidate
		for font_size in [44, 56]:
			bar.setup(longest)
			bar.text_label.add_theme_font_size_override("font_size", font_size)
			bar._fit()
			for frame in 5:
				await get_tree().process_frame
			_expect(bar.text_label.get_line_count() <= 2 and bar.text_label.get_visible_line_count() == bar.text_label.get_line_count(), "longest dialogue fits at text size %d" % font_size)
