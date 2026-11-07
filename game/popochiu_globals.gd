extends Node
## The game's own state, on top of what Popochiu already tracks: the heart tree (game_spec.md
## 4.3), the flags each room checks to remember what the child has already done (4.5), and a
## small helper for ambience sound (part of 4.6).
##
## This is Popochiu's user-defined singleton (registered as the autoload `Globals`), so any
## room or script can reach it directly, e.g. `Globals.bloom()` or `if Globals.chose_truth:`.

## Emitted whenever the heart tree's picture should be refreshed. `grew` is true only for
## `bloom()`, which is the one case that also briefly enlarges the tree (game_spec.md 4.3).
signal heart_changed(grew: bool)

const HEART_TREE_SCENE := "res://game/gui/components/heart_tree/heart_tree.tscn"

## Word discovery (game/scripts/word_discovery.gd).
var word_discovery: WordDiscovery
var settings: ReemSettings
var notebook: ReemNotebook
var hotspot_highlight: HotspotHighlight
var hint_steps := {}
var friend_cards := {}
## Stream task flags and the feather festival contribution.
var stream := {}
var pine := {}
var oak := {}
## Every word the child has discovered so far (word id -> true). Kept for a later reward; not
## cleared by a new game from the end screen, included in the autosave.
var discovered_words := {}


func _ready() -> void:
	if not Engine.is_editor_hint():
		settings = ReemSettings.new()
		settings.name = "Settings"
		add_child(settings)

	# Automatic playtest (tools/playtest.gd), only when the game is started with
	#   godot --headless --path . -- --playtest
	# Never active in a normal run.
	if not Engine.is_editor_hint() and "--playtest" in OS.get_cmdline_user_args():
		add_child(load("res://tools/playtest.gd").new())

	# Word discovery: hold on an object to see and hear its Arabic name (word_discovery.gd).
	if not Engine.is_editor_hint():
		word_discovery = WordDiscovery.new()
		word_discovery.name = "WordDiscovery"
		add_child(word_discovery)
		notebook = ReemNotebook.new()
		notebook.name = "Notebook"
		add_child(notebook)
		hotspot_highlight = HotspotHighlight.new()
		hotspot_highlight.name = "HotspotHighlight"
		add_child(hotspot_highlight)

#region Heart tree (game_spec.md 4.3) #################################################################
## Good deeds.
var blossoms := 0
## Mistakes not yet fixed.
var wilts := 0


## A good choice: one more blossom, a little chime, the tree grows for a moment.
func bloom() -> void:
	blossoms += 1
	A.sfx_heart_bloom.play()
	heart_changed.emit(true)


## A mistake: one more wilt.
func wilt() -> void:
	wilts += 1
	A.sfx_heart_wilt.play()
	heart_changed.emit(false)


## Fixing a past mistake: one fewer wilt (never below zero).
func heal() -> void:
	wilts = maxi(0, wilts - 1)
	A.sfx_heart_bloom.play()
	heart_changed.emit(false)


## Which heart tree picture to show right now, as the piece name under res://assets/cut/heart_tree_states/
## (game_spec.md 4.3: "if wilts > 0 show heart_wilt, otherwise heart_0..heart_3 for min(blossoms, 3)").
func heart_picture() -> String:
	if wilts > 0:
		return "heart_wilt"

	return "heart_%d" % mini(blossoms, 3)


## The end-screen picture: the full, glowing tree only if every mistake was fixed and there were
## at least 3 good deeds.
func end_heart_picture() -> String:
	if wilts == 0 and blossoms >= 3:
		return "heart_full"

	return heart_picture()


## Makes sure the heart tree widget is showing in the top-right corner of the GUI. Safe to call
## every time a room is entered: does nothing if the tree is already there. This is how the tree
## gets added, instead of editing Popochiu's generated game/gui/gui.tscn by hand.
func ensure_heart_tree() -> void:
	if not is_instance_valid(G.gui):
		return

	if G.gui.has_node("HeartTree"):
		return

	var tree: Control = load(HEART_TREE_SCENE).instantiate()
	tree.name = "HeartTree"
	G.gui.add_child(tree)


#endregion

