@tool
class_name NpcCharacter
extends PopochiuCharacter
## Shared behavior of the characters Reem talks to (Jad, Thaaloob, Shahd), game_spec.md 3:
## - a small, soft scale pulse and a moving mouth while speaking,
## - clicks are handled by the room script (ReemRoom._on_object_clicked), like props.
##
## To make a character look the other way, give its Sprite2D a negative scale.x (not flip_h:
## Popochiu resets flip_h when the character is added to a room).

const TALK_PULSE_SCALE := 1.04
const TALK_PULSE_TIME := 0.18

## The node that pulses while talking (the character's picture).
@export var pulse_node_path: NodePath = ^"Sprite2D"

var _talk_tween: Tween
var _pulse_base_scale := Vector2.ONE


#region Virtual ####################################################################################
func _on_click() -> void:
	await RoomClicks.clicked(self)


func _on_double_click() -> void:
	await RoomClicks.clicked(self)


func _on_right_click() -> void:
	await RoomClicks.clicked(self)


func _on_middle_click() -> void:
	pass


func _on_item_used(item: PopochiuInventoryItem) -> void:
	await RoomClicks.item_used(self, item)


func _play_talk() -> void:
	_start_talk_pulse()
	_set_mouth_talking(true)


func _play_idle() -> void:
	_stop_talk_pulse()
	_set_mouth_talking(false)


## The mouth (a TalkingMouth under Sprite2D) opens and closes while speaking.
func _set_mouth_talking(value: bool) -> void:
	var mouth := get_node_or_null("Sprite2D/Mouth") as TalkingMouth
	if mouth:
		mouth.talking = value


func _play_walk(_target_pos: Vector2) -> void:
	pass


func _play_grab() -> void:
	grab_done.emit.call_deferred()


#endregion

#region Private ####################################################################################
func _start_talk_pulse() -> void:
	var node := get_node_or_null(pulse_node_path) as Node2D
	if node == null:
		return
	if is_instance_valid(_talk_tween) and _talk_tween.is_running():
		return

	_pulse_base_scale = node.scale
	_talk_tween = create_tween().set_loops()
	_talk_tween.tween_property(node, "scale", _pulse_base_scale * TALK_PULSE_SCALE, TALK_PULSE_TIME) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	_talk_tween.tween_property(node, "scale", _pulse_base_scale, TALK_PULSE_TIME) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


func _stop_talk_pulse() -> void:
	if not is_instance_valid(_talk_tween):
		return

	_talk_tween.kill()
	_talk_tween = null
	var node := get_node_or_null(pulse_node_path) as Node2D
	if node:
		node.scale = _pulse_base_scale


#endregion
