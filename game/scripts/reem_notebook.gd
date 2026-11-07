class_name ReemNotebook
extends CanvasLayer
## Notebook pages use existing art and recordings. Only visited rooms are travel targets.

var is_open := false
var data: Dictionary
var labels: Dictionary
var words: Dictionary
var open_button: Button
var close_button: Button
var more_button: Button
var hint_label: Label
var page_buttons: Dictionary = {}
var word_buttons: Dictionary = {}
var map_buttons: Dictionary = {}
var _root: Control
var _body: VBoxContainer
var _voice: AudioStreamPlayer
var _page := "hints"


func _ready() -> void:
	layer = 90
	process_mode = Node.PROCESS_MODE_ALWAYS
	data = _read("res://game_data/notebook.json")
	labels = _read("res://game_data/ui_labels.json")
	words = _read("res://game_data/words.json")
	_voice = AudioStreamPlayer.new()
	_voice.bus = ReemSettings.VOICE_BUS
	add_child(_voice)
	_build()


func _read(path: String) -> Dictionary:
	return JSON.parse_string(FileAccess.get_file_as_string(path))


func _process(_delta: float) -> void:
	open_button.visible = not is_open and can_open()


func can_open() -> bool:
	return R.current is ReemRoom and is_instance_valid(C.player) \
		and C.player.has_inventory_item("Notebook") and Globals.settings.can_open()


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_N or (is_open and event.keycode == KEY_ESCAPE):
			if is_open:
				close_notebook()
			else:
				open_notebook()
			get_viewport().set_input_as_handled()


func open_notebook() -> void:
	if is_open or not can_open():
		return
	Globals.refresh_friend_cards()
	Globals.word_discovery.cancel_for_overlay()
	I.active = null
	is_open = true
	G.block()
	PopochiuUtils.cursor.show_cursor("gui", true)
	get_tree().paused = true
	_root.show()
	show_page("hints")
	close_button.grab_focus()


func close_notebook() -> void:
	if not is_open:
		return
	_voice.stop()
	_root.hide()
	is_open = false
	get_tree().paused = false
	G.unblock()


func show_page(page: String) -> void:
	_voice.stop()
	_page = page
	for child in _body.get_children():
		_body.remove_child(child)
		child.queue_free()
	word_buttons.clear()
	map_buttons.clear()
	for key: String in page_buttons:
		page_buttons[key].disabled = key == page
	match page:
		"hints": _show_hints()
		"words": _show_words()
		"map": _show_map()
		"cards": _show_cards()


## Contexts follow puzzle progress rather than visit count, so hints remain useful on returns.
func hint_context() -> String:
	match R.current.script_name:
		"OakForest":
			if not Globals.oak.get("nuts", false):
				if Globals.oak.get("Acorn1", false) and Globals.oak.get("Acorn2", false) and Globals.oak.get("Acorn3", false):
					return "oak_share"
				return "oak_search"
			return "forward" if Globals.oak.get("leaves", false) else "oak_greet"
		"PineFork":
			if not Globals.pine.get("met", false): return "pine_meet"
			return "pine_repair" if Globals.pine.get("promised", false) else "pine_route"
		"Stream":
			if not Globals.stream.get("bridge", false): return "stream_bridge"
			if not Globals.stream.get("route", false): return "stream_map"
			if not Globals.stream.get("lantern_choice", false) or Globals.stream.get("lent", false): return "stream_lantern"
			return "forward"
		"Yard":
			if not Globals.briefed: return "briefing"
			if Globals.needs_mirror and not Globals.confessed: return "confess"
			return "yard"
		"MeadowFork":
			if Globals.trampled and not Globals.flowers_fixed:
				return "water" if Globals.told_to_fix else "bee"
			return "path"
		"BigTree":
			if Globals.trampled and not Globals.flowers_fixed:
				return "water" if Globals.told_to_fix else "bee"
			if not Globals.met_shahd: return "bee"
			if Globals.flowers_open: return "forward"
			if C.player.has_inventory_item("HandMirror"): return "mirror"
			return "confess" if Globals.needs_mirror else "examine"
		"FoxRock":
			if Globals.fox_done: return "forward"
			return "return_stone" if Globals.stone_wiped else "stone"
	return "forward"


func _show_hints() -> void:
	var context := hint_context()
	var level := clampi(int(Globals.hint_steps.get(context, 0)), 0, 2)
	var line_id: String = data.hints[context][level]
	hint_label = _text(Lines.get_text(line_id))
	_body.add_child(hint_label)
	more_button = _button(labels.more)
	more_button.disabled = level == 2
	more_button.pressed.connect(func():
		Globals.hint_steps[context] = mini(level + 1, 2)
		show_page("hints")
	)
	_body.add_child(more_button)
	var repeat := _button(labels.repeat)
	repeat.pressed.connect(func(): _play_line(line_id))
	_body.add_child(repeat)
	_play_line(line_id)


func _show_words() -> void:
	var grid := GridContainer.new()
	grid.columns = 2
	grid.add_theme_constant_override("h_separation", 28)
	grid.add_theme_constant_override("v_separation", 16)
	_body.add_child(grid)
	for word_id: String in words:
		if not Globals.discovered_words.has(word_id): continue
		var entry: Dictionary = words[word_id]
		var button := _button(entry.text)
		button.custom_minimum_size.x = 580
		button.pressed.connect(func(): _play_audio(entry.audio))
		word_buttons[word_id] = button
		grid.add_child(button)
	if word_buttons.is_empty():
		_body.add_child(_text(labels.empty_words))


