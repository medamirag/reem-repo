class_name ReemSettings
extends CanvasLayer
## Preferences live outside journey saves. This layer stays interactive while the story pauses.

const CONFIG_PATH := "user://reem_settings.cfg"
const VOICE_BUS := "ReemVoice"
const EFFECTS_BUS := "ReemEffects"
const MUSIC_BUS := "ReemMusic"
const TEXT_SIZES := [40, 48, 56]

signal text_size_changed

var music_enabled := false
var voice_volume := 1.0
var effects_volume := 1.0
var text_size := 40
var is_open := false
var _was_blocked := false
var _labels: Dictionary
var _root: Control
var _panel: PanelContainer
var _settings_rows: VBoxContainer
var _parent_rows: VBoxContainer
var _parent_data: Dictionary
var _parent_answer: int
var open_button: Button
var close_button: Button
var music_control: CheckButton
var voice_control: HSlider
var effects_control: HSlider
var text_control: OptionButton


func _ready() -> void:
	layer = 100
	process_mode = Node.PROCESS_MODE_ALWAYS
	_labels = JSON.parse_string(FileAccess.get_file_as_string("res://game_data/ui_labels.json"))
	for bus_name: String in [VOICE_BUS, EFFECTS_BUS, MUSIC_BUS]:
		if AudioServer.get_bus_index(bus_name) < 0:
			AudioServer.add_bus()
			AudioServer.set_bus_name(AudioServer.get_bus_count() - 1, bus_name)
	load_preferences()
	_build_controls()
	_route_cues.call_deferred()


func _route_cues() -> void:
	# A's registered cues are resources; changing their runtime bus does not edit their files.
	for property: Dictionary in A.get_script().get_script_property_list():
		var cue: Variant = A.get(property.name)
		if cue is PopochiuAudioCue:
			cue.bus = MUSIC_BUS if property.name.begins_with("mx_") else EFFECTS_BUS


func load_preferences() -> void:
	var config := ConfigFile.new()
	if config.load(CONFIG_PATH) == OK:
		music_enabled = bool(config.get_value("sound", "music", false))
		voice_volume = clampf(float(config.get_value("sound", "voice", 1.0)), 0.0, 1.0)
		effects_volume = clampf(float(config.get_value("sound", "effects", 1.0)), 0.0, 1.0)
		text_size = int(config.get_value("text", "size", 40))
		if text_size not in TEXT_SIZES:
			text_size = 40
	_apply()


func _apply() -> void:
	_set_volume(VOICE_BUS, voice_volume)
	_set_volume(EFFECTS_BUS, effects_volume)
	AudioServer.set_bus_mute(AudioServer.get_bus_index(MUSIC_BUS), not music_enabled)
	ArabicText.get_theme().default_font_size = text_size
	text_size_changed.emit()


func _set_volume(bus_name: String, value: float) -> void:
	var index := AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_mute(index, value == 0.0)
	AudioServer.set_bus_volume_db(index, linear_to_db(maxf(value, 0.0001)))


func save_preferences() -> void:
	var config := ConfigFile.new()
	config.set_value("sound", "music", music_enabled)
	config.set_value("sound", "voice", voice_volume)
	config.set_value("sound", "effects", effects_volume)
	config.set_value("text", "size", text_size)
	if config.save(CONFIG_PATH) != OK:
		push_error("[Settings] Could not save preferences")


func can_open() -> bool:
	if not is_instance_valid(R.current) or not E.in_room or not R.current.is_current:
		return false
	if Lines.busy or E.playing_queue:
		return false
	if "hosting" in R.current and R.current.hosting:
		return false
	if G.is_blocked and not R.current.hide_gui:
		return false
	if is_instance_valid(C.player) and C.player.is_moving:
		return false
	return not get_tree().paused


func _process(_delta: float) -> void:
	open_button.visible = not is_open and can_open()


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_F10 or (is_open and event.keycode == KEY_ESCAPE):
			if is_open:
				close_settings()
			else:
				open_settings()
			get_viewport().set_input_as_handled()


