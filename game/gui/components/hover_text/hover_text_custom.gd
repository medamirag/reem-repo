extends "hover_text.gd"
## The small text that names whatever the mouse is over.


func _ready() -> void:
	super()

	theme = ArabicText.get_theme()

	ArabicText.make_rtl(label)


# Popochiu's hover text is English ("Use X with Y"); this game shows none (docs/BUGS.md #9).
func _show_text(_txt := "") -> void:
	label.text = ""
