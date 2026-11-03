extends "dialog_menu.gd"
## The panel that holds the choice buttons.


func _ready() -> void:
	super()

	# Two buttons of Arabic text are taller than the template's 98 pixels, and without this
	# the panel would show a scroll bar instead of both choices.
	max_height = 4 * ArabicText.LINE_HEIGHT
