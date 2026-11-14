class_name ReemSubtitleBar
extends Control
## Shared bottom subtitle presentation for characters, narration and system dialogue.
const BOLD := preload("res://assets/fonts/static/Cairo-Bold.ttf")
const INK := Color("4c2e1d")
var panel := PanelContainer.new()
var speaker_label := Label.new()
var text_label := Label.new()
var _revision := 0

func _init() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	z_index = 300
	panel.name = "SubtitlePanel"
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var style := StyleBoxFlat.new()
	style.bg_color = Color("fff3dc")
	style.border_color = Color("d5ba91")
	style.set_border_width_all(2)
	style.set_corner_radius_all(26)
	style.content_margin_left = 38
	style.content_margin_right = 38
	style.content_margin_top = 14
	style.content_margin_bottom = 20
	panel.add_theme_stylebox_override("panel", style)
	add_child(panel)
	var rows := VBoxContainer.new()
	rows.mouse_filter = Control.MOUSE_FILTER_IGNORE
	rows.add_theme_constant_override("separation", 0)
	panel.add_child(rows)
	for label in [speaker_label, text_label]:
		label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		label.add_theme_font_override("font", BOLD)
		label.add_theme_color_override("font_color", INK)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		ArabicText.make_rtl(label)
		rows.add_child(label)
	speaker_label.add_theme_font_size_override("font_size", 26)
	text_label.add_theme_font_size_override("font_size", 44)
	text_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	text_label.clip_text = false
	text_label.text_overrun_behavior = TextServer.OVERRUN_NO_TRIMMING
	speaker_label.hide()

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	resized.connect(_fit)
	_fit()

func setup(text: String, speaker := "") -> void:
	text_label.text = text
	speaker_label.text = speaker
	speaker_label.visible = not speaker.is_empty()
	var chosen_size := 44
	if is_instance_valid(Globals.settings):
		chosen_size = clampi(Globals.settings.text_size, 44, 56)
	text_label.add_theme_font_size_override("font_size", chosen_size)
	if is_inside_tree():
		_fit()

func _fit() -> void:
	_revision += 1
	var revision := _revision
	var screen := get_viewport_rect().size
	panel.position = Vector2(48, screen.y - 224)
	panel.size = Vector2(maxf(280, screen.x - 96), 200)
	# Let Godot shape the complete Arabic string at its actual wrapping width.
	await get_tree().process_frame
	await get_tree().process_frame
	if revision != _revision or not is_inside_tree():
		return
	panel.size.y = maxf(150, panel.get_combined_minimum_size().y)
	panel.position.y = screen.y - 24 - panel.size.y
