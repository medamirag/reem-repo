class_name WordDiscovery
extends CanvasLayer
## Word discovery: press and HOLD on an object (about half a second, mouse or finger) and its
## Arabic name appears in a bubble near it, with a soft glow on the object, and is spoken.
## A short click works exactly as before.
##
## How a short click keeps working: Popochiu acts as soon as the button goes down. So when the
## press lands on an object that has a word, this node keeps the press for itself. If the
## button comes up before HOLD_TIME, it hands the same press and release back to the game,
## which then sees an ordinary click. If the button is still down after HOLD_TIME, the word is
## shown and the click is not passed on.
##
## Words: game_data/words.json. Where they are in each room: game_data/word_areas.json
## (polygons as fractions of the screen). Props, characters and inventory items get their word
## from the "objects" list in words.json and use their own click area.
##
## F2 in the game shows every hold area with its id (F2 again hides them).

const WORDS_PATH := "res://game_data/words.json"
const AREAS_PATH := "res://game_data/word_areas.json"
## Seconds the button or finger must stay down.
const HOLD_TIME := 0.5
## How far (pixels) the pointer may move during a hold before it counts as a normal click.
const MOVE_TOLERANCE := 40.0
## How long the bubble stays at least (seconds); longer if the word's audio is longer.
const BUBBLE_TIME := 2.5
const WORD_FONT_SIZE := 72

## Emitted the first time each word is discovered.
signal word_discovered(word_id: String)

var _words := {}
var _areas := {}
## "prop:Mirror" -> "word_mirror", etc.
var _object_words := {}

var _pressing := false
var _shown := false
var _press_event: InputEventMouseButton
var _press_started_ms := 0
var _target := {}
## How many of the next left-button events to let through untouched (replayed click).
var _passthrough := 0

var _debug := false
var _debug_view: _DebugView
var _shown_nodes: Array[Node] = []
var _hide_timer: SceneTreeTimer
var _voice: AudioStreamPlayer


func _ready() -> void:
	layer = 45
	process_mode = Node.PROCESS_MODE_ALWAYS
	_words = _load_json(WORDS_PATH)
	_areas = _load_json(AREAS_PATH)
	for word_id: String in _words:
		for object_key in (_words[word_id] as Dictionary).get("objects", []):
			_object_words[object_key] = word_id

	_voice = AudioStreamPlayer.new()
	_voice.bus = ReemSettings.VOICE_BUS
	add_child(_voice)

	_debug_view = _DebugView.new()
	_debug_view.owner_discovery = self
	_debug_view.hide()
	add_child(_debug_view)


#region Input ######################################################################################
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_F2:
		_debug = not _debug
		_debug_view.visible = _debug
		get_viewport().set_input_as_handled()
		return

	if event is InputEventMouseMotion and _pressing and not _shown:
		if event.position.distance_to(_press_event.position) > MOVE_TOLERANCE:
			_give_back_press()
		return

	if not (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT):
		return

	if _passthrough > 0:
		_passthrough -= 1
		return

	if event.pressed:
		if _pressing or not _can_hold():
			return
		var target := _find_target(event.position)
		if target.is_empty():
			return
		_pressing = true
		_shown = false
		_target = target
		_press_event = event.duplicate()
		_press_started_ms = Time.get_ticks_msec()
		get_viewport().set_input_as_handled()
	elif _pressing:
		_pressing = false
		get_viewport().set_input_as_handled()
		if not _shown:
			# A short click: give the game the press and the release it would have had.
			_replay.call_deferred(_press_event, event.duplicate())


func _process(_delta: float) -> void:
	if _debug:
		_debug_view.queue_redraw()

	if not _pressing or _shown:
		return

	if not _can_hold():
		# Dialogue or a choice started while holding: let the press do what it normally does.
		_give_back_press()
		return

	if Time.get_ticks_msec() - _press_started_ms >= HOLD_TIME * 1000.0:
		_shown = true
		show_word(_target)


func _give_back_press() -> void:
	_pressing = false
	_passthrough += 1
	Input.parse_input_event.call_deferred(_to_window(_press_event))


func _replay(press: InputEventMouseButton, release: InputEventMouseButton) -> void:
	_passthrough += 2
	Input.parse_input_event(_to_window(press))
	Input.parse_input_event(_to_window(release))


