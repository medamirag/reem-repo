@tool
extends ReemRoom

@export var state: PopochiuRoomData


func _on_room_started() -> void:
	if not Globals.tree_day.get("seen", false):
		Globals.tree_day["seen"] = true
		await Lines.say("reem_tree_day_arrive", true)


func _setup_room() -> void:
	$NewLeaves.visible = Globals.tree_day.get("watered", false)


func _on_restore_from_savegame() -> void:
	super()
	_setup_room()


func has_action(obj: PopochiuClickable) -> bool:
	match obj.script_name:
		"Arnoob": return not Globals.tree_day.get("watered", false)
		"Seedling": return Globals.tree_day.get("offered", false) and not Globals.tree_day.get("watered", false)
	return super(obj)


func _on_object_clicked(obj: PopochiuClickable) -> void:
	if not has_action(obj):
		return
	var story := Globals.tree_day
	match obj.script_name:
		"ExitLeft":
			await leave_through(obj, "Yard")
		"Arnoob":
			await Lines.say("reem_tree_day_offer", true)
			if await Choices.ask_two(Globals.notebook.labels["tree_water"], Globals.notebook.labels["tree_keep"]):
				story["offered"] = true
				await Lines.say("reem_tree_day_water", true)
			else:
				story["offered"] = false
				if not story.get("kept", false):
					story["kept"] = true
					Globals.wilt()
				await Lines.say("reem_tree_day_wait", true)
			E.save_game(1)
		"Seedling":
			ReemEffects.burst(self, obj.position, "water")
			story["watered"] = true
			Globals.friend_cards["tree_day"] = true
			if story.get("kept", false):
				story["kept"] = false
				Globals.heal()
			else:
				Globals.bloom()
			_setup_room()
			await Lines.say("reem_tree_day_done", true)
			E.save_game(1)
