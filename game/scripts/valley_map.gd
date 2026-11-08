extends CanvasLayer

const ART := "res://assets/art/ui/map_"
const INTRO := "jad_map_intro_vocalised"
var is_open := false
var places: Array
var words: Dictionary
var lines: Dictionary
var markers: Array[Button] = []
var map_button: Button
var screen: ColorRect
var board: TextureRect
var pin: TextureRect
var close_button: Button
var notice: PanelContainer
var name_label: Label
var choices: HBoxContainer
var audio: AudioStreamPlayer
var turn: AudioStreamPlayer
var destination := ""
var elapsed := 0.0
var save_intro_on_close := false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 95
	places = _read("map_places")
	words = _read("words")
	lines = _read("lines")
	map_button = _button(self, "الخَرِيطَة", open_map)
	# Below the inventory bar's 120 px strip, so the bar never slides over it (docs/BUGS.md #2).
	map_button.position = Vector2(18, 134)
	map_button.size = Vector2(76, 60)
	map_button.icon = _texture("button")
	map_button.expand_icon = true
	if map_button.icon:
		map_button.text = ""
	map_button.tooltip_text = "الخَرِيطَة (M)"
	map_button.hide()

	screen = ColorRect.new()
	screen.color = Color("#39281b")
	add_child(screen)
	screen.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	board = _picture(screen, "valley")
	for place: Dictionary in places:
		var marker := _button(board, "", select_place.bind(place))
		marker.flat = true
		marker.expand_icon = true
		markers.append(marker)
	pin = _picture(board, "pin_reem")
	close_button = _button(screen, "×", close_map)
	notice = PanelContainer.new()
	screen.add_child(notice)
	var paper := StyleBoxFlat.new()
	paper.bg_color = Color("#fff0ca")
	paper.set_corner_radius_all(14)
	paper.content_margin_left = 20
	paper.content_margin_right = 20
	paper.content_margin_top = 8
	paper.content_margin_bottom = 8
	notice.add_theme_stylebox_override("panel", paper)
	var column := VBoxContainer.new()
	notice.add_child(column)
	name_label = Label.new()
	name_label.theme = ArabicText.get_theme()
	ArabicText.make_rtl(name_label)
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	name_label.add_theme_color_override("font_color", Color("#442916"))
	column.add_child(name_label)
	choices = HBoxContainer.new()
	choices.alignment = BoxContainer.ALIGNMENT_CENTER
	choices.layout_direction = Control.LAYOUT_DIRECTION_RTL
	column.add_child(choices)
	_button(choices, "نَعَم", _travel)
	_button(choices, "لَا", _dismiss)
	audio = AudioStreamPlayer.new()
	audio.bus = ReemSettings.VOICE_BUS
	add_child(audio)
	turn = AudioStreamPlayer.new()
	turn.bus = ReemSettings.EFFECTS_BUS
	add_child(turn)
	turn.stream = load("res://game/audio/map_page_turn.wav")
	get_viewport().size_changed.connect(_layout)
	screen.hide()


func _read(file: String) -> Variant:
	return JSON.parse_string(FileAccess.get_file_as_string("res://game_data/%s.json" % file))


func _texture(kind: String) -> Texture2D:
	var path := ART + kind + ".png"
	return load(path) if ResourceLoader.exists(path) else null


func _picture(parent: Control, kind: String) -> TextureRect:
	var picture := TextureRect.new()
	picture.texture = _texture(kind)
	picture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	picture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	picture.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(picture)
	return picture


func _button(parent: Node, title: String, action: Callable) -> Button:
	var button := Button.new()
	button.theme = ArabicText.get_theme()
	ArabicText.make_rtl(button)
	button.text = title
	button.pressed.connect(action)
	parent.add_child(button)
	return button


func _is_station() -> bool:
	return is_instance_valid(R.current) and R.current is ReemRoom and not R.current.hide_gui \
		and not ("hosting" in R.current and R.current.hosting)


