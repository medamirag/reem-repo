@tool
extends ReemRoom
## Station 2, room 5: BigTree (game_spec.md). Shahd the bee is sad: the flowers in the big
## tree's shade cannot open. Reem bounces the sunlight onto them with Grandpa's hand mirror
## (Bloom, HoneyJar). If she trampled the meadow flowers, Shahd first asks her to fix them; if
## she hid the broken mirror, she must go back and tell Grandpa (needs_mirror).
## Exits: left → MeadowFork; right → FoxRock, only once the flowers are open.

const Data := preload('room_big_tree_state.gd')
const OPEN_TEXTURE := preload("res://assets/cut/flowers_states/flowers_open.tres")
const CLOSED_TEXTURE := preload("res://assets/cut/flowers_states/flowers_closed.tres")
## How long the beam of light takes to appear, stays, and fades (seconds).
const BEAM_IN := 0.6
const BEAM_HOLD := 0.8
const BEAM_OUT := 0.6

var state: Data = load("res://game/rooms/big_tree/room_big_tree.tres")


#region Virtual ####################################################################################
func _setup_room() -> void:
	var flowers := get_prop("FlowersShade")
	flowers.texture = OPEN_TEXTURE if Globals.flowers_open else CLOSED_TEXTURE
	($Beam as Line2D).hide()

	# game_spec.md: "Notebook hint here (after met_shahd): reem_s2_026".
	Globals.notebook_hint = func() -> void:
		if Globals.met_shahd:
			await Lines.say("reem_s2_026")


func _on_object_clicked(obj: PopochiuClickable) -> void:
	match obj.script_name:
		"Shahd":
			await _talk_to_shahd()
		"Hives":
			await C.player.walk_to_clicked()
			await Lines.say("reem_s2_027")
		"FlowersShade", "SunSpot":
			await _click_flowers_or_sun()
		"ExitLeft":
			await leave_through(obj, "MeadowFork")
		"ExitRight":
			if Globals.flowers_open:
				await leave_through(obj, "FoxRock")


func _on_item_used_on(obj: PopochiuClickable, item: PopochiuInventoryItem) -> void:
	if item.script_name != "HandMirror" or not obj.script_name in ["FlowersShade", "SunSpot"]:
		return
	if not Globals.met_shahd or Globals.flowers_open:
		return

	await _open_flowers()


func is_exit_open(exit_name: String) -> bool:
	return exit_name != "ExitRight" or Globals.flowers_open


func has_action(obj: PopochiuClickable) -> bool:
	if obj.script_name in ["FlowersShade", "SunSpot"]:
		return Globals.met_shahd and not Globals.flowers_open
	return super(obj)


#endregion

#region Private ####################################################################################
## game_spec.md BigTree, "Talk to Shahd" (the cases are checked in the order the spec lists them).
func _talk_to_shahd() -> void:
	await C.player.walk_to_clicked()
	RoomHelpers.face(C.player, false)

	if Globals.trampled and not Globals.told_to_fix:
		await Lines.say("bee_s2_010b")
		await Lines.say("reem_s2_011b")
		await Lines.say("bee_s2_012b")
		Globals.told_to_fix = true
		return

	if Globals.told_to_fix and not Globals.flowers_fixed:
		await Lines.say("bee_s2_012b")
		return

	if not Globals.met_shahd:
		if Globals.trampled and Globals.flowers_fixed:
			await Lines.say("bee_s2_014b")
		await Lines.say("reem_s2_020")
		await Lines.say("bee_s2_021")
		await Lines.say("reem_s2_022")
		await Lines.say("bee_s2_023")
		await Lines.say("bee_s2_024")
		await Lines.say("reem_s2_025")
		Globals.met_shahd = true
		return

	if Globals.flowers_open:
		await Lines.say("bee_s2_031")
	else:
		# Not in game_spec.md (Decisions to review): met Shahd, flowers still closed. She repeats
		# what the problem is.
		await Lines.say("bee_s2_023")


func _click_flowers_or_sun() -> void:
	if not Globals.met_shahd or Globals.flowers_open:
		return

	await C.player.walk_to_clicked()

	if not C.player.has_inventory_item("HandMirror"):
		# game_spec.md: clicking without having the HandMirror (only possible after hiding it).
		await Lines.say("reem_s2_041b")
		await Lines.say("reem_s2_042b")
		Globals.needs_mirror = true
	else:
		# One click does everything (game_spec.md 1): she uses the mirror straight away.
		await _open_flowers()


## game_spec.md BigTree, "Use HandMirror on SunSpot or on FlowersShade".
func _open_flowers() -> void:
	G.block()
	await C.player.walk(get_marker_position("BeamStart") + Vector2(0, 190))
	RoomHelpers.face(C.player, true)
	await _show_beam()

	A.sfx_flowers_open.play()
	get_prop("FlowersShade").texture = OPEN_TEXTURE
	G.unblock()

	await Lines.say("reem_s2_030")
	await Lines.say("bee_s2_031")
	await Lines.say("reem_s2_032")
	await Lines.say("bee_s2_033")
	await C.player.add_to_inventory(I.HoneyJar)
	Globals.flowers_open = true
	Globals.bloom()


## A soft beam of light from the mirror in Reem's hand, over the sunny grass, to the flowers:
## a glowing line that fades in and out.
func _show_beam() -> void:
	var beam := $Beam as Line2D
	# Roughly where Reem's hand is: a bit in front of her, at about half her height.
	var hand := C.player.position + Vector2(-40, -height * reem_height_ratio * 0.5)
	var sun := get_hotspot("SunSpot").position
	var flowers := get_prop("FlowersShade").position
	beam.points = PackedVector2Array([hand, sun, flowers])
	beam.modulate.a = 0.0
	beam.show()

	var tween := create_tween()
	tween.tween_property(beam, "modulate:a", 1.0, BEAM_IN)
	tween.tween_interval(BEAM_HOLD)
	tween.tween_property(beam, "modulate:a", 0.0, BEAM_OUT)
	await tween.finished
	beam.hide()


#endregion
