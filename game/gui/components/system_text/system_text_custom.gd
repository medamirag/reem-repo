extends "system_text.gd"
var subtitle: ReemSubtitleBar
func _ready() -> void:
	super()
	rich_text_label.hide()
	subtitle = ReemSubtitleBar.new()
	subtitle.name = "SubtitleBar"
	add_child(subtitle)
func _show_text(msg := "") -> void:
	if msg.is_empty():
		close()
		return
	subtitle.setup(msg)
	appear()
