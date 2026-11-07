@tool
extends ReemRoom

@export var state: PopochiuRoomData
@export var warm_bird := Vector2(1290, 655)
@export var sled_start := Vector2(375, 355)
@export var sled_finish := Vector2(1260, 898)
@export var deer_shelter := Vector2(1660, 727)
var sliding := false


func _on_room_started() -> void:
	var story := Globals.snow
	if story.get(script_name, false):
		return
	story[script_name] = true
	match script_name:
		"SnowEdge": await Lines.say("reem_snow_edge", true)
		"SnowTracks": await Lines.say("reem_snow_tracks", true)
		"SledHill": await Lines.say("reem_snow_sled", true)


func _setup_room() -> void:
	_sync_snow()


func _on_restore_from_savegame() -> void:
	super()
	_sync_snow()


func _sync_snow() -> void:
	var story := Globals.snow
	match script_name:
		"SnowEdge":
			var warm: bool = story.get("warm", false)
			$Bundle.visible = warm
			if warm:
				$Props/Goldfinch.position = warm_bird
		"SnowTracks":
			for index in range(1, 4):
				var footprint := get_prop("Hoof%d" % index)
				footprint.modulate.a = 0.42 if index <= story.get("track", 0) else 1.0
		"SledHill":
			$Props/Sled.position = sled_finish if story.get("slid", false) else sled_start
			if story.get("rescued", false):
				$Props/SnowDeer.position = deer_shelter


func is_exit_open(exit_name: String) -> bool:
	if sliding:
		return false
	if exit_name == "ExitLeft":
		return true
	if script_name == "SnowEdge":
		return Globals.snow.get("warm", false)
	return Globals.snow.get("track", 0) == 3


func has_action(obj: PopochiuClickable) -> bool:
	var story := Globals.snow
	if sliding:
		return false
	match obj.script_name:
		"Goldfinch": return not story.get("warm", false)
		"BirdShelter": return story.get("offered", false) and not story.get("warm", false)
		"SnowFox": return not story.get("fox", false)
		"RabbitPrint", "FoxPrint", "Hoof1", "Hoof2", "Hoof3":
			return story.get("tracking", false) and story.get("track", 0) < 3
		"Sled": return not story.get("slid", false)
		"SnowDeer": return story.get("slid", false) and not story.get("rescued", false)
	return super(obj)


func _on_object_clicked(obj: PopochiuClickable) -> void:
	if not has_action(obj):
		return
	match obj.script_name:
		"ExitLeft":
			var back := {"SnowEdge": "HillSlope", "SnowTracks": "SnowEdge", "SledHill": "SnowTracks"}
			await leave_through(obj, back[script_name])
		"ExitRight":
			var next := {"SnowEdge": "SnowTracks", "SnowTracks": "SledHill"}
			await leave_through(obj, next[script_name])
		"Goldfinch": await _offer_bundle()
		"BirdShelter": await _warm_bird()
		"Arnoob":
			Globals.snow["tracking"] = true
			await Lines.say("reem_snow_rabbit", true)
			E.save_game(1)
		"SnowFox":
			Globals.snow["fox"] = true
			await Lines.say("fox_snow_tracks")
			E.save_game(1)
		"RabbitPrint", "FoxPrint", "Hoof1", "Hoof2", "Hoof3":
			await _follow_track(obj.script_name)
		"Sled": await _ride_sled()
		"SnowDeer": await _help_deer()


func _offer_bundle() -> void:
	var story := Globals.snow
	if story.get("offered", false):
		await Lines.say("reem_snow_shelter", true)
		return
	await Lines.say("reem_snow_cold", true)
	if await Choices.ask_two(Globals.notebook.labels["snow_share"], Globals.notebook.labels["snow_keep"]):
		story["offered"] = true
		await Lines.say("reem_snow_shelter", true)
	else:
		if not story.get("kept", false):
			story["kept"] = true
			Globals.wilt()
		var shiver := create_tween()
		for angle in [-0.06, 0.06, -0.04, 0.0]:
			shiver.tween_property($Props/Goldfinch/Sprite2D, "rotation", angle, 0.12)
		await Lines.say("reem_snow_keep", true)
	E.save_game(1)


func _warm_bird() -> void:
	var story := Globals.snow
	story["warm"] = true
	Globals.friend_cards["goldfinch"] = true
	if story.get("kept", false):
		story["kept"] = false
		Globals.heal()
	else:
		Globals.bloom()
	_sync_snow()
	await Lines.say("reem_snow_warm", true)
	E.save_game(1)


func _follow_track(id: String) -> void:
	var step: int = Globals.snow.get("track", 0) + 1
	if id != "Hoof%d" % step:
		await Lines.say("reem_snow_compare", true)
		return
	Globals.snow["track"] = step
	A.sfx_ui_click.play()
	_sync_snow()
	if step == 3:
		await Lines.say("reem_snow_follow", true)
	E.save_game(1)


func _ride_sled() -> void:
	sliding = true
	G.block()
	C.player.position = sled_start - Vector2(0, 12)
	RoomHelpers.face(C.player, false)
	var ride := create_tween()
	ride.tween_method(_sled_position, 0.0, 1.0, 1.8).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await ride.finished
	G.unblock()
	sliding = false
	Globals.snow["slid"] = true
	E.save_game(1)


func _sled_position(amount: float) -> void:
	var spot := sled_start.lerp(sled_finish, amount) - Vector2(0, sin(amount * PI) * 57.0)
	$Props/Sled.position = spot
	C.player.position = spot - Vector2(0, 12)


func _help_deer() -> void:
	Globals.snow["rescued"] = true
	Globals.friend_cards["snow_deer"] = true
	Globals.bloom()
	_sync_snow()
	await Lines.say("reem_snow_help", true)
	E.save_game(1)
