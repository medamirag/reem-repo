class_name GrandpaFestivalRig
extends Node2D
## Grandpa at the festival: he sits cross-legged (carried there, sprained ankle), so no walk.
##
## Same method as GrandpaRig (his chair picture in the Yard), for his festival picture: the
## approved picture is ONE flexible sheet that two invisible "bones" bend gently.
##   Chest: breathing and a small lean while he talks.
##   Head:  nods, slow sway and the talking bob. The eye and mouth patches ride on it.
## His legs and his hands in his lap never move. The festival lines are all warm, so this
## picture has blink and talking mouths only (no sad or surprised face).
##
## Patches come from tools/build_grandpa_festival_face.py (game/characters/jad/festival_rig/).

const PICTURE := "res://assets/art/characters/grandpa/grandpa_festival_seated.png"
const PARTS := "res://game/characters/jad/festival_rig/"
## Lines.say() animates the members of this group when Jad is not a Popochiu character of the room.
const ACTOR_GROUP := "line_actor_Jad"
const HEAD_PIVOT := Vector2(610, 455)
const CHEST_PIVOT := Vector2(620, 820)
const CELL := 14.0
## The line between head (above) and body (below): the lower edge of the beard and hair.
const NECK_LINE: Array[Vector2] = [Vector2(400, 470), Vector2(470, 508), Vector2(560, 514), Vector2(640, 470), Vector2(720, 440), Vector2(820, 430)]

## How far the chest and shoulders rise with each breath, in picture pixels.
@export var breathing := 8.0
## How much the chest widens with each breath (0.012 = 1.2%).
@export var breath_swell := 0.012
## Seconds for one breath in and out.
@export var breath_time := 3.8
## How strongly the head moves while he talks (1 = normal, 0 = still).
@export_range(0.0, 2.0) var talk_energy := 1.0
## Small idle movements (slow head sway, a nod now and then).
@export var idle_life := true

var talking := false

var _picture: Sprite2D
var _source: Texture2D
var _feet := Vector2.ZERO
var _skeleton: Skeleton2D
var _chest: Bone2D
var _head: Bone2D
var _closed_eyes: Sprite2D
var _mouth: Sprite2D
var _mouths := {}
var _rest_chest := Vector2.ZERO
var _time := 0.0
var _talk_time := 0.0
var _talk_weight := 0.0
var _nod := 0.0
var _blink_wait := 3.0
var _blinking := false
var _mouth_wait := 0.0
var _mouth_step := 0
var _idle_wait := 6.0
var _rng := RandomNumberGenerator.new()
var _blink_tween: Tween
var _nod_tween: Tween


func _ready() -> void:
	texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	add_to_group(ACTOR_GROUP)
	_rng.randomize()
	_source = load(PICTURE)
	# Bottom centre of the picture: the rig's own origin.
	_feet = Vector2(_source.get_width() / 2.0, _source.get_height())
	_build_bones()
	_build_sheet()
	_build_face()
	_blink_wait = _rng.randf_range(2.0, 4.5)
	_idle_wait = _rng.randf_range(4.0, 8.0)
	_apply()


## Same size, place and facing as the still picture it replaces.
func match_picture(picture: Sprite2D) -> void:
	_picture = picture
	scale = Vector2(picture.scale.x * (-1.0 if picture.flip_h else 1.0), picture.scale.y)
	var size := picture.texture.get_size() if picture.texture else Vector2.ZERO
	var feet := picture.offset + (Vector2(0, size.y / 2.0) if picture.centered else Vector2(size.x / 2.0, size.y))
	position = picture.position + feet * picture.scale


## Replaces one still festival picture of Grandpa by a rig of the same size, in the same place.
static func attach(picture: Sprite2D) -> GrandpaFestivalRig:
	var rig := GrandpaFestivalRig.new()
	rig.name = "GrandpaRig"
	var holder := picture.get_parent()
	holder.add_child(rig)
	holder.move_child(rig, picture.get_index() + 1)
	rig.match_picture(picture)
	picture.hide()
	return rig


#region Building ####################################################################################
func _build_bones() -> void:
	_skeleton = Skeleton2D.new()
	_skeleton.name = "Skeleton2D"
	add_child(_skeleton)
	var root_bone := _bone("Root", _skeleton, Vector2.ZERO)
	_chest = _bone("Chest", root_bone, CHEST_PIVOT - _feet)
	_head = _bone("Head", _chest, HEAD_PIVOT - CHEST_PIVOT)
	_rest_chest = _chest.position