# Events reach _input() already converted to the game's 1920x1080 pixels. Before sending one
# back into Input it must be turned back into window pixels, or Godot converts it twice and the
# click lands in the wrong place (the window is smaller than 1920x1080, or scaled).
func _to_window(event: InputEventMouseButton) -> InputEventMouseButton:
	var copy := event.duplicate() as InputEventMouseButton
	var to_window := get_viewport().get_screen_transform()
	copy.position = to_window * event.position
	copy.global_position = to_window * event.global_position
	return copy


## Word discovery only works while the child is free to play: not during dialogue, a choice,
## a narration, a room change, or while an inventory item is selected.
## Why a hold would be refused right now ("" = it would work). For debugging and the playtest.
func why_not() -> String:
	if Globals.settings.is_open or (is_instance_valid(Globals.notebook) and Globals.notebook.is_open):
		return "settings open"
	if not is_instance_valid(R.current):
		return "no room"
	if not (R.current is ReemRoom):
		return "not a playable room"
	if not E.in_room or not R.current.is_current:
		return "room changing"
	if G.is_blocked:
		return "GUI blocked"
	if Lines.busy:
		return "a line is being spoken"
	if I.active:
		return "an item is selected"
	return ""


func _can_hold() -> bool:
	if Globals.settings.is_open or (is_instance_valid(Globals.notebook) and Globals.notebook.is_open):
		return false
	if Engine.is_editor_hint() or not is_instance_valid(R.current):
		return false
	if not (R.current is ReemRoom) or not E.in_room or not R.current.is_current:
		return false
	if G.is_blocked or Lines.busy or I.active:
		return false
	if is_instance_valid(G.gui):
		for child in G.gui.get_children():
			if child is ChoicePopup:
				return false
	return true


#endregion

#region Finding what is under the pointer #########################################################
## Returns {word, polygon (screen points), kind} for what is at `screen_pos`, or {} if nothing.
## Inventory items first, then characters, props and small decorations, then the background
## areas (the smallest area wins where they overlap).
func _find_target(screen_pos: Vector2) -> Dictionary:
	var control := get_viewport().gui_get_hovered_control()
	if control:
		var node: Node = control
		while node:
			if node is PopochiuInventoryItem:
				var word: String = _object_words.get("item:" + (node as PopochiuInventoryItem).script_name, "")
				if word.is_empty():
					return {}
				return {word = word, polygon = _control_polygon(node as Control), kind = "item"}
			node = node.get_parent()
		# Some other piece of the GUI (the top bar, its buttons): not ours.
		return {}

	var best := {}
	var best_size := INF
	for candidate: Dictionary in get_room_targets():
		var poly: PackedVector2Array = candidate.polygon
		if not Geometry2D.is_point_in_polygon(screen_pos, poly):
			continue
		# Objects (characters, props) win over background areas; then the smallest wins.
		var size := _polygon_area(poly) + (0.0 if candidate.kind != "area" else 1e9)
		if size < best_size:
			best_size = size
			best = candidate
	return best


## Everything in the current room that has a word, as screen polygons.
func get_room_targets() -> Array[Dictionary]:
	var targets: Array[Dictionary] = []
	var room := R.current
	if not is_instance_valid(room):
		return targets
	var to_screen := get_viewport().get_canvas_transform()

	var characters := room.get_node_or_null("Characters")
	if characters:
		for chr in characters.get_children():
			if chr is PopochiuCharacter and chr.visible:
				_add_object(targets, "character:" + chr.script_name, chr, to_screen)

	for prop: PopochiuProp in room.get_props():
		if prop.visible:
			_add_object(targets, "prop:" + prop.script_name, prop, to_screen)

	for key: String in _object_words:
		if not key.begins_with("decor:"):
			continue
		var decor := room.get_node_or_null(key.trim_prefix("decor:")) as Node2D
		if decor and decor.visible:
			var sprite := decor.get_node_or_null("Body") as Sprite2D
			if sprite:
				var rect := sprite.get_rect()
				var xf := to_screen * sprite.get_global_transform()
				targets.append({
					word = _object_words[key], kind = "decor", id = key,
					polygon = PackedVector2Array([xf * rect.position,
						xf * Vector2(rect.end.x, rect.position.y), xf * rect.end,
						xf * Vector2(rect.position.x, rect.end.y)]),
				})

	var room_size := Vector2(room.width, room.height)
	for entry in _areas.get(room.script_name, []):
		var poly := PackedVector2Array()
		for point in (entry as Dictionary).get("polygon", []):
			poly.append(to_screen * (Vector2(point[0], point[1]) * room_size))
		if poly.size() >= 3:
			targets.append({word = entry.word, kind = "area", id = entry.word, polygon = poly})
	return targets


