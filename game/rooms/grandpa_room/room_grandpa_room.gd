@tool
extends ReemRoom
## Station 1, room 1: GrandpaRoom (game_spec.md). Reem wakes up, notices the mirror, picks up
## the basket (which makes the mirror fall and crack), and makes Choice 1. The blue door leads
## to the Yard.
##
## Shared behavior (background/foreground fitting, where Reem appears, heart tree, ambience,
## footsteps) comes from ReemRoom. The Mirror, BasketProp and Door have their own scripts.

const Data := preload('room_grandpa_room_state.gd')

var state: Data = load("res://game/rooms/grandpa_room/room_grandpa_room.tres")


#region Virtual ####################################################################################
func _setup_room() -> void:
	# Coming back from the Yard: put things the way the child left them.
	var basket := get_prop("BasketProp")
	if basket and Globals.basket_taken:
		basket.hide()

	var mirror := get_prop("Mirror")
	if mirror and Globals.mirror_broken:
		mirror.call("show_fallen")
		if Globals.mirror_hidden:
			mirror.hide()


func _on_room_started() -> void:
	if state.visited_times != 1:
		return

	await Lines.say("reem_s1_001")
	await Lines.say("reem_s1_002")

	# Addition on top of game_spec.md: Reem looks up at the mirror before it ever breaks, so
	# the child knows it matters.
	var mirror := get_prop("Mirror")
	if mirror:
		RoomHelpers.face(C.player, mirror.global_position.x < C.player.global_position.x)

	await Lines.say("reem_s1_003")


## The door only leads out once Choice 1 is answered (see hotspot_door.gd).
func is_exit_open(exit_name: String) -> bool:
	if exit_name == "Door":
		return Globals.chose_truth or Globals.mirror_hidden
	return true


#endregion
