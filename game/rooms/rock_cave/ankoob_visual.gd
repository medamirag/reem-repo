extends Node2D

@export var leg: Texture2D
@export var body: Texture2D
@export var leg_region: Rect2
@export var body_region: Rect2

var _legs: Array[Sprite2D] = []
var _wiggle: Tween


func _ready() -> void:
	var leg_piece := AtlasTexture.new()
	leg_piece.atlas = leg
	leg_piece.region = leg_region
	for side: int in [-1, 1]:
		for index in 4:
			var limb := Sprite2D.new()
			limb.texture = leg_piece
			limb.position = Vector2(side * 29, -28 + index * 18)
			limb.offset = Vector2(side * (leg_region.size.x * 0.5 - 35.0), -leg_region.size.y * 0.19)
			limb.scale = Vector2.ONE * (72.0 / leg_region.size.x)
			limb.flip_h = side < 0
			limb.rotation = side * deg_to_rad(-48.0 + index * 32.0)
			add_child(limb)
			_legs.append(limb)
	var torso := Sprite2D.new()
	var body_piece := AtlasTexture.new()
	body_piece.atlas = body
	body_piece.region = body_region
	torso.texture = body_piece
	torso.scale = Vector2.ONE * (125.0 / body_region.size.y)
	add_child(torso)


func wiggle() -> void:
	if _wiggle != null and _wiggle.is_running():
		return
	_wiggle = create_tween()
	var start := position
	_wiggle.tween_method(_stride.bind(start), 0.0, TAU * 2.0, 0.6)


func _stride(phase: float, start: Vector2) -> void:
	position = start + Vector2(sin(phase) * 2.0, -absf(sin(phase)) * 3.0)
	for index in _legs.size():
		var side := -1 if index < 4 else 1
		_legs[index].rotation = side * deg_to_rad(-48.0 + (index % 4) * 32.0 + sin(phase + index * PI * 0.5) * 7.0 * sin(phase * 0.25))
