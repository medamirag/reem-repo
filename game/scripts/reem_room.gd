@tool
class_name ReemRoom
extends PopochiuRoom
## Shared base for every playable room of the game (Yard, Gate, MeadowFork, BigTree, FoxRock).
##
## What it does for every room, so each room script only has to describe its own story:
## - fits the background ($Background) and the foreground layer ($Foreground, drawn on top of
##   everything and not clickable) to the screen without stretching (game_spec.md 5),
## - puts Reem at the right spot depending on which room she came from, at the right size,
## - shows the heart tree, starts the room's ambience, sets the footstep sound,
## - sets the Notebook hint for this room,
## - forwards clicks from props, hotspots and characters that use RoomProp / RoomHotspot /
##   NpcCharacter to the room script's `_on_object_clicked()` and `_on_item_used_on()`.
##
## All positions are exported so they can be adjusted in the Inspector (CLAUDE.md rule 6).

## Where Reem appears when the room is entered from each neighbouring room, as fractions of the
## screen (x from the left, y from the top). Key = the room she comes from. "" = any other case
## (for example when this room is played directly from the editor with F6).
@export var entry_points := {"": Vector2(0.2, 0.86)}
## Reem's height on screen, as a fraction of the screen height (game_spec.md 3: about 42%).
@export var reem_height_ratio := 0.42
## Footstep sound for this room's ground (game_spec.md 4.6).
@export var footstep_cue := "sfx_steps_grass"
## Ambience that loops quietly in this room (game_spec.md 4.6).
@export var ambience_cue := "amb_farm"

## True once the room's start sequence (_on_room_started) has finished. Read by the automatic
## playtest (tools/playtest.gd).
var started := false


#region Virtual ####################################################################################
func _on_room_entered() -> void:
	var background := get_node_or_null("Background") as Sprite2D
	var foreground := get_node_or_null("Foreground") as Sprite2D
	RoomHelpers.fit_background(background, width, height)
	RoomHelpers.fit_background(foreground, width, height)

	if has_player:
		var from := ""
		if is_instance_valid(C.player):
			from = C.player.last_room
		var spot: Vector2 = entry_points.get(from, entry_points.get("", Vector2(0.2, 0.86)))
		RoomHelpers.place_player(width, height, spot, reem_height_ratio)
		# Coming in from the left side: look right, into the room; from the right: look left.
		RoomHelpers.face(C.player, spot.x >= 0.5)

	Globals.ensure_heart_tree()
	Globals.play_ambience(ambience_cue)
	Globals.notebook_hint = Callable()

	_setup_room()


func _on_room_transition_finished() -> void:
	await _on_room_started()
	started = true


func _on_room_exited() -> void:
	pass


func _on_restore_from_savegame() -> void:
	pass


## Override: put props in the state the global flags say (pictures, visibility, ...). Called
## every time the room is entered, before it becomes visible.
func _setup_room() -> void:
	pass


## Override: what happens once the room is visible (first-time lines, ...).
func _on_room_started() -> void:
	pass


## Override: a prop, hotspot or character in this room was clicked. `obj.script_name` says which.
func _on_object_clicked(_obj: PopochiuClickable) -> void:
	pass


## Override: the inventory item `item` was used on `obj`.
func _on_item_used_on(_obj: PopochiuClickable, _item: PopochiuInventoryItem) -> void:
	pass


#endregion

#region Public #####################################################################################
## Called by RoomProp / RoomHotspot / NpcCharacter. Not meant to be overridden.
func object_clicked(obj: PopochiuClickable) -> void:
	await _on_object_clicked(obj)


## Called by RoomProp / RoomHotspot / NpcCharacter. Not meant to be overridden.
func item_used_on(obj: PopochiuClickable, item: PopochiuInventoryItem) -> void:
	await _on_item_used_on(obj, item)


## Converts a fraction of the screen into room pixels.
func screen_point(fraction: Vector2) -> Vector2:
	return Vector2(width * fraction.x, height * fraction.y)


## Makes Reem walk to the exit hotspot `exit` and then goes to the room `target`. The GUI is
## blocked while she walks, so a second click cannot start a second trip.
func leave_through(exit: PopochiuClickable, target: String) -> void:
	G.block()
	await C.player.walk(exit.to_global(exit.walk_to_point))
	G.unblock()
	R.goto_room(target)


## Walks Reem in a straight line to `pos` (room pixels), ignoring the walkable area. Used for the
## few scripted walks that leave the path (for example across the flowers in MeadowFork). Plays
## the same bob and footsteps as a normal walk.
func scripted_walk(pos: Vector2, speed := 320.0) -> void:
	var player := C.player
	var distance := player.position.distance_to(pos)
	if distance < 1.0:
		return

	RoomHelpers.face(player, pos.x < player.position.x)

	player._on_movement_started()
	var tween := create_tween()
	tween.tween_property(player, "position", pos, distance / speed)
	await tween.finished
	player._on_movement_ended()
	player.idle()


#endregion
