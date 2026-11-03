extends "hover_text.gd"
## The small text that names whatever the mouse is over.


func _ready() -> void:
	super()

	theme = ArabicText.get_theme()

	ArabicText.make_rtl(label)
