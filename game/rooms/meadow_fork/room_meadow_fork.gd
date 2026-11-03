@tool
extends ReemRoom
## Station 2, room 4: MeadowFork (game_spec.md). The path goes the long way round the meadow;
## a sign asks walkers to stay on it. The first time Reem heads for the right exit she chooses
## (Choice 2): stay on the path (green, Bloom) or cut across the flowers (sand: tramples them,
## Wilt). Later, if Shahd asked her to, she can water the trampled flowers back (Heal).
## Exits: left → Gate; right → BigTree.

const Data := preload('room_meadow_fork_state.gd')
const OPEN_TEXTURE := preload("res://assets/cut/flowers_states/flowers_open.tres")
const TRAMPLED_TEXTURE := preload("res://assets/cut/flowers_states/flowers_trampled.tres")
## Size of the text written on the sign board (game_spec.md: "small, in a dark brown color").
const SIGN_FONT_SIZE := 24
const SIGN_COLOR := Color(0.29, 0.16, 0.06)

var state: Data = load("res://game/rooms/meadow_fork/room_meadow_fork.tres")


#region Virtual ####################################################################################
func _setup_room() -> void:
	_write_sign()

	var flowers := get_prop("FlowersFork")
	if Globals.trampled and not Globals.flowers_fixed:
		flowers.texture = TRAMPLED_TEXTURE
	else:
		flowers.texture = OPEN_TEXTURE

	Globals.notebook_hint = func() -> void: await Lines.say("reem_s2_002")


func _on_room_started() -> void:
	if state.visited_times == 1:
		await Lines.say("reem_s2_001")


func _on_object_clicked(obj: PopochiuClickable) -> void:
	match obj.script_name:
		"Sign":
			await C.player.walk_to_clicked()
			await Lines.say("reem_s2_002")
		"ExitLeft":
			await leave_through(obj, "Gate")
		"ExitRight":
			if Globals.fork_choice_done:
				await leave_through(obj, "BigTree")
			else:
				await _choice_2(obj)


func _on_item_used_on(obj: PopochiuClickable, item: PopochiuInventoryItem) -> void:
	if obj.script_name != "FlowersFork" or item.script_name != "WateringCan":
		return
	if not (Globals.trampled and Globals.told_to_fix and not Globals.flowers_fixed):
		return

	await C.player.walk_to_clicked()
	A.sfx_water_pour.play()
	await Lines.say("reem_s2_013b")
	(obj as PopochiuProp).texture = OPEN_TEXTURE
	Globals.flowers_fixed = true
	Globals.heal()


#endregion

#region Private ####################################################################################
func _write_sign() -> void:
	var label := get_node_or_null("Props/Sign/SignText") as RichTextLabel
	if label == null:
		return

	label.add_theme_font_override("normal_font", ArabicText.get_font())
	label.add_theme_font_size_override("normal_font_size", SIGN_FONT_SIZE)
	label.add_theme_color_override("default_color", SIGN_COLOR)
	ArabicText.make_rtl(label)
	label.text = "[center]%s[/center]" % Labels.SIGN


## game_spec.md MeadowFork, "First click on the right exit".
func _choice_2(exit: PopochiuClickable) -> void:
	G.block()
	await C.player.walk(get_marker_position("ChoiceSpot"))
	G.unblock()
	await Lines.say("reem_s2_003")

	var went_green: bool = await Choices.ask_two(Labels.CHOICE2_GREEN, Labels.CHOICE2_SAND)
	Globals.fork_choice_done = true

	if went_green:
		await Lines.say("reem_s2_004a")
		Globals.bloom()
		await leave_through(exit, "BigTree")
		return

	await Lines.say("reem_s2_004b")
	G.block()
	# Straight across the grass, through the flowers, and off to the right.
	await scripted_walk(get_marker_position("AcrossFlowers"))
	A.sfx_trample.play()
	get_prop("FlowersFork").texture = TRAMPLED_TEXTURE
	Globals.trampled = true
	Globals.wilt()
	await scripted_walk(get_marker_position("FlowersFarSide"))
	G.unblock()
	R.goto_room("BigTree")


#endregion
