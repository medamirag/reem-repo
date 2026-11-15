@tool
extends NpcCharacter
## Thaaloob the fox (game_spec.md 3): stands next to the big rock in FoxRock, about Reem's height.
## He is drawn by FoxRig (fox_rig.gd): walk, idle, blink, talking mouth and expressions. The
## original Sprite2D stays in the scene, hidden, as the size / place / facing reference.

const Data := preload("character_thaaloob_state.gd")
const BASE_PICTURE := "res://assets/art/characters/fox/fox_base.png"

## Turn off to see the old still picture again (for comparison).
@export var use_rig := true

var state: Data = load("res://game/characters/thaaloob/character_thaaloob.tres")

var _rig: FoxRig


func _ready() -> void:
	super()
	if Engine.is_editor_hint() or not use_rig:
		return
	var picture := get_node_or_null("Sprite2D") as Sprite2D
	if picture == null or picture.texture == null or picture.texture.resource_path != BASE_PICTURE:
		return
	_rig = FoxRig.new()
	_rig.name = "Rig"
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
func animate_line(tone: String, _text: String) -> void:
	if not is_instance_valid(_rig):
		return
	var feeling := tone.to_lower()
	var mood := "happy"
	if feeling.contains("sad") or feeling.contains("worried") or feeling.contains("sorry") \
			or feeling.contains("embarrass") or feeling.contains("asham"):
		mood = "sad"
	elif feeling.contains("surpris") or feeling.contains("amazed"):
		mood = "surprised"
	_rig.set_expression(mood)
