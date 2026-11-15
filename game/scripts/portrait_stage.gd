class_name PortraitStage
extends Node
## The speaker's portrait for the subtitle bar: a small hidden stage per speaker where the
## character's REAL rig stands, framed on the face. So the portrait blinks, moves its mouth and
## shows the mood of the line exactly like the character in the room.
##
## Child of the `Lines` autoload. Lines.say() calls `start()` before the voice and `stop()` after;
## the subtitle bar (ReemSubtitleBar) shows `texture_for(speaker)` in a round frame.
## Stages are built the first time a speaker talks and then kept.

const SIZE := 320
## Per speaker: where the middle of the face is, in the rig's own coordinates (feet = 0,0), and
## how many of its pixels the round frame shows across. flip = mirror, so the portrait looks
## towards the text (Reem sits on the right and looks left; the others on the left look right).
const FACES := {
	"Reem": {"centre": Vector2(40, -1000), "span": 470.0, "flip": true},
	"Jad": {"centre": Vector2(-42, -815), "span": 370.0, "flip": false},
	"Thaaloob": {"centre": Vector2(40, -1000), "span": 540.0, "flip": false},
	"Shahd": {"centre": Vector2(150, -20), "span": 400.0, "flip": false},
}
const PAPER := Color("ffe9c4")

var speaker := ""

var _stages := {}
var _talking := false


func has_portrait(who: String) -> bool:
	return FACES.has(who)


func texture_for(who: String) -> Texture2D:
	if not FACES.has(who):
		return null
	return (_stage(who).view as SubViewport).get_texture()


## The line of `who` begins: mood of the line, mouth moving.
func start(who: String, tone: String, text: String) -> void:
	stop()
	if not FACES.has(who):
		return
	speaker = who
	var stage: Dictionary = _stage(who)
	(stage.view as SubViewport).render_target_update_mode = SubViewport.UPDATE_ALWAYS
	var rig: Node = stage.rig
	if rig.has_method("react_to_line"):
		rig.react_to_line(tone, text)
	elif rig.has_method("set_expression"):
		rig.set_expression(mood_of(tone))
	set_talking(true)


## The voice is over (or the child skipped the line): the mouth closes.
func set_talking(value: bool) -> void:
	if speaker.is_empty() or _talking == value:
		return
	_talking = value
	var rig: Node = _stages[speaker].rig
	if rig.has_method("set_talking"):
		rig.set_talking(value)
	elif "talking" in rig:
		rig.talking = value


func stop() -> void:
	if speaker.is_empty():
		return
	set_talking(false)
	var stage: Dictionary = _stages[speaker]
	if stage.rig.has_method("set_expression"):
		stage.rig.set_expression("happy")
	# One more picture with the closed mouth, then the stage rests.
	(stage.view as SubViewport).render_target_update_mode = SubViewport.UPDATE_ONCE
	speaker = ""


static func mood_of(tone: String) -> String:
	var feeling := tone.to_lower()
	if feeling.contains("sad") or feeling.contains("worried") or feeling.contains("sorry") \
			or feeling.contains("asham"):
		return "sad"
	if feeling.contains("surpris") or feeling.contains("amazed") or feeling.contains("startled"):
		return "surprised"
	return "happy"


func _stage(who: String) -> Dictionary:
	if _stages.has(who):
		return _stages[who]
	var face: Dictionary = FACES[who]
	var view := SubViewport.new()
	view.name = who + "Portrait"
	view.size = Vector2i(SIZE, SIZE)
	view.transparent_bg = false
	view.disable_3d = true
	view.render_target_update_mode = SubViewport.UPDATE_ONCE
	add_child(view)
	var paper := ColorRect.new()
	paper.color = PAPER
	paper.size = Vector2(SIZE, SIZE)
	view.add_child(paper)
	var holder := Node2D.new()
	holder.name = "Holder"
	var zoom: float = SIZE / float(face.span)
	holder.scale = Vector2(-zoom if face.flip else zoom, zoom)
	var centre: Vector2 = face.centre
	holder.position = Vector2(SIZE, SIZE) / 2.0 - centre * holder.scale
	view.add_child(holder)
	var rig := _build(who)
	holder.add_child(rig)
	_stages[who] = {"view": view, "rig": rig}
	return _stages[who]


func _build(who: String) -> Node:
	match who:
		"Reem":
			return (load("res://game/characters/reem/reem_cutout.tscn") as PackedScene).instantiate()
		"Jad":
			return GrandpaRig.new()
		"Thaaloob":
			return FoxRig.new()
	# Shahd: her body picture with the blink of her light rig and her own talking mouth
	# (same pictures and numbers as game/characters/shahd/character_shahd.tscn).
	var body := Sprite2D.new()
	body.texture = load("res://assets/cut/bees_sheet/shahd_body.png")
	var wings := Sprite2D.new()
	wings.texture = load("res://assets/cut/bees_sheet/shahd_wings.png")
	wings.show_behind_parent = true
	wings.position = Vector2(30, -185)
	body.add_child(wings)
	var mouth := TalkingMouth.new()
	mouth.name = "Mouth"
	mouth.open_texture = load("res://assets/cut/bees_sheet/mouth_open.png")
	mouth.closed_texture = load("res://assets/cut/bees_sheet/mouth_closed.png")
	mouth.closed_scale = 0.55
	mouth.open_scale = 0.6
	mouth.position = Vector2(172, 52)
	body.add_child(mouth)
	return ShahdPortrait.new(body, mouth)


## Shahd's portrait actor: forwards talking to her mouth node.
class ShahdPortrait extends Node2D:
	var mouth: TalkingMouth

	func _init(body: Sprite2D, mouth_node: TalkingMouth) -> void:
		mouth = mouth_node
		add_child(body)

	func _ready() -> void:
		LightRig.dress(self)

	func set_talking(value: bool) -> void:
		mouth.talking = value
