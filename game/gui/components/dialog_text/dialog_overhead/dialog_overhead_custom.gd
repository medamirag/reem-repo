extends "dialog_overhead.gd"
## The dialogue text that appears above the speaking character.
## Everything here is only about showing Arabic correctly: the Cairo font, a right-to-left
## reading direction, and enough height for one line of Arabic with its vowel marks.


func _ready() -> void:
	super()

	# The theme is set on this node, so the temporary labels Popochiu creates to measure the
	# text (see _calculate_size) use exactly the same font and size as the visible text.
	theme = ArabicText.get_theme()

	ArabicText.make_rtl(rich_text_label)

	# A cream outline keeps the dark letters readable over leaves, reeds and stalls.
	rich_text_label.add_theme_constant_override("outline_size", 12)
	rich_text_label.add_theme_color_override("font_outline_color", Color(1.0, 0.97, 0.88))

	# Popochiu remembers the label's design size and reuses it as the height of a one-line
	# dialogue. The template's 28 pixels were meant for small Latin text, so make room.
	var default_size: Vector2 = get_meta(DFLT_SIZE)
	default_size.y = ArabicText.LINE_HEIGHT * ArabicText.get_theme().default_font_size / 40.0
	set_meta(DFLT_SIZE, default_size)
	rich_text_label.size.y = default_size.y


func _modify_size(msg: String, target_position: Vector2) -> void:
	var default_size: Vector2 = get_meta(DFLT_SIZE)
	default_size.y = ArabicText.LINE_HEIGHT * ArabicText.get_theme().default_font_size / 40.0
	set_meta(DFLT_SIZE, default_size)
	await super(msg, target_position)
