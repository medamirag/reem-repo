@tool
class_name WanderingBee
extends Node2D
## One of the two small bees in BigTree (game_spec.md 3): flies slowly around the hives in a
## lazy loop while its wings flap fast. Purely decorative: not clickable. Its $Body sprite has a
## $Body/Wings child.

## Half-size of the loop it flies, in pixels (x = left/right, y = up/down).
@export var wander := Vector2(120, 45)
## Seconds for one full loop.
@export var loop_time := 7.0
## Wing beats per second (game_spec.md 3: 10 to 15).
@export var flap_hz := 13.0
## Start somewhere else in the loop than the other bee.
@export var phase := 0.0

var _time := 0.0
var _home := Vector2.ZERO
var _last_x := 0.0

@onready var _body: Sprite2D = $Body
@onready var _wings: Sprite2D = $Body/Wings
@onready var _wings_scale: Vector2 = _wings.scale


func _ready() -> void:
	_home = position


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return

	_time += delta
	var t := _time / loop_time * TAU + phase
	position = _home + Vector2(sin(t) * wander.x, sin(t * 2.0) * wander.y)
	# Face the way it is flying (the pictures look right).
	var moving_left := position.x < _last_x
	_body.flip_h = moving_left
	_wings.flip_h = moving_left
	_last_x = position.x
	_wings.scale.y = _wings_scale.y * (0.55 + 0.45 * absf(sin(_time * PI * flap_hz)))