func _process(delta: float) -> void:
	map_button.visible = _is_station() and not is_open
	map_button.disabled = not map_button.visible or not Globals.settings.can_open()
	if is_open and pin.visible:
		elapsed += delta
		pin.position.y = pin.get_meta("base_y") + sin(elapsed * 4.0) * 5.0


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if is_open and (event.keycode == KEY_ESCAPE or event.keycode == KEY_M):
			close_map()
			get_viewport().set_input_as_handled()
		elif event.keycode == KEY_M and _is_station() and Globals.settings.can_open():
			open_map()
			get_viewport().set_input_as_handled()


func open_map() -> void:
	if is_open or not _is_station() or not Globals.settings.can_open():
		return
	Globals.word_discovery.cancel_for_overlay()
	I.active = null
	is_open = true
	G.block()
	PopochiuUtils.cursor.show_cursor("gui", true)
	get_tree().paused = true
	_dismiss()
	screen.show()
	_layout()
	close_button.grab_focus()
	turn.play()
	if not Globals.map_intro_seen:
		Globals.map_intro_seen = true
		save_intro_on_close = true
		var intro: Dictionary = lines[INTRO]
		_show_notice(intro.text, false)
		_play(intro.audio)


func close_map() -> void:
	if not is_open:
		return
	audio.stop()
	turn.stop()
	screen.hide()
	is_open = false
	get_tree().paused = false
	G.unblock()
	if save_intro_on_close:
		save_intro_on_close = false
		E.save_game(1)


func _visited(place: Dictionary) -> bool:
	return not place.room.is_empty() and (place.room == R.current.script_name or Globals.notebook.visited(place.room))


func _locked(place: Dictionary) -> bool:
	return int(place.pack) != 0 and not Globals.unlocked_packs.get(str(int(place.pack)), false)


func _layout() -> void:
	if not is_open:
		return
	var extent := get_viewport().get_visible_rect().size
	var width := minf(extent.x, extent.y * 16.0 / 9.0)
	board.size = Vector2(width, width * 9.0 / 16.0)
	board.position = (extent - board.size) / 2.0
	var unit := clampf(width / 26.0, 27.0, 72.0)
	pin.hide()
	for index in places.size():
		var place: Dictionary = places[index]
		var center := Vector2(place.position[0], place.position[1]) * board.size
		var marker := markers[index]
		var locked := _locked(place)
		var visited := _visited(place)
		marker.size = Vector2.ONE * unit
		marker.position = center - marker.size / 2.0
		marker.icon = load("res://game/gui/map_lock.svg") if locked else _texture("check" if visited else "fog")
		marker.text = "" if marker.icon else "●"
		marker.modulate = Color(1, 1, 1, 0.65) if locked else Color.WHITE
		if place.room == R.current.script_name:
			pin.size = Vector2.ONE * unit * 1.5
			pin.position = center - Vector2(pin.size.x / 2.0, pin.size.y * 0.9)
			pin.set_meta("base_y", pin.position.y)
			pin.show()
	close_button.position = Vector2(extent.x - 74, 15)
	close_button.size = Vector2(56, 54)
	notice.size.x = minf(extent.x - 32, 900)
	notice.position = Vector2((extent.x - notice.size.x) / 2.0, 12)


func select_place(place: Dictionary) -> void:
	if not is_open:
		return
	var word: Dictionary = words[place.name]
	var can_travel: bool = not _locked(place) and _visited(place) and place.room != R.current.script_name
	destination = place.room if can_travel else ""
	var title: String = word.text
	if can_travel:
		title += "\nهل تريدين الذهاب إلى هنا؟"
	_show_notice(title, can_travel)
	_play(word.audio)


func _show_notice(title: String, ask: bool) -> void:
	name_label.text = title
	choices.visible = ask
	notice.show()
	notice.size.y = 0


func _dismiss() -> void:
	destination = ""
	notice.hide()


func _travel() -> void:
	for place: Dictionary in places:
		if place.room == destination and not _locked(place) and _visited(place):
			var room := destination
			close_map()
			R.goto_room(room)
			return


func _play(path: String) -> void:
	audio.stop()
	if ResourceLoader.exists(path):
		audio.stream = load(path)
		audio.play()
