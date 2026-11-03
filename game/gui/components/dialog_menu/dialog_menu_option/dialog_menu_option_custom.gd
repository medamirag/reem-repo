extends "dialog_menu_option.gd"
## One choice button in Popochiu's own dialog-option strip (not used for the game's own wooden
## choice buttons — see Choices/choice_popup.gd for those — but kept correct in case Popochiu's
## branching dialog system is ever used). Shows its Arabic label in the Cairo font, right to left.


func _ready() -> void:
	super()

	theme = ArabicText.get_theme()

	ArabicText.make_rtl(rich_text_label)

	# The template turns this on so the label shrinks to fit short English option text. For
	# Arabic that backfires: the label shrink-wraps to the text itself, leaving no spare room
	# for [center]/[right] to align into, which is why the text always looked pinned to one
	# side regardless of the bbcode tag. Turning it off lets the label keep the button's full
	# width, so centering actually has room to work.
	rich_text_label.fit_content = false
	rich_text_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL


func set_text(value: String) -> void:
	super(value)

	rich_text_label.text = "[center]%s[/center]" % value
