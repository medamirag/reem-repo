@tool
extends NpcCharacter
## Shahd the bee (game_spec.md 3): hovers near the hives in BigTree. Her wings flap fast (about
## 12 times a second, by squashing them), her body bobs slowly up and down, and she pulses
## softly while speaking (NpcCharacter). About 1/5 of Reem's height.

const Data := preload("character_shahd_state.gd")
## Wing beats per second (game_spec.md 3: 10 to 15).
const FLAP_HZ := 12.0
## How far the body bobs up and down, in pixels, and how many times per second.
const BOB_HEIGHT := 10.0
const BOB_HZ := 0.8

var state: Data = load("res://game/characters/shahd/character_shahd.tres")
var _time := 0.0

@onready var _wings: Sprite2D = $Sprite2D/Wings
@onready var _sprite: Sprite2D = $Sprite2D
@onready var _wings_base_scale: Vector2 = _wings.scale
@onready var _sprite_base_y: float = _sprite.position.y


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return

	_time += delta
	_wings.scale.y = _wings_base_scale.y * (0.55 + 0.45 * absf(sin(_time * PI * FLAP_HZ)))
	_sprite.position.y = _sprite_base_y + sin(_time * TAU * BOB_HZ) * BOB_HEIGHT