func _add_object(targets: Array[Dictionary], key: String, node: Node2D, to_screen: Transform2D) -> void:
	var word: String = _object_words.get(key, "")
	if word.is_empty():
		return
	var shape := node.get_node_or_null("InteractionPolygon") as CollisionPolygon2D
	if shape == null or shape.polygon.size() < 3:
		return
	var xf := to_screen * shape.get_global_transform()
	var poly := PackedVector2Array()
	for point in shape.polygon:
		poly.append(xf * point)
	targets.append({word = word, kind = key.get_slice(":", 0), id = key, polygon = poly})


func _control_polygon(control: Control) -> PackedVector2Array:
	var xf := control.get_global_transform_with_canvas()
	var size := control.size
	return PackedVector2Array([xf * Vector2.ZERO, xf * Vector2(size.x, 0), xf * size,
		xf * Vector2(0, size.y)])


func _polygon_area(poly: PackedVector2Array) -> float:
	var sum := 0.0
	for i in poly.size():
		var a := poly[i]
		var b := poly[(i + 1) % poly.size()]
		sum += a.x * b.y - b.x * a.y
	return absf(sum) / 2.0


#endregion

#region Showing a word #############################################################################
## Shows the word of `target` ({word, polygon}): glow on the object, bubble with the Arabic
## word, its audio if the file exists, and a sparkle the first time.
func show_word(target: Dictionary) -> void:
	var word_id: String = target.get("word", "")
	if not _words.has(word_id):
		return
	var info: Dictionary = _words[word_id]
	_clear_shown()

	var poly: PackedVector2Array = target.polygon
	var glow := _Glow.new()
	glow.polygon = poly
	add_child(glow)
	_shown_nodes.append(glow)

	var bubble := _make_bubble(str(info.get("text", "")))
	add_child(bubble)
	_shown_nodes.append(bubble)
	_place_bubble(bubble, poly)

	for node in [glow, bubble]:
		(node as CanvasItem).modulate.a = 0.0
		create_tween().tween_property(node, "modulate:a", 1.0, 0.2)

	var stay := BUBBLE_TIME
	var audio := str(info.get("audio", ""))
	_voice.stop()
	if not audio.is_empty() and ResourceLoader.exists(audio):
		var stream := load(audio) as AudioStream
		if stream:
			_voice.stream = stream
			_voice.play()
			stay = maxf(stay, stream.get_length() + 1.0)

	if not Globals.discovered_words.has(word_id):
		Globals.discovered_words[word_id] = true
		_sparkle(bubble.position + bubble.size / 2.0)
		word_discovered.emit(word_id)

	var timer := get_tree().create_timer(stay)
	_hide_timer = timer
	await timer.timeout
	if _hide_timer == timer:
		_fade_out_shown()


func _make_bubble(text: String) -> PanelContainer:
	var bubble := PanelContainer.new()
	bubble.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var style := StyleBoxFlat.new()
	style.bg_color = Color(1.0, 0.98, 0.92)
	style.border_color = Color(0.36, 0.22, 0.08)
	style.set_border_width_all(5)
	style.set_corner_radius_all(30)
	style.content_margin_left = 36
	style.content_margin_right = 36
	style.content_margin_top = 6
	style.content_margin_bottom = 14
	style.shadow_color = Color(0, 0, 0, 0.25)
	style.shadow_size = 8
	bubble.add_theme_stylebox_override("panel", style)

	var label := Label.new()
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_override("font", ArabicText.get_font())
	label.add_theme_font_size_override("font_size", roundi(WORD_FONT_SIZE * Globals.settings.text_size / 40.0))
	label.add_theme_color_override("font_color", Color(0.25, 0.14, 0.04))
	ArabicText.make_rtl(label)
	bubble.add_child(label)
	return bubble


