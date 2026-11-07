@tool
extends ReemRoom

const Data := preload("room_waterfall_path_state.gd")
var state: Data = load("res://game/rooms/waterfall_path/room_waterfall_path.tres")

@export var fruit_start := Vector2(590, 901)
@export var fruit_path := Vector2(840, 901)
@export var fruit_aside := Vector2(950, 914)


func _on_room_started() -> void:
	if not Globals.waterfall.get("introduced", false):
		Globals.waterfall["introduced"] = true
		await Lines.say("reem_waterfall_arrive")


func _setup_room() -> void:
	_sync_fruit()


func _on_restore_from_savegame() -> void:
	super()
	_sync_fruit()


func _sync_fruit() -> void:
	var story := Globals.waterfall
	var fruit := $Props/Fruit as Node2D
	fruit.position = fruit_start
	if story.get("provoked", false) and not story.get("lantern_hanger", false):
		fruit.position = fruit_aside if story.get("threw", false) and not story.get("ready", false) else fruit_path


func is_exit_open(exit_name: String) -> bool:
	return exit_name == "ExitLeft" or Globals.waterfall.get("lantern_hanger", false)


func has_action(obj: PopochiuClickable) -> bool:
	var story := Globals.waterfall
	match obj.script_name:
		"Qarqoor": return not story.get("lantern_hanger", false)
		"Fruit": return story.get("ready", false) and not story.get("lantern_hanger", false)
	return super(obj)


func _on_object_clicked(obj: PopochiuClickable) -> void:
	if not has_action(obj):
		return
	match obj.script_name:
		"ExitLeft": await leave_through(obj, "HoneyOrchard")
		"ExitRight": await leave_through(obj, "NarrowPass" if R.rooms_states.has("NarrowPass") else "End")
		"Qarqoor": await _talk_to_qarqoor()
		"Fruit": await _play_with_qarqoor()


func _talk_to_qarqoor() -> void:
	var story := Globals.waterfall
	if story.get("ready", false):
		await Lines.say("reem_waterfall_roll")
		return
	if not story.get("provoked", false):
		story["provoked"] = true
		await _roll_to(fruit_path)
	await Lines.say("reem_waterfall_provoked")
	if await Choices.ask_two(Globals.notebook.labels["waterfall_ask"], Globals.notebook.labels["waterfall_throw"]):
		story["ready"] = true
		await Lines.say("reem_waterfall_ask")
		if $Props/Fruit.position != fruit_path:
			await _roll_to(fruit_path)
		await Lines.say("reem_waterfall_roll")
	else:
		if not story.get("threw", false):
			story["threw"] = true
			Globals.wilt()
		await _roll_to(fruit_aside)
		await Lines.say("reem_waterfall_throw")
	E.save_game(1)


func _play_with_qarqoor() -> void:
	var story := Globals.waterfall
	await _roll_to(fruit_start)
	story["lantern_hanger"] = true
	Globals.friend_cards["qarqoor"] = true
	if story.get("threw", false):
		story["threw"] = false
		Globals.heal()
	else:
		Globals.bloom()
	await Lines.say("reem_waterfall_gift")
	E.save_game(1)


func _roll_to(destination: Vector2) -> void:
	G.block()
	var tween := create_tween().set_parallel()
	tween.tween_property($Props/Fruit, "position", destination, 0.5)
	tween.tween_property($Props/Fruit/Sprite2D, "rotation", TAU, 0.5).from(0.0)
	await tween.finished
	G.unblock()
