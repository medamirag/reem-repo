@tool
extends NpcCharacter
## Grandpa Sulaiman (game_spec.md 3): seated on his bench under the olive tree in the Yard.
## Never walks (bandaged ankle). He is drawn by GrandpaRig (grandpa_rig.gd): breathing, blinking,
## a talking mouth, nods, expressions and a small hand gesture. The original Sprite2D stays in
## the scene, hidden, as the size / place / facing reference (move or scale that one).

const Data := preload("character_jad_state.gd")
const SEATED_PICTURE := "res://assets/cut/grandpa_bench/grandpa_seated.png"

## Turn off to see the old still picture again (for comparison).
@export var use_rig := true
## How far his chest rises when he breathes, in picture pixels.
@export_range(0.0, 8.0) var breathing := 5.0
## How strongly his head moves while he talks.
@export_range(0.0, 2.0) var talk_energy := 1.0

var state: Data = load("res://game/characters/jad/character_jad.tres")

var _rig: GrandpaRig


func _ready() -> void:
	super()
	if Engine.is_editor_hint() or not use_rig:
		return
	var picture := get_node_or_null("Sprite2D") as Sprite2D
	# Only the approved seated picture has a rig (the festival picture keeps the old way).
	if picture == null or picture.texture == null or picture.texture.resource_path != SEATED_PICTURE:
		return
	_rig = GrandpaRig.new()
	_rig.name = "Rig"
	_rig.breathing = breathing
	_rig.talk_energy = talk_energy
	add_child(_rig)
	# Popochiu frees children it does not own when a character leaves a room.
	_rig.owner = self
	_rig.match_picture(picture)
	picture.hide()


func _set_mouth_talking(value: bool) -> void:
	if is_instance_valid(_rig):
		_rig.set_talking(value)
		return
	super(value)


## Called by Lines.say() with the line's tone and text, just before the voice starts.
func animate_line(tone: String, text: String) -> void:
	if not is_instance_valid(_rig):
		return
	var feeling := tone.to_lower()
	var mood := "happy"
	if feeling.contains("sad") or feeling.contains("worried") or feeling.contains("sorry"):
		mood = "sad"
	elif feeling.contains("surpris") or feeling.contains("amazed"):
		mood = "surprised"
	_rig.set_expression(mood)
	if feeling.contains("greet") or _is_greeting(text):
		_rig.greet()
	elif feeling.contains("wise") or feeling.contains("proud") or feeling.contains("asking"):
		_rig.nod()


## True when the line holds the greeting of peace. The diacritics are removed first, so the
## check does not depend on how the line is vowelled (the text itself is never changed).
func _is_greeting(text: String) -> bool:
	var plain := ""
	for index in text.length():
		var code := text.unicode_at(index)
		if (code >= 0x064B and code <= 0x0652) or code == 0x0670 or code == 0x0640:
			continue
		plain += String.chr(code)
	return plain.contains(String.chr(0x0627) + String.chr(0x0644) + String.chr(0x0633) + String.chr(0x0644) + String.chr(0x0627) + String.chr(0x0645))
