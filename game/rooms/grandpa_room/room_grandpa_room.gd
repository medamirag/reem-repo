@tool
extends PopochiuRoom
## Station 1, room 1: GrandpaRoom (game_spec.md). Reem wakes up, notices the mirror, picks up
## the basket (which makes the mirror fall and crack), and makes Choice 1.

const Data := preload('room_grandpa_room_state.gd')

## Starting point for Reem, as a fraction of the screen (game_spec.md: x 0.20, y 0.88). A
## starting point — adjust freely.
@export var reem_screen_position := Vector2(0.20, 0.88)
## Reem's height on screen, as a fraction of the screen height (game_spec.md 3: about 42%).
@export var reem_height_ratio := 0.42
## This room's floor is terracotta tile, so footsteps use sfx_steps_tile (game_spec.md 4.6).
@export var footstep_cue := "sfx_steps_tile"

var state: Data = load("res://game/rooms/grandpa_room/room_grandpa_room.tres")

@onready var _background: Sprite2D = $Background
## game_spec.md 5: the foreground layer (fg1_room_fg) drawn on top of everything, not clickable.
@onready var _foreground: Sprite2D = $Foreground


#region Virtual ####################################################################################
func _on_room_entered() -> void:
	RoomHelpers.fit_background(_background, width, height)
	RoomHelpers.fit_background(_foreground, width, height)
	RoomHelpers.place_player(width, height, reem_screen_position, reem_height_ratio)
	Globals.ensure_heart_tree()
	Globals.play_ambience("amb_farm")


func _on_room_transition_finished() -> void:
	if state.visited_times != 1:
		return

	await Lines.say("reem_s1_001")
	await Lines.say("reem_s1_002")

	# Addition on top of game_spec.md: Reem looks up at the mirror before it ever breaks, so
	# the child knows it matters.
	var mirror := get_prop("Mirror")
	if mirror:
		C.player.face_direction(mirror.global_position)

	await Lines.say("reem_s1_003")


func _on_room_exited() -> void:
	pass


func _on_restore_from_savegame() -> void:
	pass


#endregion
