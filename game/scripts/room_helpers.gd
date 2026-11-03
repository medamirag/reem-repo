class_name RoomHelpers
extends RefCounted
## Small bits every room repeats: fitting its background to the screen without stretching it,
## and placing Reem at her starting spot and size. Kept in one place so a fix here fixes every
## room instead of being copy-pasted into each one.


## Scales `background` so it covers `room_width` x `room_height` without stretching (keeps the
## image's own aspect ratio, like CSS `background-size: cover`).
static func fit_background(background: Sprite2D, room_width: float, room_height: float) -> void:
	if not is_instance_valid(background) or background.texture == null:
		return

	var texture_size := background.texture.get_size()
	background.scale = Vector2.ONE * maxf(room_width / texture_size.x, room_height / texture_size.y)


## Puts the player character at `screen_position` (a fraction of the screen, x from left, y from
## top) and scales her sprite so she is `height_ratio` of the screen's height tall, feet at her
## position (game_spec.md 3: "Height on screen: about 42% of the screen height, feet on the
## path.").
static func place_player(
	room_width: float, room_height: float, screen_position: Vector2, height_ratio: float
) -> void:
	if not is_instance_valid(C.player):
		return

	C.player.position = Vector2(room_width * screen_position.x, room_height * screen_position.y)

	var sprite := C.player.get_node_or_null("Sprite2D") as Sprite2D
	if sprite == null or sprite.texture == null:
		return

	var texture_height := sprite.texture.get_size().y
	sprite.scale = Vector2.ONE * (room_height * height_ratio / texture_height)
	sprite.offset = Vector2(0, -texture_height / 2.0)


## Turns `character` to look left (`look_left` true) or right, the same way Popochiu flips a
## character when it walks (PopochiuCharacter._flip_left_right, which respects flips_when).
static func face(character: PopochiuCharacter, look_left: bool) -> void:
	if not is_instance_valid(character):
		return

	character._flip_left_right(look_left, not look_left)
	character.face_direction(character.global_position + (Vector2.LEFT if look_left else Vector2.RIGHT))
