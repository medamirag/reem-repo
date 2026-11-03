class_name ExitArrow
extends Node2D
## A big friendly arrow that shows where Reem can leave the room (user's request). It sits
## inside its exit hotspot, so clicking the arrow clicks the exit. It gently slides back and
## forth in the direction it points, and only shows while the exit actually leads somewhere
## (ReemRoom.is_exit_open()).

## "left", "right" or "up".
var direction := "right"
## The exit hotspot this arrow belongs to.
var exit_name := ""

const LENGTH := 140.0
const THICKNESS := 48.0
const HEAD := 92.0
const SLIDE := 12.0
const SLIDE_HZ := 1.2

var _time := 0.0
var _home := Vector2.ZERO


func _ready() -> void:
	_home = position
	z_index = 120
	match direction:
		"left":
			rotation_degrees = 180.0
		"up":
			rotation_degrees = -90.0


func _process(delta: float) -> void:
	var room := R.current as ReemRoom
	visible = room == null or room.is_exit_open(exit_name)
	if not visible:
		return

	_time += delta
	position = _home + Vector2.RIGHT.rotated(rotation) * sin(_time * TAU * SLIDE_HZ) * SLIDE


func _draw() -> void:
	# Pointing right; rotated for the other directions.
	var half := THICKNESS / 2.0
	var shaft := LENGTH - HEAD * 0.6
	var points := PackedVector2Array([
		Vector2(-LENGTH / 2.0, -half),
		Vector2(-LENGTH / 2.0 + shaft, -half),
		Vector2(-LENGTH / 2.0 + shaft, -HEAD / 2.0),
		Vector2(LENGTH / 2.0, 0),
		Vector2(-LENGTH / 2.0 + shaft, HEAD / 2.0),
		Vector2(-LENGTH / 2.0 + shaft, half),
		Vector2(-LENGTH / 2.0, half),
	])
	# Soft shadow, white body, dark brown outline (same outline colour as the art).
	var shadow := points.duplicate()
	for i in shadow.size():
		shadow[i] += Vector2(4, 6)
	draw_colored_polygon(shadow, Color(0, 0, 0, 0.25))
	draw_colored_polygon(points, Color(1, 0.98, 0.9))
	var outline := points.duplicate()
	outline.append(points[0])
	draw_polyline(outline, Color(0.2, 0.12, 0.05), 6.0, true)


## The area the arrow covers (including its slide), relative to its home position. Used to make
## sure the exit hotspot is big enough for the arrow to be clicked.
func get_click_rect() -> Rect2:
	var size := Vector2(LENGTH + SLIDE * 2.0 + 16.0, HEAD + 16.0)
	if direction == "up":
		size = Vector2(size.y, size.x)
	return Rect2(-size / 2.0, size)
