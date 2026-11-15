class_name ReemSubtitleBar
extends Control
## Shared bottom subtitle presentation for characters, narration and system dialogue.
const BOLD := preload("res://assets/fonts/static/Cairo-Bold.ttf")
const INK := Color("4c2e1d")
var panel := PanelContainer.new()
var speaker_label := Label.new()
var text_label := Label.new()
var _revision := 0
## Round picture of the speaker: Reem on the right, everyone else on the left.
var portrait := TextureRect.new()
var _portrait_side := 0
const PORTRAIT_SIZE := 176.0
const PORTRAIT_SHADER := "shader_type canvas_item;\nvoid fragment() {\n\tfloat d = distance(UV, vec2(0.5));\n\tvec4 c = texture(TEXTURE, UV);\n\tvec3 ring = vec3(0.43, 0.26, 0.11);\n\tc.rgb = mix(c.rgb, ring, smoothstep(0.455, 0.465, d));\n\tc.a = 1.0 - smoothstep(0.492, 0.5, d);\n\tCOLOR = c;\n}\n"

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
	add_to_group("subtitle_bars")
	portrait.name = "Portrait"
	portrait.mouse_filter = Control.MOUSE_FILTER_IGNORE
	portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	portrait.stretch_mode = TextureRect.STRETCH_SCALE
	portrait.size = Vector2.ONE * PORTRAIT_SIZE
	var round_frame := Shader.new()
	round_frame.code = PORTRAIT_SHADER
	var frame_material := ShaderMaterial.new()
	frame_material.shader = round_frame
	portrait.material = frame_material
	portrait.hide()
	add_child(portrait)

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
	_show_portrait(Lines.current_speaker if Lines.busy else "")
	if is_inside_tree():
		_fit()

## Shows the round picture of `who` (nothing for "" or a speaker without a portrait) and keeps
## the text clear of it.
func _show_portrait(who: String) -> void:
	var picture: Texture2D = Lines.portraits.texture_for(who) if is_instance_valid(Lines.portraits) else null
	portrait.texture = picture
	portrait.visible = picture != null
	_portrait_side = 0 if picture == null else (1 if who == "Reem" else -1)
	var style := panel.get_theme_stylebox("panel") as StyleBoxFlat
	var room := PORTRAIT_SIZE + 20.0
	style.content_margin_left = 38 + (room if _portrait_side < 0 else 0.0)
	style.content_margin_right = 38 + (room if _portrait_side > 0 else 0.0)
	text_label.custom_minimum_size.y = 0.0 if picture == null else PORTRAIT_SIZE - 40.0
	_place_portrait()


func _place_portrait() -> void:
	var x := panel.position.x + 24.0 if _portrait_side < 0 else panel.position.x + panel.size.x - 24.0 - PORTRAIT_SIZE
	portrait.position = Vector2(x, panel.position.y + (panel.size.y - PORTRAIT_SIZE) / 2.0)


func _fit() -> void:
	_revision += 1
	var revision := _revision
	var screen := get_viewport_rect().size
	panel.position = Vector2(48, screen.y - 224)
	panel.size = Vector2(maxf(280, screen.x - 96), 200)
	_place_portrait()
	# Let Godot shape the complete Arabic string at its actual wrapping width.
	await get_tree().process_frame
	await get_tree().process_frame
	if revision != _revision or not is_inside_tree():
		return
	panel.size.y = maxf(150, panel.get_combined_minimum_size().y)
	panel.position.y = screen.y - 24 - panel.size.y
	_place_portrait()
