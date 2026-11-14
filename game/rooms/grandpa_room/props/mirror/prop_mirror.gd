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
## Where the mirror lands, in the room's local coordinates: on the floor just below the wall
## peg, leaning against the wall (user's request). A starting point: nudge it in the Inspector.
@export var fall_target := Vector2(800, 790)
## How big the cracked mirror is once it has fallen, compared with the mirror on the peg
## (user's request: about 20% smaller).
@export var fallen_scale_ratio := 0.8
## Reem stops beside the frame, clear of its fallen footprint.
@export var reem_approach_x := 570.0

# The mirror's size on the peg, read from the scene when the room loads. A constant rather
# than a plain variable on purpose: Popochiu saves and restores a prop's script variables when
# Reem leaves and re-enters a room, and this one must never change.
@onready var _SCALE_ON_PEG: Vector2 = scale


#region Virtual ####################################################################################
func _on_click() -> void:
	if Globals.mirror_broken:
		E.command_fallback()
		return

	await C.player.walk(Vector2(reem_approach_x, C.player.global_position.y))
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
	fall.tween_property(self, "scale", _SCALE_ON_PEG * fallen_scale_ratio, fall_time)
	await fall.finished

	A.sfx_mirror_crack.play()
	show_fallen()


## Shows the mirror already fallen and cracked at [member fall_target], without animation. Used
## at the end of [method break_mirror] and when Reem comes back into the room later.
func show_fallen() -> void:
	texture = CRACKED_TEXTURE
	rotation_degrees = 0.0
	scale = _SCALE_ON_PEG * fallen_scale_ratio
	# Sort from the floor contact, while preserving the painted frame position.
	var half_height := CRACKED_TEXTURE.get_height() * .5
	position = fall_target + Vector2(0, half_height * scale.y)
	$Sprite2D.position.y = -half_height
	$InteractionPolygon.position.y = -half_height


#endregion