func _bone(bone_name: String, parent: Node, at: Vector2) -> Bone2D:
	var bone := Bone2D.new()
	bone.name = bone_name
	bone.position = at
	bone.rest = Transform2D(0.0, at)
	bone.set_autocalculate_length_and_angle(false)
	bone.set_length(40.0)
	parent.add_child(bone)
	return bone


## The picture as a grid of squares; every corner follows the bones by its weights.
func _build_sheet() -> void:
	var image := _source.get_image()
	var size := Vector2(image.get_size())
	var columns := int(ceil(size.x / CELL))
	var rows := int(ceil(size.y / CELL))
	var points := PackedVector2Array()
	var uvs := PackedVector2Array()
	var head_w := PackedFloat32Array()
	var chest_w := PackedFloat32Array()
	var root_w := PackedFloat32Array()
	for row in rows + 1:
		for column in columns + 1:
			var p := Vector2(minf(column * CELL, size.x), minf(row * CELL, size.y))
			points.append(p - _feet)
			uvs.append(p)
			var head := _head_weight(p)
			# Shoulders and chest breathe; it fades out towards the lap, which stays still.
			var chest := smoothstep(930.0, 640.0, p.y) * (1.0 - head)
			head_w.append(head)
			chest_w.append(chest)
			root_w.append(maxf(0.0, 1.0 - head - chest))
	var squares: Array = []
	for row in rows:
		for column in columns:
			var area := Rect2i(int(column * CELL) - 1, int(row * CELL) - 1, int(CELL) + 2, int(CELL) + 2)
			area = area.intersection(Rect2i(Vector2i.ZERO, image.get_size()))
			if image.get_region(area).is_invisible():
				continue
			var a := row * (columns + 1) + column
			squares.append(PackedInt32Array([a, a + 1, a + columns + 2, a + columns + 1]))
	var sheet := Polygon2D.new()
	sheet.name = "Sheet"
	sheet.texture = _source
	sheet.polygon = points
	sheet.uv = uvs
	sheet.polygons = squares
	_skeleton.add_child(sheet)
	_skeleton.move_child(sheet, 0)
	sheet.skeleton = sheet.get_path_to(_skeleton)
	sheet.add_bone(_skeleton.get_path_to(_skeleton.get_node("Root")), root_w)
	sheet.add_bone(_skeleton.get_path_to(_chest), chest_w)
	sheet.add_bone(_skeleton.get_path_to(_head), head_w)


func _head_weight(p: Vector2) -> float:
	# Height of the neck line under/over this point, then a soft band of +-14 pixels around it.
	var line_y := NECK_LINE[0].y
	if p.x >= NECK_LINE[-1].x:
		line_y = NECK_LINE[-1].y
	else:
		for index in NECK_LINE.size() - 1:
			var a := NECK_LINE[index]
			var b := NECK_LINE[index + 1]
			if p.x >= a.x and p.x <= b.x:
				line_y = lerpf(a.y, b.y, (p.x - a.x) / (b.x - a.x))
	return smoothstep(14.0, -14.0, p.y - line_y)


func _build_face() -> void:
	var layout: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(PARTS + "face_layout.json"))
	_closed_eyes = _patch("EyesClosed", "eyes_closed", layout.eyes_box)
	_mouth = _patch("Mouth", "mouth_open", layout.mouth_box)
	for shape in ["half", "open"]:
		_mouths[shape] = load(PARTS + "mouth_%s.png" % shape)


func _patch(node_name: String, file: String, box: Array) -> Sprite2D:
	var sprite := Sprite2D.new()
	sprite.name = node_name
	sprite.texture = load(PARTS + file + ".png")
	sprite.centered = false
	sprite.position = Vector2(box[0], box[1]) - HEAD_PIVOT
	sprite.hide()
	_head.add_child(sprite)
	return sprite


#endregion

