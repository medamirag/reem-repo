extends Node
## Makes Shahd hover (game_spec.md 3): her wings flap fast and her body bobs slowly. A separate
## child node because Popochiu turns off frame-by-frame processing on characters themselves.

## Wing beats per second (game_spec.md 3: 10 to 15).
const FLAP_HZ := 12.0
## How far the body bobs up and down, in pixels, and how many times per second.
const BOB_HEIGHT := 10.0
const BOB_HZ := 0.8

var _time := 0.0
var _sprite: Sprite2D
var _wings: Sprite2D
var _wings_base_scale := Vector2.ONE
var _sprite_base_y := 0.0


func _ready() -> void:
	_sprite = get_parent().get_node_or_null("Sprite2D") as Sprite2D
	if _sprite:
		_wings = _sprite.get_node_or_null("Wings") as Sprite2D
		_sprite_base_y = _sprite.position.y
	if _wings:
		_wings_base_scale = _wings.scale


func _process(delta: float) -> void:
	if _sprite == null or _wings == null:
		return

	_time += delta
	_wings.scale.y = _wings_base_scale.y * (0.55 + 0.45 * absf(sin(_time * PI * FLAP_HZ)))
	_sprite.position.y = _sprite_base_y + sin(_time * TAU * BOB_HZ) * BOB_HEIGHT
