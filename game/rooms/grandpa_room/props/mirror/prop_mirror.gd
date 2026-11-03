@tool
extends PopochiuProp
## Grandpa's mirror, on the wall peg. game_spec.md GrandpaRoom:
## - Clicked before it falls: says reem_s1_003.
## - break_mirror() is called by BasketProp once the basket is picked up: the mirror wobbles,
##   falls, cracks (sfx_mirror_crack) and swaps to the cracked picture.

const CRACKED_TEXTURE := preload("res://assets/cut/mirror_states/mirror_cracked.tres")

## How far the mirror tips side to side before it falls, in degrees.
@export var wobble_degrees := 6.0
@export var wobble_time := 0.5
@export var fall_time := 0.35
## Where the mirror lands on the floor, in the room's local coordinates. A starting point —
## nudge it in the editor so it looks right against the background.
@export var fall_target := Vector2(620, 910)


#region Virtual ####################################################################################
func _on_click() -> void:
	if Globals.mirror_broken:
		E.command_fallback()
		return

	await C.player.face_clicked()
	await Lines.say("reem_s1_003")


func _on_double_click() -> void:
	E.command_fallback()


func _on_right_click() -> void:
	E.command_fallback()


func _on_middle_click() -> void:
	E.command_fallback()


func _on_item_used(_item: PopochiuInventoryItem) -> void:
	E.command_fallback()


func _on_linked_item_removed() -> void:
	pass


func _on_linked_item_discarded() -> void:
	pass


func _on_movement_started() -> void:
	pass


func _on_movement_ended() -> void:
	pass


#endregion

#region Public #####################################################################################
## Wobbles the mirror on its peg, lets it fall to [member fall_target], plays the crack sound,
## and swaps to the cracked picture.
func break_mirror() -> void:
	var half_wobble := wobble_time / 4.0

	var wobble := create_tween()
	for i in 2:
		wobble.tween_property(self, "rotation_degrees", wobble_degrees, half_wobble)
		wobble.tween_property(self, "rotation_degrees", -wobble_degrees, half_wobble)
	wobble.tween_property(self, "rotation_degrees", 0.0, half_wobble)
	await wobble.finished

	var fall := create_tween()
	fall.set_parallel(true)
	fall.tween_property(self, "position", fall_target, fall_time) \
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	fall.tween_property(self, "rotation_degrees", 18.0, fall_time)
	await fall.finished

	A.sfx_mirror_crack.play()
	texture = CRACKED_TEXTURE
	rotation_degrees = 0.0


#endregion
