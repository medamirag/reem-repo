@tool
extends ReemRoom

const Data := preload("room_hill_slope_state.gd")
var state: Data = load("res://game/rooms/hill_slope/room_hill_slope.tres")

func _on_room_started() -> void:
	if not Globals.hill.get("introduced", false):
		Globals.hill["introduced"] = true
		await Lines.say("reem_hill_arrive")

func _setup_room() -> void:
	_sync_display()
	$SnowLabel.text = Globals.notebook.labels["snow_name"]
	$SnowLabel.theme = ArabicText.get_theme()
	ArabicText.make_rtl($SnowLabel)
	$SnowLabel.visible = is_exit_open("ExitSnow")

func _on_restore_from_savegame() -> void:
	super()
	_sync_display()

func _sync_display() -> void:
	$Props/Display/Parts.visible = Globals.hill.get("feathers", false)
	$Props/HillFeather.visible = Globals.hill.get("feathers", false)

func is_exit_open(exit_name: String) -> bool:
	if exit_name == "ExitSnow":
		return Globals.unlocked_packs.get("4", false)
	return exit_name == "ExitLeft" or Globals.hill.get("feathers", false)

func has_action(obj: PopochiuClickable) -> bool:
	match obj.script_name:
		"Tawoos": return not Globals.hill.get("feathers", false)
		"Display": return Globals.hill.get("ready", false) and not Globals.hill.get("feathers", false)
		"HillFeather": return false
	return super(obj)

func _on_object_clicked(obj: PopochiuClickable) -> void:
	if not has_action(obj):
		return
	match obj.script_name:
		"ExitLeft": await leave_through(obj, "HoneyOrchard")
		"ExitSnow":
			await Lines.say("reem_snow_offer", true)
			if await Choices.ask_two(Globals.notebook.labels["snow_go"], Globals.notebook.labels["snow_stay"]):
				await leave_through(obj, "SnowEdge")
		"ExitRight": await leave_through(obj, "NarrowPass" if R.rooms_states.has("NarrowPass") else "End")
		"Tawoos": await _talk_to_tawoos()
		"Display": await _show_display()

func _talk_to_tawoos() -> void:
	if Globals.hill.get("ready", false):
		await Lines.say("reem_hill_show")
		return
	await Lines.say("reem_hill_proud")
	if await Choices.ask_two(Globals.notebook.labels["hill_together"], Globals.notebook.labels["hill_flatter"]):
		Globals.hill["ready"] = true
		await Lines.say("reem_hill_show")
	else:
		if not Globals.hill.get("flattered", false):
			Globals.hill["flattered"] = true
			Globals.wilt()
		await Lines.say("reem_hill_flatter")

func _show_display() -> void:
	Globals.hill["feathers"] = true
	Globals.friend_cards["tawoos"] = true
	if Globals.hill.get("flattered", false):
		Globals.hill["flattered"] = false
		Globals.heal()
	else:
		Globals.bloom()
	_sync_display()
	await Lines.say("reem_hill_gift")
