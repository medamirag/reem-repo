@tool
extends ReemRoom
## Station 1, room 3: Gate (game_spec.md). The farm gate on the way to the meadow.
## On first entering after the briefing, Reem says a prayer for leaving home and Grandpa calls
## after her from off screen. Exits: left → Yard; right → MeadowFork, only once briefed (before
## that, the click on the right exit is ignored).

const Data := preload('room_gate_state.gd')

var state: Data = load("res://game/rooms/gate/room_gate.tres")


#region Virtual ####################################################################################
func _setup_room() -> void:
	$StreamLabel.text = Globals.notebook.labels.get("stream_name", "")
	$StreamLabel.visible = Globals.briefed


func _on_room_started() -> void:
	if not Globals.briefed or Globals.gate_intro_done:
		return

	Globals.gate_intro_done = true
	await Lines.say("reem_s1_030")
	await Lines.say("jad_s1_031")  # off screen: shown in the narration box
	await Lines.say("reem_s1_032")


func _on_object_clicked(obj: PopochiuClickable) -> void:
	match obj.script_name:
		"ExitLeft":
			await leave_through(obj, "Yard")
		"ExitRight":
			if Globals.briefed:
				await leave_through(obj, "MeadowFork")
		"ExitStream":
			if Globals.briefed:
				await leave_through(obj, "Stream")


func is_exit_open(exit_name: String) -> bool:
	return exit_name not in ["ExitRight", "ExitStream"] or Globals.briefed


#endregion
