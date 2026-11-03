@tool
extends PopochiuRoom
## Throw-away test room: it only exists to prove that Arabic text shows correctly
## (connected letters, right to left) in Popochiu's dialogue text and in a choice button.
## It is not part of game_spec.md and will be deleted once the real rooms are built.

const Data := preload('room_test_arabic_state.gd')

## Where Reem stands, as a fraction of the screen (x from left, y from top). Easy to change.
@export var reem_screen_position := Vector2(0.20, 0.88)
## How tall Reem is on screen, as a fraction of the screen height (game_spec.md 3: about 42%).
@export var reem_height_ratio := 0.42

var state: Data = load("res://game/rooms/test_arabic/room_test_arabic.tres")

@onready var _background: Sprite2D = $Background


#region Virtual ####################################################################################
func _on_room_entered() -> void:
	_fit_background()
	_place_reem()


func _on_room_transition_finished() -> void:
	await Lines.say("reem_s1_002")

	# The two buttons use the text of two real lines, read straight from lines.json,
	# so no Arabic is ever retyped here.
	var option: PopochiuDialogOption = await D.show_inline_dialog([
		Lines.get_text("reem_s1_007a"),
		Lines.get_text("reem_s1_007b"),
	])

	match option.id:
		"0":
			await Lines.say("reem_s1_007a")
		"1":
			await Lines.say("reem_s1_007b")


func _on_room_exited() -> void:
	pass


func _on_restore_from_savegame() -> void:
	pass


#endregion

#region Private ####################################################################################
# Scales the background so it covers the whole screen without stretching it.
func _fit_background() -> void:
	if not is_instance_valid(_background) or _background.texture == null:
		return

	var texture_size := _background.texture.get_size()
	_background.scale = Vector2.ONE * maxf(width / texture_size.x, height / texture_size.y)


# Puts Reem on the floor at the size asked for in game_spec.md, whatever the image size is.
func _place_reem() -> void:
	var reem := C.get_character("Reem")

	if reem == null:
		return

	reem.position = Vector2(width * reem_screen_position.x, height * reem_screen_position.y)

	var sprite := reem.get_node_or_null("Sprite2D") as Sprite2D

	if sprite == null or sprite.texture == null:
		return

	var texture_height := sprite.texture.get_size().y
	sprite.scale = Vector2.ONE * (height * reem_height_ratio / texture_height)
	# Move the image up by half its height so Reem's feet sit on the character's position.
	sprite.offset = Vector2(0, -texture_height / 2.0)


#endregion