#region Notebook hint (game_spec.md 4.4) ###############################################################
## Set by the current room to the function that should run when the child clicks the Notebook in
## the inventory ("Clicking it in the inventory plays the current hint"). An invalid Callable
## (the default) means this room has no hint to give, so clicking does nothing.
var notebook_hint: Callable = Callable()


#endregion

#region State flags (game_spec.md 4.5) #################################################################
var basket_taken := false
var mirror_broken := false
var chose_truth := false
var mirror_hidden := false
var briefed := false
var confessed := false
var trampled := false
var told_to_fix := false
var flowers_fixed := false
var met_shahd := false
var needs_mirror := false
var flowers_open := false
var fox_done := false
var traded := false
var stone_wiped := false
var mirror_recovered := false

# Not in game_spec.md 4.5's list: small "already happened" markers the rooms need to play
# something only once (game_spec.md: "On first entering after briefed", "First click on the
# right exit", "On first entering (or first click on Thaaloob)").
var gate_intro_done := false
var fork_choice_done := false
var fox_intro_done := false


## Puts every flag and counter back to how a new game starts. Used by the end screen's
## «العودة إلى البداية» button.
func reset() -> void:
	oak.clear()
	pine.clear()
	stream.clear()
	hint_steps.clear()
	friend_cards.clear()
	blossoms = 0
	wilts = 0
	basket_taken = false
	mirror_broken = false
	chose_truth = false
	mirror_hidden = false
	briefed = false
	confessed = false
	trampled = false
	told_to_fix = false
	flowers_fixed = false
	met_shahd = false
	needs_mirror = false
	flowers_open = false
	fox_done = false
	traded = false
	stone_wiped = false
	mirror_recovered = false
	gate_intro_done = false
	fork_choice_done = false
	fox_intro_done = false
	notebook_hint = Callable()
	heart_changed.emit(false)


## Everything a new game needs (end screen «العودة إلى البداية»): the flags above, the
## inventory, and Popochiu's memory of every room (how many times it was visited, where its
## props and characters were), so each room plays its first-visit lines again.
func new_game() -> void:
	clear_autosave()
	reset()
	if is_instance_valid(C.player):
		await I.clean_inventory(C.player)
		C.player.last_room = ""
	for room_state: PopochiuRoomData in R.rooms_states.values():
		room_state.visited_times = 0
		room_state.props.clear()
		room_state.hotspots.clear()
		room_state.walkable_areas.clear()
		room_state.regions.clear()
		room_state.characters.clear()


#endregion

#region Sound (game_spec.md 4.6) #######################################################################
## Name of the AudioCueSound (as registered on the `A` singleton) currently looping as ambience.
var _ambience_cue := ""


## Plays `cue_name` on a loop, quietly, stopping whatever ambience was playing before. Pass an
## empty string to just stop the current ambience (for a room with none).
func play_ambience(cue_name: String) -> void:
	if cue_name == _ambience_cue:
		return

	if not _ambience_cue.is_empty():
		var old: PopochiuAudioCue = A.get(_ambience_cue)
		if old:
			old.stop()

	_ambience_cue = cue_name

	if cue_name.is_empty():
		return

	var cue: PopochiuAudioCue = A.get(cue_name)
	if cue:
		cue.play()


#endregion


func on_save() -> Dictionary:
	return {"discovered_words": discovered_words, "hint_steps": hint_steps, "friend_cards": friend_cards, "stream": stream, "pine": pine, "oak": oak}


func on_load(data: Dictionary) -> void:
	pine = data.get("pine", {}).duplicate()
	oak = data.get("oak", {}).duplicate()
	stream = data.get("stream", {}).duplicate()
	discovered_words = data.get("discovered_words", {}).duplicate()
	hint_steps = data.get("hint_steps", {}).duplicate()
	friend_cards = data.get("friend_cards", {}).duplicate()
	refresh_friend_cards()
	play_ambience("")
	heart_changed.emit(false)


func clear_autosave() -> void:
	if FileAccess.file_exists("user://save_1.json"):
		DirAccess.remove_absolute("user://save_1.json")


func refresh_friend_cards() -> void:
	if flowers_open:
		friend_cards["shahd"] = true
