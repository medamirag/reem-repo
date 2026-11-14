@tool
extends Node
## Speaks the dialogue lines stored in `game_data/lines.json`.
##
## This is the single helper described in game_spec.md 4.1: it reads the line, shows its Arabic
## text through the Popochiu dialogue text, plays its audio at the same time, and waits until the
## audio has finished (plus a short pause) before returning. Clicking skips to the end of the line.
##
## Registered as the autoload `Lines`, so any room can call `await Lines.say("reem_s1_002")`.

## Where the dialogue lines live.
const LINES_PATH := "res://game_data/lines.json"
## Extra silence after the voice finishes, before the next line starts (game_spec.md 4.1).
const PAUSE_AFTER_LINE := 0.3

var _lines := {}
## Every line ID said so far in this run (used by the automatic playtest, tools/playtest.gd).
var said := {}
## True while a line is being spoken (word discovery waits until it is over).
var busy := false
var _voice: AudioStreamPlayer = null
var _line_serial := 0


#region Godot ######################################################################################
func _ready() -> void:
	if Engine.is_editor_hint():
		return

	_voice = AudioStreamPlayer.new()
	_voice.bus = ReemSettings.VOICE_BUS
	_voice.name = "Voice"
	_voice.finished.connect(func():
		if is_instance_valid(C.player) and C.player.has_method("_set_mouth_talking"):
			C.player._set_mouth_talking(false))
	add_child(_voice)

	_load_lines()


#endregion

#region Public #####################################################################################
## Returns `true` if `line_id` exists in lines.json.
func has_line(line_id: String) -> bool:
	return _lines.has(line_id)


## Returns the Arabic text of `line_id`, or an empty string if there is no such line.
func get_text(line_id: String) -> String:
	if not _lines.has(line_id):
		push_error("[Lines] There is no line with the id '%s' in %s" % [line_id, LINES_PATH])
		return ""

	return str((_lines[line_id] as Dictionary).get("text", ""))


## Makes the line's speaker say it: Arabic text on screen and the matching audio file, together.
## Returns once the line is over, so lines can be chained with `await`.
func say(line_id: String, narrate := false) -> void:
	if not _lines.has(line_id):
		push_error("[Lines] There is no line with the id '%s' in %s" % [line_id, LINES_PATH])
		return

	said[line_id] = true
	_line_serial += 1
	var serial := _line_serial
	busy = true
	var line: Dictionary = _lines[line_id]
	var speaker := str(line.get("speaker", ""))
	var text := str(line.get("text", ""))

	# The speaker talks above their head only if they are standing in the current room. Lines
	# spoken off screen (jad_s1_031 in the Gate, jad_s2_071 on the end screen) are shown in a
	# narration box at the bottom of the screen instead (game_spec.md 4.1).
	var character: PopochiuCharacter = null
	if not narrate and is_instance_valid(R.current) and R.current.has_character(speaker):
		character = C.get_character(speaker)

	if character != null and character.has_method("animate_line"):
		character.animate_line(str(line.get("tone", "")), text)
	var voice_length := _start_voice(str(line.get("audio", "")))
	# Unrecorded text must remain readable, rather than vanish after 0.3 seconds.
	if voice_length <= 0.0:
		voice_length = maxf(2.0, text.length() * 0.055)

	if character == null:
		await _say_offscreen(text, voice_length)
	else:
		# Runs on its own: closes the line once the voice is done, unless the player clicked first.
		_close_line_after(character, voice_length, serial)
		await character.say(text)

	if _voice.playing:
		_voice.stop()
	if character != null and character.has_method("_set_mouth_talking"):
		character._set_mouth_talking(false)
	busy = false


#endregion

#region Private ####################################################################################
func _load_lines() -> void:
	var file := FileAccess.open(LINES_PATH, FileAccess.READ)

	if file == null:
		push_error("[Lines] Could not open %s" % LINES_PATH)
		return

	var parsed: Variant = JSON.parse_string(file.get_as_text())
	file.close()

	if typeof(parsed) != TYPE_DICTIONARY:
		push_error("[Lines] %s does not contain a JSON object" % LINES_PATH)
		return

	_lines = parsed


# Starts the voice file and returns how long it lasts, in seconds (0.0 when there is no audio).
func _start_voice(audio_path: String) -> float:
	_voice.stop()

	if audio_path.is_empty() or not ResourceLoader.exists(audio_path):
		push_warning("[Lines] Missing audio file: %s" % audio_path)
		return 0.0

	var stream := load(audio_path) as AudioStream

	if stream == null:
		push_warning("[Lines] %s is not an audio file" % audio_path)
		return 0.0

	_voice.stream = stream
	_voice.play()

	return stream.get_length()


# Shows `text` in a box at the bottom of the screen (no character speaks it), until the voice
# ends or the child clicks. Lives on its own CanvasLayer, so it also works on screens that hide
# Popochiu's GUI (the end screen).
func _say_offscreen(text: String, voice_length: float) -> void:
	var layer := CanvasLayer.new()
	layer.layer = 50
	add_child(layer)

	var box := NarrationBox.new()
	box.setup(text)
	layer.add_child(box)

	var finished := [false]
	var finish := func() -> void:
		finished[0] = true
	box.clicked.connect(finish)
	get_tree().create_timer(voice_length + PAUSE_AFTER_LINE).timeout.connect(finish)

	while not finished[0]:
		await get_tree().process_frame

	layer.queue_free()


func _close_line_after(character: PopochiuCharacter, voice_length: float, serial: int) -> void:
	await get_tree().create_timer(voice_length + PAUSE_AFTER_LINE).timeout
	# Popochiu measures Arabic over several rendered frames before showing the label.
	# A very short/missing recording can finish during that preparation on a slow GPU.
	var dialog := G.gui.get_node_or_null("DialogOverheadHighRes") as Control
	while serial == _line_serial and is_instance_valid(character) and character.is_talking \
			and is_instance_valid(dialog) and is_zero_approx(dialog.modulate.a):
		await get_tree().process_frame

	# If the player already clicked to skip, the character has stopped talking by now.
	if serial == _line_serial and is_instance_valid(character) and character.is_talking:
		character.stop_talking()


#endregion
