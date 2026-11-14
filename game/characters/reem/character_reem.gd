@tool
extends PopochiuCharacter
# You can use `E.queue([])` in any of the methods in this script to trigger a sequence of events.
# Use `await E.queue([])` to pause execution until the sequence completes.
#
# Reem uses one persistent cutout for walking, idle, dialogue and gestures.
# Original sprite remains a hidden size/facing reference for Popochiu.

const Data := preload('character_reem_state.gd')
const CUTOUT_SCENE := preload('res://game/characters/reem/reem_cutout.tscn')

const BOB_HEIGHT := 0.0  # user: no up-and-down movement
const BOB_HZ := 4.0
const GRAB_TIME := 0.6

## Persistent procedural cutout. Disable only for comparison with the original.
@export var use_walk_rig := true
@export_range(60.0, 90.0) var walk_stride := 90.0
@export_range(0.0, 10.0) var walk_bob := 4.0
@export_range(0.0, 6.0) var idle_breathing := 2.5

var state: Data = load("res://game/characters/reem/character_reem.tres")

var _sprite: Sprite2D
var _sprite_base_offset_y := 0.0
var _bob_tween: Tween
## Name of the footstep AudioCueSound currently looping, so it can be stopped again.
var _footstep_cue := ""
var _rig: ReemWalkRig


#region Godot #######################################################################################
func _ready() -> void:
	super()

	if Engine.is_editor_hint():
		return

	_sprite = get_node_or_null("Sprite2D")

	if is_instance_valid(_sprite):
		_sprite_base_offset_y = _sprite.offset.y

	if use_walk_rig:
		_rig = CUTOUT_SCENE.instantiate() as ReemWalkRig
		_rig.name = "WalkRig"
		_rig.stride = walk_stride
		_rig.bob_height = walk_bob
		_rig.breathing = idle_breathing
		_rig.show()
		add_child(_rig)
		# Popochiu frees a character's children that it does not own when Reem leaves a room
		# (PopochiuRoom.exit_room), so the rig must belong to Reem to survive room changes.
		_rig.owner = self
		_sprite.hide()
		_rig.match_picture(_sprite)




#endregion

#region Virtual ####################################################################################
# Called when the room where this character is located has finished being added to the scene tree.
func _on_room_set() -> void:
	pass


# Called when the character is clicked
func _on_click() -> void:
	E.command_fallback()


# Called when the character is double-clicked
func _on_double_click() -> void:
	E.command_fallback()


# Called when the character is right-clicked
func _on_right_click() -> void:
	E.command_fallback()


# Called when the character is middle clicked
func _on_middle_click() -> void:
	E.command_fallback()


# Called when the character is clicked while an inventory item is selected
func _on_item_used(_item: PopochiuInventoryItem) -> void:
	E.command_fallback()


func _play_talk() -> void:
	super()
	_set_mouth_talking(true)


func _play_idle() -> void:
	super()
	_set_mouth_talking(false)


func _set_mouth_talking(value: bool) -> void:
	if is_instance_valid(_rig):
		_rig.set_talking(value)
	var mouth := get_node_or_null("Sprite2D/Mouth") as TalkingMouth
	if mouth:
		mouth.talking = value


# User request: Reem only ever moves left and right, never up or down the screen. Every walk
# (to a prop, a character, an exit) keeps her on her current line.
func walk(target_pos: Vector2) -> void:
	await super(Vector2(target_pos.x, global_position.y))


# Popochiu's grab() plays a "grab" animation and waits for `grab_done`, which only an
# AnimationPlayer would emit. Reem has no such animation, so without this override grab()
# waits forever and the basket click freezes. Simple version: a short bend-down (squash)
# lasting about GRAB_TIME seconds (game_spec.md 3: pickup pose for about 0.6 s), then done.
# reem_pickup.png is not used yet: it has a dark glowing background and an acorn baked in.
func _play_grab() -> void:
	if not is_instance_valid(_sprite):
		grab_done.emit.call_deferred()
		return

	var visual: Node2D = _rig._body if is_instance_valid(_rig) else _sprite
	var base_scale := visual.scale
	var bent := Vector2(base_scale.x * 1.04, base_scale.y * 0.9)
	var tween := create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(visual, "scale", bent, GRAB_TIME / 2.0)
	tween.tween_property(visual, "scale", base_scale, GRAB_TIME / 2.0)
	await tween.finished
	grab_done.emit()


## Reaching up for something above her head (the basket under the mirror): she stretches up a
## little for about GRAB_TIME seconds, then stands normally again.
func reach_up() -> void:
	if not is_instance_valid(_sprite):
		await get_tree().process_frame
		return

	var visual: Node2D = _rig._body if is_instance_valid(_rig) else _sprite
	var base_scale := visual.scale
	var stretched := Vector2(base_scale.x * 0.97, base_scale.y * 1.08)
	var tween := create_tween()
	tween.tween_property(visual, "scale", stretched, GRAB_TIME / 2.0) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(visual, "scale", base_scale, GRAB_TIME / 2.0) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	await tween.finished


# game_spec.md 4.6: footsteps while walking (sfx_steps_tile on tile floors, sfx_steps_grass
# everywhere else), looping while walking, stopping when stopped. Each room says which one it
# wants through its own `footstep_cue` export (room_template default is "sfx_steps_grass").
func _on_movement_started() -> void:
	if is_instance_valid(_rig):
		_rig.match_picture(_sprite)
		_sprite.hide()
		_rig.show()
		_rig.set_walking(true)
	else:
		_start_bob()

	_footstep_cue = "sfx_steps_grass"
	if is_instance_valid(R.current) and "footstep_cue" in R.current:
		_footstep_cue = R.current.footstep_cue

	var cue: PopochiuAudioCue = A.get(_footstep_cue)
	if cue:
		cue.play()


func _on_movement_ended() -> void:
	if is_instance_valid(_rig):
		_rig.set_walking(false)
		_rig.show()
		_sprite.hide()
	else:
		_stop_bob()

	var cue: PopochiuAudioCue = A.get(_footstep_cue)
	if cue:
		cue.stop()


#endregion

#region Private ####################################################################################
func _start_bob() -> void:
	if not is_instance_valid(_sprite):
		return

	if is_instance_valid(_bob_tween) and _bob_tween.is_running():
		return

	var half_period := 1.0 / BOB_HZ / 2.0

	_bob_tween = create_tween().set_loops()
	_bob_tween.tween_property(
		_sprite, "offset:y", _sprite_base_offset_y - BOB_HEIGHT, half_period
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	_bob_tween.tween_property(
		_sprite, "offset:y", _sprite_base_offset_y, half_period
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


func _stop_bob() -> void:
	if is_instance_valid(_bob_tween):
		_bob_tween.kill()

	if is_instance_valid(_sprite):
		_sprite.offset.y = _sprite_base_offset_y



#endregion


func animate_line(tone: String, text: String) -> void:
	if not is_instance_valid(_rig):
		return
	var mood := "happy"
	if tone.to_lower().contains("sad") or tone.to_lower().contains("worried") or tone.to_lower().contains("sorry"):
		mood = "sad"
	elif tone.to_lower().contains("surpris") or tone.to_lower().contains("amazed"):
		mood = "surprised"
	_rig.set_expression(mood)
	if text.contains("السَّلَامُ") or text.contains("السَّلَامُ") or tone.to_lower().contains("greet"):
		_rig.wave()
