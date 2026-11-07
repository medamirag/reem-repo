@tool
extends ReemRoom

const SHAPES := ["Diamond", "Circle", "Triangle", "Crescent"]
const BACK := {"OwlPerch": "HilltopFestival", "ObservatoryDome": "OwlPerch", "StarRidge": "ObservatoryDome"}
const ARRIVAL := {"OwlPerch": "reem_star_perch", "ObservatoryDome": "reem_star_dome", "StarRidge": "reem_star_caravan"}
@export var state: PopochiuRoomData


func _on_room_started() -> void:
	if not Globals.stars.get(script_name, false):
		Globals.stars[script_name] = true
		await Lines.say(ARRIVAL[script_name], true)


func _setup_room() -> void:
	_sync_chart()


func _on_restore_from_savegame() -> void:
	super()
	_sync_chart()


func is_exit_open(exit_name: String) -> bool:
	return exit_name == "ExitLeft" or (script_name == "ObservatoryDome" and Globals.stars.get("chart", 0) == SHAPES.size())


func has_action(obj: PopochiuClickable) -> bool:
	var story := Globals.stars
	var id := obj.script_name
	match id:
		"Bat": return not story.get("listened", false)
		"Owl": return story.get("listened", false)
		"Astronomer": return story.get("chart", 0) < SHAPES.size()
		"Caravan": return not story.get("safe", false)
		"TrailFox": return not story.get("fox", false)
	if id.ends_with("Star"):
		return story.get("chart_open", false) and story.get("chart", 0) < SHAPES.size()
	if id.ends_with("Marker"):
		return story.get("guiding", false) and not story.get("safe", false)
	return super(obj)


func _on_object_clicked(obj: PopochiuClickable) -> void:
	if not has_action(obj):
		return
	var story := Globals.stars
	var id := obj.script_name
	match id:
		"ExitLeft": await leave_through(obj, BACK[script_name])
		"ExitRight": await leave_through(obj, "StarRidge")
		"Bat": await _listen()
		"Owl": await _fly(obj)
		"Astronomer":
			story["chart_open"] = true
			_sync_chart()
			await Lines.say("reem_star_chart", true)
			E.save_game(1)
		"Caravan":
			story["guiding"] = true
			_sync_chart()
			await Lines.say("reem_star_guide", true)
			E.save_game(1)
		"TrailFox":
			story["fox"] = true
			await Lines.say("fox_star_bright", true)
			E.save_game(1)
		_:
			if id.ends_with("Star"):
				await _select_shape(id, "Star", "chart", SHAPES.size())
			elif id.ends_with("Marker"):
				await _select_shape(id, "Marker", "trail", 3)


func _listen() -> void:
	var story := Globals.stars
	await Lines.say("reem_star_bat", true)
	if await Choices.ask_two(Globals.notebook.labels["star_listen"], Globals.notebook.labels["star_rush"]):
		story["listened"] = true
		Globals.friend_cards["observatory_bat"] = true
		if story.get("rushed", false):
			story["rushed"] = false
			Globals.heal()
		else:
			Globals.bloom()
		await Lines.say("reem_star_listen", true)
	else:
		if not story.get("rushed", false):
			story["rushed"] = true
			Globals.wilt()
		await Lines.say("reem_star_rush", true)
	E.save_game(1)


func _fly(owl: PopochiuClickable) -> void:
	await Lines.say("reem_star_fly", true)
	Globals.stars["flew"] = true
	Globals.friend_cards["observatory_owl"] = true
	G.block()
	var lift := create_tween().set_parallel().set_trans(Tween.TRANS_SINE)
	lift.tween_property(owl, "position", owl.position + Vector2(200, -230), 0.85)
	lift.tween_property(C.player, "position", C.player.position + Vector2(200, -230), 0.85)
	await lift.finished
	G.unblock()
	await R.goto_room("ObservatoryDome")


func _select_shape(id: String, suffix: String, key: String, count: int) -> void:
	var story := Globals.stars
	var index: int = story.get(key, 0)
	if id != SHAPES[index] + suffix:
		await Lines.say("reem_star_retry", true)
		return
	story[key] = index + 1
	_sync_chart()
	if index + 1 == count:
		if key == "chart":
			Globals.bloom()
			await Lines.say("reem_star_connected", true)
		else:
			story["safe"] = true
			Globals.bloom()
			G.block()
			var caravan := get_prop("Caravan")
			var walk := create_tween()
			walk.tween_property(caravan, "position", $Shelter.position, 1.25)
			await walk.finished
			G.unblock()
			await Lines.say("reem_star_safe", true)
	E.save_game(1)


func _sync_chart() -> void:
	var story := Globals.stars
	if script_name == "ObservatoryDome":
		$Example.visible = story.get("chart_open", false)
		var thread: Line2D = $ChartLine
		thread.clear_points()
		for index in SHAPES.size():
			var star := get_prop(SHAPES[index] + "Star")
			var accepted: bool = index < story.get("chart", 0)
			star.modulate = Color("#ffe19a") if accepted else Color.WHITE
			if accepted:
				thread.add_point(star.position + star.get_node("Sprite2D").position)
	elif script_name == "StarRidge":
		$Example.visible = story.get("guiding", false)
		for index in 3:
			get_prop(SHAPES[index] + "Marker").modulate = Color("#ffe19a") if index < story.get("trail", 0) else Color.WHITE
		if story.get("safe", false):
			get_prop("Caravan").position = $Shelter.position
