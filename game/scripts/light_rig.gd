class_name LightRig
extends Node
## Small life for a character that stays ONE still picture (Shahd and the valley animals):
## blinking, a talking mouth, breathing, a small bounce while talking or listening, and a
## swaying tail or ears.
##
## It is a child of the picture (a Sprite2D) and only gives it a shader
## (light_rig.gdshader): the picture's own place, size, flip and animation by the room are
## never touched. `LightRig.dress(room)` adds one to every picture it knows.
##
## Patches: game/light_rigs/<name>/ (tools/build_light_faces.py). Tail and ears pieces:
## game/rig_parts/<name>/tail.png or ears.png (cut from the picture by Codex).

const RIGS := "res://game/light_rigs/"
const PARTS := "res://game/rig_parts/"
const SHADER := preload("res://game/scripts/light_rig.gdshader")
## Per character: breathing (fraction of the picture's height), sway of tail/ears in degrees.
## Shahd hovers and has wing and mouth layers of her own: she only blinks.
const STYLE := {
	"bees": {"breath": 0.0, "bounce": 0.0},
	"ankoob": {"breath": 0.0, "bounce": 0.0},
	"tawoos": {"sway": 1.0},
	"arnoob": {"sway": 2.0},
	"dubb": {"sway": 2.5},
	"qunfood": {"sway": 2.5},
}

## Seconds for one breath in and out.
@export var breath_time := 3.2
## How high the picture hops while talking, as a fraction of its height.
@export var bounce := 0.018
## False keeps the tail or ears still (for a scene that needs it).
@export var sway := true

var talking := false
var character := ""
var speaker := ""

var _picture: Sprite2D
var _material: ShaderMaterial
var _mouths := {}
var _breath := 0.012
var _sway_degrees := 3.5
var _has_extra := false
var _time := 0.0
var _talk_time := 0.0
var _talk_weight := 0.0
var _blink_wait := 3.0
var _blink := 0.0
var _blink_tween: Tween
var _mouth_wait := 0.0
var _mouth_step := 0
var _flick := 0.0
var _flick_wait := 5.0
var _rng := RandomNumberGenerator.new()

## Picture file -> character folder, read once from the layout files.
static var _known := {}
## The prop or character Reem is talking with right now: it bounces softly while lines play,
## even when Reem tells the story for it (the animals have no recorded voice yet).
static var _partner: Node


## Gives a LightRig to every picture under `root` that shows a known character.
static func dress(root: Node) -> void:
	if _known.is_empty():
		for folder: String in DirAccess.get_directories_at(RIGS):
			var layout: Variant = JSON.parse_string(FileAccess.get_file_as_string(RIGS + folder + "/layout.json"))
			if layout is Dictionary:
				_known["res://" + str(layout.source)] = folder
	for node in root.find_children("*", "Sprite2D", true, false):
		var picture := node as Sprite2D
		if picture.texture == null or not _known.has(picture.texture.resource_path):
			continue
		if picture.has_node("LightRig") or picture.material != null:
			continue
		var rig := LightRig.new()
		rig.name = "LightRig"
		rig.character = _known[picture.texture.resource_path]
		picture.add_child(rig)


## Called by ReemRoom when the child clicks something: the rigs under it listen and react.
static func talk_with(partner: Node) -> void:
	_partner = partner


func _ready() -> void:
	_picture = get_parent() as Sprite2D
	if _picture == null or character.is_empty():
		set_process(false)
		return
	_rng.randomize()
	var folder := RIGS + character + "/"
	var layout: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(folder + "layout.json"))
	var style: Dictionary = STYLE.get(character, {})
	var size := Vector2(layout.canvas[0], layout.canvas[1])
	speaker = str(layout.get("speaker", ""))
	if not speaker.is_empty():
		# Lines.say() moves the mouth of this group when the speaker is not a Popochiu character.
		add_to_group("line_actor_" + speaker)
	_breath = float(style.get("breath", 0.012)) * size.y
	bounce = float(style.get("bounce", bounce))
	_sway_degrees = float(style.get("sway", 3.5))

	_material = ShaderMaterial.new()
	_material.shader = SHADER
	_material.set_shader_parameter("canvas", size)
	_material.set_shader_parameter("eyes_tex", load(folder + "eyes_closed.png"))
	_material.set_shader_parameter("eyes_rect", _rect(layout.eyes_box, size))
	if layout.has("mouth_box"):
		for shape: String in ["half", "open"]:
			_mouths[shape] = load(folder + "mouth_%s.png" % shape)
		_material.set_shader_parameter("mouth_tex", _mouths["open"])
		_material.set_shader_parameter("mouth_rect", _rect(layout.mouth_box, size))
	for piece: String in ["tail", "ears"]:
		var path := PARTS + character + "/" + piece + ".png"
		if layout.has("extra_anchor") and ResourceLoader.exists(path):
			_has_extra = true
			_material.set_shader_parameter("extra_tex", load(path))
			_material.set_shader_parameter("extra_anchor", Vector2(layout.extra_anchor[0], layout.extra_anchor[1]))
	_picture.material = _material
	_blink_wait = _rng.randf_range(1.5, 5.0)
	_flick_wait = _rng.randf_range(3.0, 8.0)
	_time = _rng.randf_range(0.0, 10.0)


