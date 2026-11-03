@tool
extends PopochiuCharacter
# You can use `E.queue([])` in any of the methods in this script to trigger a sequence of events.
# Use `await E.queue([])` to pause execution until the sequence completes.
#
# game_spec.md section 3 ("simple version", before the skeletal rig): while walking, a gentle
# up-down bob (~6 px, ~4 times a second); while speaking, a small soft scale pulse. Both are done
# here with plain tweens on the Sprite2D, since there is no walk/talk animation yet.

const Data := preload('character_reem_state.gd')

const BOB_HEIGHT := 6.0
const BOB_HZ := 4.0
const TALK_PULSE_SCALE := 1.04
const TALK_PULSE_TIME := 0.18
const GRAB_TIME := 0.6

var state: Data = load("res://game/characters/reem/character_reem.tres")

var _sprite: Sprite2D
var _sprite_base_offset_y := 0.0
var _bob_tween: Tween
var _talk_tween: Tween
## Name of the footstep AudioCueSound currently looping, so it can be stopped again.
var _footstep_cue := ""


#region Godot #######################################################################################
func _ready() -> void:
	super()

	if Engine.is_editor_hint():
		return

	_sprite = get_node_or_null("Sprite2D")

	if is_instance_valid(_sprite):
		_sprite_base_offset_y = _sprite.offset.y


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
	_start_talk_pulse()


func _play_idle() -> void:
	super()
	_stop_talk_pulse()


# Popochiu's grab() plays a "grab" animation and waits for `grab_done`, which only an
# AnimationPlayer would emit. Reem has no such animation, so without this override grab()
# waits forever and the basket click freezes. Simple version: a short bend-down (squash)
# lasting about GRAB_TIME seconds (game_spec.md 3: pickup pose for about 0.6 s), then done.
# reem_pickup.png is not used yet: it has a dark glowing background and an acorn baked in.
func _play_grab() -> void:
	if not is_instance_valid(_sprite):
		grab_done.emit.call_deferred()
		return

	var base_scale := _sprite.scale
	var bent := Vector2(base_scale.x * 1.04, base_scale.y * 0.9)
	var tween := create_tween()
	tween.tween_property(_sprite, "scale", bent, GRAB_TIME / 2.0)
	tween.tween_property(_sprite, "scale", base_scale, GRAB_TIME / 2.0)
	await tween.finished
	grab_done.emit()


# game_spec.md 4.6: footsteps while walking (sfx_steps_tile on tile floors, sfx_steps_grass
# everywhere else), looping while walking, stopping when stopped. Each room says which one it
# wants through its own `footstep_cue` export (room_template default is "sfx_steps_grass").
func _on_movement_started() -> void:
	_start_bob()

	_footstep_cue = "sfx_steps_grass"
	if is_instance_valid(R.current) and "footstep_cue" in R.current:
		_footstep_cue = R.current.footstep_cue

	var cue: PopochiuAudioCue = A.get(_footstep_cue)
	if cue:
		cue.play()


func _on_movement_ended() -> void:
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


func _start_talk_pulse() -> void:
	if is_instance_valid(_talk_tween) and _talk_tween.is_running():
		return

	var base_scale := default_scale

	_talk_tween = create_tween().set_loops()
	_talk_tween.tween_property(
		self, "scale", base_scale * TALK_PULSE_SCALE, TALK_PULSE_TIME
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	_talk_tween.tween_property(
		self, "scale", base_scale, TALK_PULSE_TIME
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


func _stop_talk_pulse() -> void:
	if is_instance_valid(_talk_tween):
		_talk_tween.kill()

	scale = default_scale


#endregion
