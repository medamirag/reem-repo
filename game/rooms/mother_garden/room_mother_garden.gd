@tool
extends ReemRoom

@export var state: PopochiuRoomData


func _on_room_started() -> void:
	if not Globals.mother_day.get("seen", false):
		Globals.mother_day["seen"] = true
		await Lines.say("reem_mother_day_arrive", true)


func _setup_room() -> void:
	$FlowerCard.visible = Globals.mother_day.get("crafted", false)


func _on_restore_from_savegame() -> void:
	super()
	_setup_room()


func has_action(obj: PopochiuClickable) -> bool:
	match obj.script_name:
		"CraftTable": return not Globals.mother_day.get("crafted", false)
		"BlankCard": return Globals.mother_day.get("offered", false) and not Globals.mother_day.get("crafted", false)
	return super(obj)


func _on_object_clicked(obj: PopochiuClickable) -> void:
	if not has_action(obj):
		return
	var story := Globals.mother_day
	match obj.script_name:
		"ExitLeft":
			await leave_through(obj, "Yard")
		"CraftTable":
			await Lines.say("reem_mother_day_offer", true)
			if await Choices.ask_two(Globals.notebook.labels["mother_make"], Globals.notebook.labels["mother_keep"]):
				story["offered"] = true
				await Lines.say("reem_mother_day_make", true)
			else:
				story["offered"] = false
				if not story.get("kept", false):
					story["kept"] = true
					Globals.wilt()
				await Lines.say("reem_mother_day_wait", true)
			E.save_game(1)
		"BlankCard":
			story["crafted"] = true
			Globals.friend_cards["mother_day"] = true
			if story.get("kept", false):
				story["kept"] = false
				Globals.heal()
			else:
				Globals.bloom()
			_setup_room()
			await Lines.say("reem_mother_day_done", true)
			E.save_game(1)
