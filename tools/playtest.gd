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
	if _path in ["stream", "stream_sand"]:
		await _stream_path(_path == "stream_sand")
		_log("DONE " + _path)
		get_tree().quit()
		return
	if _path == "stream_words":
		await Globals.new_game()
		R.goto_room("Stream")
		await _wait_room("Stream")
		for sample in [[Vector2(0.28, 0.62), "word_log"], [Vector2(0.396, 0.66), "word_duck"], [Vector2(0.36, 0.69), "word_duckling"], [Vector2(0.677, 0.65), "word_rabbit"], [Vector2(0.92, 0.38), "word_reed"], [Vector2(.335,.14), "word_sun"], [Vector2(.10,.06), "word_olive"]]:
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
	if _path == "station_shots":
		await Globals.new_game()
		R.goto_room("Stream")
		await _wait_room("Stream")
		await C.player.add_to_inventory(I.Notebook)
		await C.player.add_to_inventory(I.Lantern)
		await _click("Log")
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
	_expect(Globals.stream.get("bridge") and Globals.stream.get("feather") and Globals.friend_cards.has("duck"), "ducks crossed, card and feather earned")
	await _click("Log")
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
	await _hold_at(Vector2(0.20, 0.80), 0.7)
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
		if Globals.notebook.is_open:
			_expect(true, "Notebook inventory click opens its pages")
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
	_expect(book.map_buttons.MeadowFork.disabled, "unvisited map destination locked")
	book.travel("End")
	_expect(book.is_open and _room_name() == "Yard", "map cannot skip to ending")
	book.travel("MeadowFork")
	_expect(book.is_open and _room_name() == "Yard", "map rejects unvisited destination")
	book.map_buttons.GrandpaRoom.pressed.emit()
	await _wait_room("GrandpaRoom")
	_expect(not book.is_open and not get_tree().paused and Globals.briefed, "map travels without resetting story")
	await _click("Door")
	await _wait_room("Yard")
	await _click("ExitRight")
	await _wait_room("Gate")
	await _click("ExitRight")
	await _wait_room("MeadowFork")
	_answers = [true]
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