func _rect(box: Array, size: Vector2) -> Vector4:
	return Vector4(box[0] / size.x, box[1] / size.y, (box[2] - box[0]) / size.x, (box[3] - box[1]) / size.y)


func _process(delta: float) -> void:
	_time += delta
	var listening := Lines.busy and is_instance_valid(_partner) and _partner.is_ancestor_of(self)
	_talk_weight = move_toward(_talk_weight, 1.0 if talking or listening else 0.0, delta / 0.25)
	if talking or listening:
		_talk_time += delta
	if talking and not _mouths.is_empty():
		_mouth_wait -= delta
		if _mouth_wait <= 0.0:
			_mouth_step = (_mouth_step + 1) % 4
			_mouth_wait = _rng.randf_range(0.07, 0.13)
			_show_mouth(["closed", "half", "open", "half"][_mouth_step])
	_blink_wait -= delta
	if _blink_wait <= 0.0:
		blink()
	_flick_wait -= delta
	if _flick_wait <= 0.0:
		_flick_wait = _rng.randf_range(4.0, 9.0)
		var flick := create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		flick.tween_property(self, "_flick", 1.0, 0.16)
		flick.tween_property(self, "_flick", -0.5, 0.2)
		flick.tween_property(self, "_flick", 0.0, 0.25)

	var breath := 0.5 - 0.5 * cos(_time * TAU / breath_time)
	# Two soft hops a second while talking; slower and smaller while listening.
	var speed := 2.2 if talking else 1.3
	var height := bounce * (1.0 if talking else 0.55)
	var hop := absf(sin(_talk_time * PI * speed)) * height * _picture.texture.get_height() * _talk_weight
	_material.set_shader_parameter("breath", _breath * breath)
	_material.set_shader_parameter("lift", hop)
	_material.set_shader_parameter("blink", _blink)
	var swaying := sway and _has_extra
	_material.set_shader_parameter("extra_on", 1.0 if swaying else 0.0)
	if swaying:
		var angle := sin(_time * TAU / 2.9) * 0.6 + sin(_time * TAU / 1.7 + 1.0) * 0.25 + _flick * 0.8
		_material.set_shader_parameter("extra_angle", deg_to_rad(_sway_degrees) * angle)


func set_talking(value: bool) -> void:
	if talking == value:
		return
	talking = value
	_mouth_step = 0
	_mouth_wait = 0.0
	_show_mouth("closed")


## Called by Lines.say() just before the voice starts.
func react_to_line(_tone: String, _text := "") -> void:
	pass


func blink() -> void:
	_blink_wait = _rng.randf_range(2.5, 6.0)
	if is_instance_valid(_blink_tween):
		_blink_tween.kill()
	_blink_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	_blink_tween.tween_property(self, "_blink", 1.0, 0.06)
	_blink_tween.tween_interval(0.07)
	_blink_tween.tween_property(self, "_blink", 0.0, 0.09)


func _show_mouth(shape: String) -> void:
	# "closed" is the smile already drawn in the picture: no patch needed.
	if _material == null or _mouths.is_empty():
		return
	_material.set_shader_parameter("mouth_on", 0.0 if shape == "closed" else 1.0)
	if shape != "closed":
		_material.set_shader_parameter("mouth_tex", _mouths[shape])


## Freezes one exact pose, for review pictures and checks.
func pose_for_review(pose: Dictionary) -> void:
	set_process(false)
	if is_instance_valid(_blink_tween):
		_blink_tween.kill()
	_material.set_shader_parameter("breath", _breath * float(pose.get("breath", 0.0)))
	_material.set_shader_parameter("lift", float(pose.get("hop", 0.0)) * bounce * _picture.texture.get_height())
	_material.set_shader_parameter("blink", 1.0 if pose.get("blink", false) else 0.0)
	_show_mouth(str(pose.get("mouth", "closed")))
	_material.set_shader_parameter("extra_on", 1.0 if _has_extra and pose.has("sway") else 0.0)
	_material.set_shader_parameter("extra_angle", deg_to_rad(_sway_degrees) * float(pose.get("sway", 0.0)))