func open_settings() -> void:
	if is_open or not can_open():
		return
	_was_blocked = G.is_blocked
	is_open = true
	Globals.word_discovery.cancel_for_overlay()
	_sync_controls()
	_root.show()
	G.block()
	PopochiuUtils.cursor.show_cursor("gui", true)
	get_tree().paused = true
	close_button.grab_focus()


func close_settings() -> void:
	if not is_open:
		return
	_root.hide()
	_settings_rows.show()
	_parent_rows.hide()
	is_open = false
	get_tree().paused = false
	if not _was_blocked:
		G.unblock()
	save_preferences()
	open_button.grab_focus()


func _sync_controls() -> void:
	music_control.set_pressed_no_signal(music_enabled)
	voice_control.set_value_no_signal(voice_volume * 100.0)
	effects_control.set_value_no_signal(effects_volume * 100.0)
	text_control.select(TEXT_SIZES.find(text_size))


func _changed() -> void:
	music_enabled = music_control.button_pressed
	voice_volume = voice_control.value / 100.0
	effects_volume = effects_control.value / 100.0
	text_size = TEXT_SIZES[text_control.selected]
	_apply()
	save_preferences()


func _build_controls() -> void:
	open_button = Button.new()
	open_button.name = "SettingsButton"
	open_button.text = _labels.settings
	open_button.position = Vector2(1320, 16)
	open_button.custom_minimum_size = Vector2(300, 80)
	_style_text(open_button)
	add_child(open_button)
	open_button.pressed.connect(open_settings)
	_root = Control.new()
	_root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(_root)
	var shade := ColorRect.new()
	shade.color = Color(0.06, 0.04, 0.02, 0.7)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_root.add_child(shade)
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_root.add_child(center)
	_panel = PanelContainer.new()
	_panel.custom_minimum_size = Vector2(960, 740)
	var style := StyleBoxFlat.new()
	style.bg_color = Color(1.0, 0.97, 0.89)
	style.border_color = Color(0.43, 0.26, 0.11)
	style.set_border_width_all(6)
	style.set_corner_radius_all(30)
	style.content_margin_left = 48
	style.content_margin_right = 48
	style.content_margin_top = 24
	style.content_margin_bottom = 24
	_panel.add_theme_stylebox_override("panel", style)
	center.add_child(_panel)
	var rows := VBoxContainer.new()
	rows.add_theme_constant_override("separation", 18)
	_panel.add_child(rows)
	_settings_rows = rows
	_parent_rows = VBoxContainer.new()
	_panel.add_child(_parent_rows)
	_parent_rows.hide()
	_parent_data = JSON.parse_string(FileAccess.get_file_as_string("res://game_data/parent_corner.json"))
	rows.add_child(_label(_labels.settings))
	music_control = CheckButton.new()
	music_control.text = _labels.music
	_style_text(music_control)
	rows.add_child(music_control)
	rows.add_child(_label(_labels.no_music, 30))
	voice_control = _slider_row(rows, _labels.voice)
	effects_control = _slider_row(rows, _labels.effects)
	var text_row := HBoxContainer.new()
	rows.add_child(text_row)
	text_control = OptionButton.new()
	text_control.custom_minimum_size = Vector2(380, 80)
	_style_text(text_control)
	for key: String in ["normal", "large", "larger"]:
		text_control.add_item(_labels[key])
	text_control.get_popup().add_theme_font_override("font", ArabicText.get_font())
	text_control.get_popup().add_theme_font_size_override("font_size", 36)
	text_row.add_child(text_control)
	text_row.add_child(_label(_labels.text_size))
	_add_parent_button(rows, _parent_data.title, _show_parent_gate)
	close_button = Button.new()
	close_button.text = _labels.back
	close_button.custom_minimum_size.y = 80
	_style_text(close_button)
	rows.add_child(close_button)
	close_button.pressed.connect(close_settings)
	music_control.toggled.connect(func(_value: bool): _changed())
	voice_control.value_changed.connect(func(_value: float): _changed())
	effects_control.value_changed.connect(func(_value: float): _changed())
	text_control.item_selected.connect(func(_index: int): _changed())
	_sync_controls()
	_root.hide()