#region Animation ###################################################################################
func _process(delta: float) -> void:
	if is_instance_valid(_picture):
		match_picture(_picture)
	_time += delta
	_talk_weight = move_toward(_talk_weight, 1.0 if talking else 0.0, delta / 0.25)
	if talking:
		_talk_time += delta
		_mouth_wait -= delta
		if _mouth_wait <= 0.0:
			_mouth_step = (_mouth_step + 1) % 4
			_mouth_wait = _rng.randf_range(0.07, 0.13)
			_show_mouth(["closed", "half", "open", "half"][_mouth_step])
	_blink_wait -= delta
	if _blink_wait <= 0.0 and not _blinking:
		blink()
	if idle_life and not talking:
		_idle_wait -= delta
		if _idle_wait <= 0.0:
			_idle_wait = _rng.randf_range(6.0, 11.0)
			nod(0.035, 0.55)
	_apply()


func _apply() -> void:
	var breath := 0.5 - 0.5 * cos(_time * TAU / breath_time)
	var talk_bob := sin(_talk_time * 9.5) * 0.6 + sin(_talk_time * 5.3 + 1.0) * 0.4
	_chest.position = _rest_chest + Vector2(0, -breathing * breath)
	_chest.scale = Vector2(1.0 + breath_swell * breath, 1.0 + breath_swell * 0.5 * breath)
	_head.scale = Vector2.ONE / _chest.scale
	# He faces left in this picture: a negative angle lowers his face.
	_chest.rotation = -0.008 * _talk_weight * talk_energy - 0.004 * _talk_weight * talk_bob
	var sway := sin(_time * TAU / 7.3) * 0.010 if idle_life else 0.0
	_head.rotation = sway * (1.0 - _talk_weight) - _nod - 0.022 * talk_bob * _talk_weight * talk_energy
	_head.position.y = (HEAD_PIVOT - CHEST_PIVOT).y - breathing * 0.25 * breath


func set_talking(value: bool) -> void:
	if talking == value:
		return
	talking = value
	_mouth_step = 0
	_mouth_wait = 0.0
	_show_mouth("closed")
	if value:
		_talk_time = 0.0


## Called by Lines.say() just before the voice starts: a kind nod opens most of his lines.
func react_to_line(_tone: String, _text := "") -> void:
	nod(0.05, 0.4)


func blink() -> void:
	if _blinking:
		return
	_blinking = true
	_closed_eyes.show()
	_closed_eyes.modulate.a = 0.0
	_blink_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	_blink_tween.tween_property(_closed_eyes, "modulate:a", 1.0, 0.06)
	_blink_tween.tween_interval(0.06)
	_blink_tween.tween_property(_closed_eyes, "modulate:a", 0.0, 0.09)
	await _blink_tween.finished
	_closed_eyes.hide()
	_blinking = false
	_blink_wait = _rng.randf_range(2.5, 5.5)


## A slow, kind nod.
func nod(depth := 0.06, time := 0.4) -> void:
	if is_instance_valid(_nod_tween):
		_nod_tween.kill()
	_nod_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	_nod_tween.tween_property(self, "_nod", depth, time)
	_nod_tween.tween_property(self, "_nod", 0.0, time * 1.2)


func _show_mouth(shape: String) -> void:
	# "closed" is the smile already drawn in the picture: no patch needed.
	_mouth.visible = shape != "closed"
	if _mouth.visible:
		_mouth.texture = _mouths[shape]


#endregion

#region Review ######################################################################################
## Freezes the rig in one exact pose, for the review pictures (tools/fable_review.gd).
func pose_for_review(pose: Dictionary) -> void:
	set_process(false)
	for tween in [_blink_tween, _nod_tween]:
		if is_instance_valid(tween):
			tween.kill()
	var breath := float(pose.get("breath", 0.0))
	_chest.position = _rest_chest + Vector2(0, -breathing * breath)
	_chest.scale = Vector2(1.0 + breath_swell * breath, 1.0 + breath_swell * 0.5 * breath)
	_head.scale = Vector2.ONE / _chest.scale
	_chest.rotation = float(pose.get("lean", 0.0))
	_head.position = HEAD_PIVOT - CHEST_PIVOT
	_head.rotation = float(pose.get("head", 0.0))
	_closed_eyes.visible = bool(pose.get("blink", false))
	_closed_eyes.modulate.a = 1.0
	var mouth := str(pose.get("mouth", "closed"))
	_mouth.visible = mouth != "closed"
	if _mouth.visible:
		_mouth.texture = _mouths[mouth]


#endregion