func visited(room_name: String) -> bool:
	var state: PopochiuRoomData = R.rooms_states.get(room_name)
	return state != null and state.visited_times > 0


func _show_map() -> void:
	var map := Control.new()
	map.custom_minimum_size = Vector2(1200, 520)
	_body.add_child(map)
	for edge: Array in data.edges:
		var start: Dictionary = data.map[int(edge[0])]
		var end: Dictionary = data.map[int(edge[1])]
		var a := Vector2(start.at[0], start.at[1]) * Vector2(1200, 520) + Vector2(155, 40)
		var b := Vector2(end.at[0], end.at[1]) * Vector2(1200, 520) + Vector2(155, 40)
		var trail := Line2D.new()
		trail.width = 9
		trail.default_color = Color(0.66, 0.43, 0.22)
		trail.points = PackedVector2Array([a, a.lerp(b, 0.33) + Vector2(8, -9), a.lerp(b, 0.66) + Vector2(-8, 9), b])
		map.add_child(trail)
	for place: Dictionary in data.map:
		var room_name: String = place.room
		var current: bool = room_name == R.current.script_name
		var caption: String = place.label
		caption += "\n" + (labels.current_place if current else labels.locked if not visited(room_name) else "")
		var button := _button(caption)
		button.add_theme_font_size_override("font_size", 32)
		button.position = Vector2(place.at[0], place.at[1]) * Vector2(1200, 520)
		button.custom_minimum_size = Vector2(350, 110)
		button.disabled = current or not visited(room_name)
		button.pressed.connect(func(): travel(room_name))
		map_buttons[room_name] = button
		map.add_child(button)


func travel(room_name: String) -> void:
	if not is_open or _page != "map" or not visited(room_name): return
	var allowed := false
	for place: Dictionary in data.map:
		if place.room == room_name: allowed = true
	if not allowed or room_name == R.current.script_name: return
	close_notebook()
	R.goto_room(room_name)


func _show_cards() -> void:
	var found := false
	for card: Dictionary in data.cards:
		if not Globals.friend_cards.has(card.id): continue
		found = true
		var image := TextureRect.new()
		image.texture = load(card.image)
		image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		image.custom_minimum_size = Vector2(300, 220)
		_body.add_child(image)
		var name_button := _button(Lines.get_text(card.name_line))
		name_button.pressed.connect(func(): _play_line(card.name_line))
		_body.add_child(name_button)
		_body.add_child(_text(Lines.get_text(card.fact_line)))
		var replay := _button(labels.repeat)
		replay.pressed.connect(func(): _play_line(card.fact_line))
		_body.add_child(replay)
	if not found: _body.add_child(_text(labels.empty_cards))


func _play_line(line_id: String) -> void:
	var lines: Dictionary = _read(Lines.LINES_PATH)
	_play_audio(lines[line_id].audio)


func _play_audio(path: String) -> void:
	_voice.stop()
	if not ResourceLoader.exists(path): return
	_voice.stream = load(path)
	_voice.play()


func _button(caption: String) -> Button:
	var button := Button.new()
	button.text = caption
	button.theme = ArabicText.get_theme()
	button.custom_minimum_size.y = 86
	ArabicText.make_rtl(button)
	return button


func _text(caption: String) -> Label:
	var label := Label.new()
	label.text = caption
	label.theme = ArabicText.get_theme()
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	label.add_theme_color_override("font_color", Color(0.25, 0.13, 0.04))
	ArabicText.make_rtl(label)
	return label


func _build() -> void:
	open_button = _button(labels.notebook)
	open_button.name = "NotebookButton"
	open_button.position = Vector2(1000, 16)
	open_button.custom_minimum_size.x = 270
	add_child(open_button)
	open_button.pressed.connect(open_notebook)
	_root = Control.new()
	_root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(_root)
	var shade := ColorRect.new()
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	shade.color = Color(0.06, 0.04, 0.02, 0.7)
	_root.add_child(shade)
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_root.add_child(center)
	var panel := PanelContainer.new()
	panel.name = "NotebookPages"
	panel.custom_minimum_size = Vector2(1400, 850)
	var style := StyleBoxFlat.new()
	style.bg_color = Color(1, 0.96, 0.84)
	style.border_color = Color(0.43, 0.26, 0.11)
	style.set_border_width_all(6)
	style.set_corner_radius_all(24)
	style.content_margin_left = 40
	style.content_margin_right = 40
	style.content_margin_top = 24
	style.content_margin_bottom = 24
	panel.add_theme_stylebox_override("panel", style)
	center.add_child(panel)
	var rows := VBoxContainer.new()
	rows.add_theme_constant_override("separation", 22)
	panel.add_child(rows)
	var tabs := HBoxContainer.new()
	rows.add_child(tabs)
	for key: String in ["hints", "words", "map", "cards"]:
		var button := _button(labels[key])
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.pressed.connect(func(): show_page(key))
		tabs.add_child(button)
		page_buttons[key] = button
	var scroll := ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(1320, 590)
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	rows.add_child(scroll)
	_body = VBoxContainer.new()
	_body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_body.add_theme_constant_override("separation", 24)
	scroll.add_child(_body)
	close_button = _button(labels.back)
	close_button.pressed.connect(close_notebook)
	rows.add_child(close_button)
	_root.hide()
