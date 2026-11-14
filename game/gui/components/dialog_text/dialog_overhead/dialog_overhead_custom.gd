extends "dialog_overhead.gd"
## Keep Popochiu's speech lifecycle, but present every character in one bottom bar.
var subtitle: ReemSubtitleBar
var _speaker := ""

func _ready() -> void:
	super()
	rich_text_label.hide()
	continue_icon.hide()
	subtitle = ReemSubtitleBar.new()
	subtitle.name = "SubtitleBar"
	add_child(subtitle)
	z_index = 300

func _show_dialogue(character: PopochiuCharacter, msg := "") -> void:
	_speaker = ""
	# A name is optional; never expose an English internal character identifier.
	for index in character.description.length():
		var codepoint := character.description.unicode_at(index)
		if codepoint >= 0x0600 and codepoint <= 0x06ff:
			_speaker = character.description
			break
	super(character, msg)

func play_text(props: Dictionary) -> void:
	_is_waiting_input = true
	_auto_continue = false
	# Full text appears at once: no typewriter slice through Arabic or voice-time truncation.
	rich_text_label.text = props.text
	rich_text_label.visible_ratio = 1.0
	subtitle.setup(props.text, _speaker)
	modulate.a = 1.0
	set_process_input(true)

func _show_icon() -> void:
	continue_icon.hide()
