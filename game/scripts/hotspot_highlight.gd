class_name HotspotHighlight
extends CanvasLayer
## An optional visual hint, with no gameplay cost or effect on objects.

@export var button_position := Vector2(32, 970)
@export var glow_duration := 2.4

var button: Button
var targets: Array[Dictionary] = []
var _remaining := 0.0
var _drawing: _Outlines


func _ready() -> void:
	layer = 44
	process_mode = Node.PROCESS_MODE_ALWAYS
	_drawing = _Outlines.new()
	add_child(_drawing)
	button = Button.new()
	button.name = "HighlightButton"
	var labels: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://game_data/ui_labels.json"))
	button.text = labels.highlight
	button.position = button_position
	button.custom_minimum_size = Vector2(300, 80)
	button.theme = ArabicText.get_theme()
	button.add_theme_font_size_override("font_size", 32)
	ArabicText.make_rtl(button)
	add_child(button)
	button.pressed.connect(reveal)


func can_reveal() -> bool:
	return R.current is ReemRoom and Globals.settings.can_open() and not I.active


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_H:
		if can_reveal():
			reveal()
			get_viewport().set_input_as_handled()


func reveal() -> void:
	if not can_reveal(): return
	_remaining = glow_duration
	targets = collect_targets()
	_drawing.targets = targets
	_drawing.modulate.a = 1.0
	_drawing.queue_redraw()


func _process(delta: float) -> void:
	button.visible = can_reveal()
	if not button.visible:
		_remaining = 0.0
	_remaining = maxf(0.0, _remaining - delta)
	if _remaining > 0.0:
		targets = collect_targets()
	else:
		targets.clear()
	_drawing.targets = targets
	_drawing.modulate.a = minf(1.0, _remaining / 0.5)
	_drawing.queue_redraw()


func collect_targets() -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	var room := R.current as ReemRoom
	if room == null: return result
	var to_screen := get_viewport().get_canvas_transform()
	for object: PopochiuClickable in room.get_props() + room.get_hotspots() + room.get_characters():
		if object == C.player or not object.is_visible_in_tree() or not object.clickable:
			continue
		if not room.has_action(object): continue
		var shape := object.get_node_or_null("InteractionPolygon") as CollisionPolygon2D
		if shape == null or shape.polygon.size() < 3: continue
		var transform := to_screen * shape.get_global_transform()
		var polygon := PackedVector2Array()
		for point in shape.polygon:
			polygon.append(transform * point)
		result.append({"id": object.script_name, "polygon": polygon})
	if is_instance_valid(C.player):
		for item: PopochiuInventoryItem in C.player.inventory.values():
			if not item.is_visible_in_tree(): continue
			var rect := item.get_global_rect()
			if not get_viewport().get_visible_rect().intersects(rect): continue
			var transform := item.get_global_transform_with_canvas()
			var size := item.size
			result.append({"id": "item:" + item.script_name, "polygon": PackedVector2Array([
				transform * Vector2.ZERO, transform * Vector2(size.x, 0),
				transform * size, transform * Vector2(0, size.y)])})
	return result


class _Outlines extends Node2D:
	var targets: Array[Dictionary] = []


	func _draw() -> void:
		for target: Dictionary in targets:
			var polygon: PackedVector2Array = target.polygon
			if polygon.size() < 3: continue
			var closed := polygon.duplicate()
			closed.append(polygon[0])
			draw_colored_polygon(polygon, Color(1, 0.87, 0.35, 0.13))
			draw_polyline(closed, Color(1, 0.78, 0.16, 0.3), 18, true)
			draw_polyline(closed, Color(1, 0.93, 0.58, 0.95), 5, true)
