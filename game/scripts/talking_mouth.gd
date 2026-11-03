class_name TalkingMouth
extends Sprite2D
## A mouth that opens and closes while its character speaks. Child of the character's Sprite2D,
## placed over the mouth drawn in the character's picture (its position is in that picture's
## pixels, so it can be nudged in the Inspector).
##
## While talking it switches between `open_texture` and closed (`closed_texture`, or nothing,
## which shows the mouth already drawn in the picture). Its own node so it keeps running:
## Popochiu turns off frame-by-frame processing on characters themselves.

@export var open_texture: Texture2D
## Shown when not talking and between words. Empty = show the picture's own mouth.
@export var closed_texture: Texture2D
@export var open_scale := 0.25
@export var closed_scale := 0.25
## How many times a second the mouth opens.
@export var flaps_per_second := 7.0

var talking := false: set = set_talking

var _time := 0.0
var _base_x := 0.0


func _ready() -> void:
	_base_x = position.x
	_show_closed()


func _process(delta: float) -> void:
	# Popochiu flips the picture with flip_h (Reem walking left): follow it.
	var picture := get_parent() as Sprite2D
	if picture:
		flip_h = picture.flip_h
		position.x = -_base_x if picture.flip_h else _base_x

	if not talking:
		return

	_time += delta
	# Mostly open, briefly closed: reads as speech at a glance.
	if fmod(_time * flaps_per_second, 1.0) < 0.6:
		_show_open()
	else:
		_show_closed()


func set_talking(value: bool) -> void:
	talking = value
	_time = 0.0
	if not talking:
		_show_closed()


func _show_open() -> void:
	texture = open_texture
	scale = Vector2.ONE * open_scale
	visible = open_texture != null


func _show_closed() -> void:
	texture = closed_texture
	scale = Vector2.ONE * closed_scale
	visible = closed_texture != null
