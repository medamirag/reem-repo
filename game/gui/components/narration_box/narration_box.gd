class_name NarrationBox
extends ReemSubtitleBar
## Same bottom bar for offscreen dialogue, including screens with Popochiu GUI hidden.
signal clicked
func _init() -> void:
	super()
	mouse_filter = Control.MOUSE_FILTER_STOP
func _gui_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton or event is InputEventScreenTouch) and event.pressed:
		accept_event()
		clicked.emit()