func _slider_row(rows: VBoxContainer, caption: String) -> HSlider:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 24)
	rows.add_child(row)
	var slider := HSlider.new()
	slider.custom_minimum_size = Vector2(380, 80)
	slider.max_value = 100
	slider.step = 1
	row.add_child(slider)
	row.add_child(_label(caption))
	return slider


func _label(caption: String, font_size := 36) -> Label:
	var label := Label.new()
	label.text = caption
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_style_text(label, font_size)
	label.add_theme_color_override("font_color", Color(0.25, 0.13, 0.04))
	return label


func _style_text(control: Control, font_size := 36) -> void:
	control.add_theme_font_override("font", ArabicText.get_font())
	control.add_theme_font_size_override("font_size", font_size)
	ArabicText.make_rtl(control)


func _add_parent_button(rows: VBoxContainer, title: String, action: Callable) -> void:
	var button := Button.new()
	button.text = title
	button.custom_minimum_size.y = 64
	_style_text(button)
	rows.add_child(button)
	button.pressed.connect(action)


func _reset_parent_panel() -> void:
	_settings_rows.hide()
	for child in _parent_rows.get_children():
		_parent_rows.remove_child(child)
		child.queue_free()
	_parent_rows.show()
	_parent_rows.add_child(_label(_parent_data.title, 42))


func _show_parent_gate(retry := false) -> void:
	_reset_parent_panel()
	var left := randi_range(18, 48)
	var right := randi_range(14, 39)
	_parent_answer = left + right
	_parent_rows.add_child(_label(_parent_data.retry if retry else _parent_data.gate))
	var question := _label("%d + %d = ؟" % [left, right])
	_parent_rows.add_child(question)
	var answer := LineEdit.new()
	_style_text(answer)
	answer.virtual_keyboard_type = LineEdit.KEYBOARD_TYPE_NUMBER
	answer.max_length = 3
	_parent_rows.add_child(answer)
	var submit := func():
		var value := answer.text.strip_edges()
		for index in 10:
			value = value.replace("٠١٢٣٤٥٦٧٨٩"[index], str(index))
			value = value.replace("۰۱۲۳۴۵۶۷۸۹"[index], str(index))
		if value.is_valid_int() and value.to_int() == _parent_answer:
			_show_parent_lessons()
		else:
			_show_parent_gate(true)
	answer.text_submitted.connect(func(_text: String): submit.call())
	_add_parent_button(_parent_rows, _parent_data.submit, submit)
	_add_parent_button(_parent_rows, _labels.back, _leave_parent)
	answer.grab_focus()


func _show_parent_lessons() -> void:
	_reset_parent_panel()
	var scroll := ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(840, 525)
	_parent_rows.add_child(scroll)
	var lessons := VBoxContainer.new()
	lessons.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	lessons.add_theme_constant_override("separation", 14)
	scroll.add_child(lessons)
	var journey := Globals.on_save()
	for lesson: Array in _parent_data.lessons:
		var state: Dictionary = journey.get(lesson[0], {})
		if state.get(lesson[1], false):
			lessons.add_child(_label(lesson[2], 36))
			var question := _label(lesson[3], 31)
			question.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			lessons.add_child(question)
	if lessons.get_child_count() == 0:
		var empty := _label(_parent_data.empty)
		empty.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		lessons.add_child(empty)
	_add_parent_button(_parent_rows, _labels.back, _leave_parent)


func _leave_parent() -> void:
	_parent_rows.hide()
	_settings_rows.show()
	close_button.grab_focus()
