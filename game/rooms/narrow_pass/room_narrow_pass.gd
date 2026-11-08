@tool
extends ReemRoom

const Data := preload("room_narrow_pass_state.gd")
var state: Data = load("res://game/rooms/narrow_pass/room_narrow_pass.tres")
## Where the rock over Thaaloob's tail ends up after it rolls away (docs/BUGS.md #5).
@export var stone_open := Vector2(1610, 800)
## How far the rock turns while rolling away (radians; one full turn lands it flat again).
@export var stone_roll := TAU
@export var fox_free := Vector2(1090, 854)
const TAIL_OFFSET := Vector2(110, -172)


func _on_room_started() -> void:
	if C.player.last_room in ["HillSlope", "WaterfallPath"]:
		Globals.narrow_pass["origin"] = C.player.last_room
	if not Globals.narrow_pass.get("introduced", false):
		Globals.narrow_pass["introduced"] = true
		await Lines.say("reem_pass_arrive")


func _setup_room() -> void:
	_sync_stone()


func _on_restore_from_savegame() -> void:
	super()
	_sync_stone()


func _sync_stone() -> void:
	if Globals.narrow_pass.get("fox_joins", false):
		$Props/LooseStone.position = stone_open
		$Props/LooseStone/Sprite2D.rotation = stone_roll
		# Once rolled off the tail it no longer has to be drawn over Thaaloob.
		$Props/LooseStone/Sprite2D.z_index = 0
		$Props/Thaaloob.position = fox_free
		$Props/FoxTail.position = fox_free + TAIL_OFFSET


func is_exit_open(exit_name: String) -> bool:
	return exit_name == "ExitLeft" or Globals.narrow_pass.get("fox_joins", false)


func has_action(obj: PopochiuClickable) -> bool:
	var story := Globals.narrow_pass
	match obj.script_name:
		"Thaaloob": return not story.get("fox_joins", false)
		"LooseStone": return story.get("help", false) and not story.get("fox_joins", false)
		"FoxTail": return false
	return super(obj)


func _on_object_clicked(obj: PopochiuClickable) -> void:
	if not has_action(obj):
		return
	match obj.script_name:
		"ExitLeft": await leave_through(obj, Globals.narrow_pass.get("origin", "HillSlope"))
		"ExitRight": await leave_through(obj, "HilltopFestival" if R.rooms_states.has("HilltopFestival") else "End")
		"Thaaloob": await _talk_to_fox()
		"LooseStone": await _free_fox()


func _talk_to_fox() -> void:
	var story := Globals.narrow_pass
	if story.get("help", false):
		await Lines.say("reem_pass_stone")
		return
	await Lines.say("fox_pass_help")
	if await Choices.ask_two(Globals.notebook.labels["pass_help"], Globals.notebook.labels["pass_leave"]):
		story["help"] = true
		await Lines.say("reem_pass_stone")
	else:
		if not story.get("left_fox", false):
			story["left_fox"] = true
			Globals.wilt()
		await Lines.say("reem_pass_leave")
	E.save_game(1)


func _free_fox() -> void:
	var story := Globals.narrow_pass
	G.block()
	var tween := create_tween()
	# The rock over the tail rolls away to the right, then Thaaloob steps free.
	tween.tween_property($Props/LooseStone, "position", stone_open, 0.9).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.parallel().tween_property($Props/LooseStone/Sprite2D, "rotation", stone_roll, 0.9).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_callback(func() -> void: $Props/LooseStone/Sprite2D.z_index = 0)
	tween.tween_property($Props/Thaaloob, "position", fox_free, 0.4)
	tween.parallel().tween_property($Props/FoxTail, "position", fox_free + TAIL_OFFSET, 0.4)
	await tween.finished
	G.unblock()
	await Lines.say("fox_pass_sorry")
	if Globals.cave.get("fox_took_honey", false):
		await Lines.say("fox_pass_honey")
		if not C.player.has_inventory_item("HoneyJar"):
			await C.player.add_to_inventory(I.HoneyJar)
		Globals.cave["fox_took_honey"] = false
		story["honey_returned"] = true
	await Lines.say("fox_pass_join")
	await Lines.say("reem_pass_welcome")
	story["fox_joins"] = true
	if story.get("left_fox", false):
		story["left_fox"] = false
		Globals.heal()
	else:
		Globals.bloom()
	E.save_game(1)