## Above the object, centred on it, kept inside the screen (below it if there is no room above).
func _place_bubble(bubble: PanelContainer, poly: PackedVector2Array) -> void:
	bubble.reset_size()
	var size := bubble.get_combined_minimum_size()
	bubble.size = size
	var bounds := Rect2(poly[0], Vector2.ZERO)
	for point in poly:
		bounds = bounds.expand(point)
	var screen := get_viewport().get_visible_rect().size
	var pos := Vector2(bounds.get_center().x - size.x / 2.0, bounds.position.y - size.y - 16.0)
	if pos.y < 90.0:
		pos.y = minf(bounds.end.y + 16.0, screen.y - size.y - 10.0)
		if bounds.size.y > screen.y * 0.5:
			pos.y = bounds.get_center().y - size.y / 2.0
	pos.x = clampf(pos.x, 10.0, screen.x - size.x - 10.0)
	pos.y = clampf(pos.y, 10.0, screen.y - size.y - 10.0)
	bubble.position = pos


func _sparkle(at: Vector2) -> void:
	var particles := CPUParticles2D.new()
	particles.position = at
	particles.one_shot = true
	particles.explosiveness = 0.9
	particles.amount = 36
	particles.lifetime = 0.9
	particles.spread = 180.0
	particles.direction = Vector2.UP
	particles.initial_velocity_min = 180.0
	particles.initial_velocity_max = 360.0
	particles.gravity = Vector2(0, 300)
	particles.scale_amount_min = 6.0
	particles.scale_amount_max = 12.0
	var colors := Gradient.new()
	colors.set_color(0, Color(1.0, 0.95, 0.5))
	colors.set_color(1, Color(1.0, 0.75, 0.2, 0.0))
	particles.color_ramp = colors
	add_child(particles)
	particles.emitting = true
	get_tree().create_timer(1.5).timeout.connect(particles.queue_free)


func _fade_out_shown() -> void:
	var nodes := _shown_nodes.duplicate()
	_shown_nodes.clear()
	for node in nodes:
		if is_instance_valid(node):
			var tween := create_tween()
			tween.tween_property(node, "modulate:a", 0.0, 0.3)
			tween.tween_callback(node.queue_free)


func _clear_shown() -> void:
	for node in _shown_nodes:
		if is_instance_valid(node):
			node.queue_free()
	_shown_nodes.clear()


#endregion

func _load_json(path: String) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("[WordDiscovery] Could not open %s" % path)
		return {}
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		push_error("[WordDiscovery] %s is not valid JSON" % path)
		return {}
	return parsed


## The soft glowing outline drawn over the held object.
class _Glow extends Node2D:
	const COLOR := Color(1.0, 0.86, 0.35)
	var polygon := PackedVector2Array()
	var _time := 0.0

	func _process(delta: float) -> void:
		_time += delta
		queue_redraw()

	func _draw() -> void:
		if polygon.size() < 3:
			return
		var pulse := 0.75 + 0.25 * sin(_time * TAU * 1.5)
		var closed := polygon.duplicate()
		closed.append(polygon[0])
		draw_colored_polygon(polygon, Color(COLOR, 0.18 * pulse))
		draw_polyline(closed, Color(COLOR, 0.35 * pulse), 22.0, true)
		draw_polyline(closed, Color(COLOR, 0.9 * pulse), 8.0, true)
		draw_polyline(closed, Color(1, 1, 1, 0.8 * pulse), 2.5, true)


## F2: every hold area outlined with its id.
class _DebugView extends Node2D:
	var owner_discovery: WordDiscovery

	func _draw() -> void:
		if owner_discovery == null:
			return
		var font := ThemeDB.fallback_font
		for target: Dictionary in owner_discovery.get_room_targets():
			var poly: PackedVector2Array = target.polygon
			var color := Color(0.1, 0.9, 1.0) if target.kind == "area" else Color(1.0, 0.3, 0.9)
			var closed := poly.duplicate()
			closed.append(poly[0])
			draw_polyline(closed, color, 3.0, true)
			var label := "%s (%s)" % [target.word, target.id] if target.kind != "area" else str(target.word)
			var at := poly[0] + Vector2(6, 22)
			draw_string_outline(font, at, label, HORIZONTAL_ALIGNMENT_LEFT, -1, 26, 8, Color.BLACK)
			draw_string(font, at, label, HORIZONTAL_ALIGNMENT_LEFT, -1, 26, color)


## Cancel an unfinished hold rather than replaying a story click after closing Settings.
func cancel_for_overlay() -> void:
	_pressing = false
	_shown = false
	_voice.stop()
	_clear_shown()
