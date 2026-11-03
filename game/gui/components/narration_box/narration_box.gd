class_name NarrationBox
extends Control
## A line spoken by someone who is not on screen (game_spec.md 4.1: "show the text without a
## character in the scene"): Arabic text in a soft rounded box near the bottom of the screen.
## Covers the whole screen so a click anywhere skips the line, like normal dialogue.

signal clicked

## Distance of the box from the bottom of the screen, in pixels.
const BOTTOM_MARGIN := 70
const BOX_WIDTH := 1400

var _label := RichTextLabel.new()


func _init() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP

	var panel := PanelContainer.new()
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.17, 0.10, 0.04, 0.82)
	style.set_corner_radius_all(24)
	style.content_margin_left = 40
	style.content_margin_right = 40
	style.content_margin_top = 18
	style.content_margin_bottom = 18
	panel.add_theme_stylebox_override("panel", style)
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.anchor_left = 0.5
	panel.anchor_right = 0.5
	panel.anchor_top = 1.0
	panel.anchor_bottom = 1.0
	panel.offset_left = -BOX_WIDTH / 2.0
	panel.offset_right = BOX_WIDTH / 2.0
	panel.grow_vertical = Control.GROW_DIRECTION_BEGIN
	panel.offset_top = -BOTTOM_MARGIN
	panel.offset_bottom = -BOTTOM_MARGIN
	add_child(panel)

	_label.bbcode_enabled = true
	_label.fit_content = true
	_label.scroll_active = false
	_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_label.theme = ArabicText.get_theme()
	_label.add_theme_color_override("default_color", Color(1, 0.97, 0.9))
	ArabicText.make_rtl(_label)
	panel.add_child(_label)


func setup(text: String) -> void:
	_label.text = "[center]%s[/center]" % text


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		accept_event()
		clicked.emit()
	elif event is InputEventScreenTouch and event.pressed:
		accept_event()
		clicked.emit()
