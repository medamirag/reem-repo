class_name GrandpaRig
extends Node2D
## Grandpa's seated rig. He stays on his chair (sprained ankle), so there is no walk.
##
## The approved picture is shown as ONE flexible sheet (a grid of small squares) instead of cut
## pieces, so there are no seams: three invisible "bones" bend it gently.
##   Chest: breathing and a small lean while he talks.
##   Head:  nods, tilts and the talking bob. The eyes and mouth patches ride on it.
##   Hand:  the hand on his knee lifts a little (gestures and finger taps).
## The chair, stool, legs and cane never move.
##
## Small patches come from tools/build_grandpa_face.py (game/characters/jad/rig/):
##   eyes_closed, mouth_* (talking, sad, surprised), face_sad / face_surprised (eyebrows,
##   eyelids, wider eyes), and the greeting arm: arm_cover hides the forearm of the picture
##   while arm_fore (his right forearm and hand) turns up at the elbow until the hand rests
##   on his heart.

const SOURCE := preload("res://assets/cut/grandpa_bench/grandpa_seated.png")
const PARTS := "res://game/characters/jad/rig/"
## Bottom centre of the picture: the same point the old Sprite2D used as its origin.
const FEET := Vector2(302, 982)
const HEAD_PIVOT := Vector2(212, 262)
const CHEST_PIVOT := Vector2(270, 560)
const HAND_PIVOT := Vector2(412, 548)
const CELL := 12.0
## The line between head (above) and body (below): it follows the lower edge of the beard.
const NECK_LINE: Array[Vector2] = [Vector2(150, 225), Vector2(215, 252), Vector2(300, 303), Vector2(420, 328)]

## How far the chest and shoulders rise with each breath, in picture pixels.
@export var breathing := 5.0
## How much the chest widens with each breath (0.012 = 1.2%).
@export var breath_swell := 0.012
## Seconds for one breath in and out.
@export var breath_time := 3.8
## How strongly the head moves while he talks (1 = normal, 0 = still).
@export_range(0.0, 2.0) var talk_energy := 1.0
## Small idle movements (slow head sway, a nod or finger tap now and then).
@export var idle_life := true

var talking := false
var expression := "happy"

var _skeleton: Skeleton2D
var _sheet: Polygon2D
var _chest: Bone2D
var _head: Bone2D
var _hand: Bone2D
var _closed_eyes: Sprite2D
var _upper_face: Sprite2D
var _faces := {}
var _arm_cover: Sprite2D
var _forearm: Node2D
var _arm_rest_angle := 0.0
## 0 = arm as in the picture, 1 = hand on his heart.
var _heart := 0.0
var _heart_tween: Tween
var _face_tween: Tween
var _mouth: Sprite2D
var _mouths := {}
var _rest_chest := Vector2.ZERO
var _time := 0.0
var _talk_time := 0.0
var _talk_weight := 0.0
var _mood_tilt := 0.0
var _mood_lift := 0.0
var _nod := 0.0
var _hand_lift := 0.0
var _gesture := 0.0
var _blink_wait := 3.0
var _blinking := false
var _mouth_wait := 0.0
var _mouth_step := 0
var _idle_wait := 6.0
var _mood_hold := 0.0
var _rng := RandomNumberGenerator.new()
var _blink_tween: Tween
var _mood_tween: Tween
var _nod_tween: Tween
var _hand_tween: Tween


func _ready() -> void:
	texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	_rng.randomize()
	_build_bones()
	_build_sheet()
	_build_face()
	_blink_wait = _rng.randf_range(2.0, 4.5)
	_idle_wait = _rng.randf_range(4.0, 8.0)
	_apply()


## Same size, place and facing as the old picture (a negative scale.x means "faces left").
func match_picture(picture: Sprite2D) -> void:
	position = picture.position
	scale = Vector2(picture.scale.x * (-1.0 if picture.flip_h else 1.0), picture.scale.y)


#region Building ####################################################################################
func _build_bones() -> void:
	_skeleton = Skeleton2D.new()
	_skeleton.name = "Skeleton2D"
	add_child(_skeleton)
	var root_bone := _bone("Root", _skeleton, Vector2.ZERO)
	_chest = _bone("Chest", root_bone, CHEST_PIVOT - FEET)
	_head = _bone("Head", _chest, HEAD_PIVOT - CHEST_PIVOT)
	_hand = _bone("Hand", root_bone, HAND_PIVOT - FEET)
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
	var image := SOURCE.get_image()
	var size := Vector2(image.get_size())
	var columns := int(ceil(size.x / CELL))
	var rows := int(ceil(size.y / CELL))
	var points := PackedVector2Array()
	var uvs := PackedVector2Array()
	var head_w := PackedFloat32Array()
	var chest_w := PackedFloat32Array()
	var hand_w := PackedFloat32Array()
	var root_w := PackedFloat32Array()
	for row in rows + 1:
		for column in columns + 1:
			var p := Vector2(minf(column * CELL, size.x), minf(row * CELL, size.y))
			points.append(p - FEET)
			uvs.append(p)
			var hand := _hand_weight(p)
			var head := _head_weight(p) * (1.0 - hand)
			var chest := _chest_weight(p) * (1.0 - hand) * (1.0 - _head_weight(p))
			hand_w.append(hand)
			head_w.append(head)
			chest_w.append(chest)
			root_w.append(maxf(0.0, 1.0 - hand - head - chest))
	var squares: Array = []
	for row in rows:
		for column in columns:
			var area := Rect2i(int(column * CELL) - 1, int(row * CELL) - 1, int(CELL) + 2, int(CELL) + 2)
			area = area.intersection(Rect2i(Vector2i.ZERO, image.get_size()))
			if image.get_region(area).is_invisible():
				continue
			var a := row * (columns + 1) + column
			squares.append(PackedInt32Array([a, a + 1, a + columns + 2, a + columns + 1]))
	_sheet = Polygon2D.new()
	_sheet.name = "Sheet"
	_sheet.texture = SOURCE
	_sheet.polygon = points
	_sheet.uv = uvs
	_sheet.polygons = squares
	_skeleton.add_child(_sheet)
	_skeleton.move_child(_sheet, 0)
	_sheet.skeleton = _sheet.get_path_to(_skeleton)
	_sheet.add_bone(_skeleton.get_path_to(_skeleton.get_node("Root")), root_w)
	_sheet.add_bone(_skeleton.get_path_to(_chest), chest_w)
	_sheet.add_bone(_skeleton.get_path_to(_head), head_w)
	_sheet.add_bone(_skeleton.get_path_to(_hand), hand_w)


func _head_weight(p: Vector2) -> float:
	# Height of the neck line under/over this point, then a soft band of +-9 pixels around it.
	var line_y := NECK_LINE[0].y
	if p.x >= NECK_LINE[-1].x:
		line_y = NECK_LINE[-1].y
	else:
		for index in NECK_LINE.size() - 1:
			var a := NECK_LINE[index]
			var b := NECK_LINE[index + 1]
			if p.x >= a.x and p.x <= b.x:
				line_y = lerpf(a.y, b.y, (p.x - a.x) / (b.x - a.x))
	return smoothstep(9.0, -9.0, p.y - line_y)


func _chest_weight(p: Vector2) -> float:
	var weight := smoothstep(545.0, 385.0, p.y)
	# The back of the waistcoat rests on the chair: it stays with the chair.
	var chair_side := smoothstep(100.0, 150.0, p.x)
	return weight * lerpf(1.0, chair_side, smoothstep(400.0, 430.0, p.y))


func _hand_weight(p: Vector2) -> float:
	var a := Vector2(428, 541)
	var b := Vector2(482, 546)
	var t := clampf((p - a).dot(b - a) / (b - a).length_squared(), 0.0, 1.0)
	return smoothstep(74.0, 40.0, p.distance_to(a.lerp(b, t)))


func _build_face() -> void:
	var layout: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(PARTS + "face_layout.json"))
	_upper_face = _patch("UpperFace", "face_sad", layout.upper_box)
	for mood in ["sad", "surprised"]:
		_faces[mood] = load(PARTS + "face_%s.png" % mood)
	_closed_eyes = _patch("EyesClosed", "eyes_closed", layout.eyes_box)
	_mouth = _patch("Mouth", "mouth_open", layout.mouth_box)
	for shape in ["half", "open", "sad", "surprised"]:
		_mouths[shape] = load(PARTS + "mouth_%s.png" % shape)
	# Greeting arm. The cover stays with the chair side of the body, the forearm with the chest.
	var arm_at := Vector2(layout.arm_box[0], layout.arm_box[1])
	var elbow := Vector2(layout.elbow[0], layout.elbow[1])
	_arm_rest_angle = deg_to_rad(layout.arm_rest_angle)
	var root_bone: Node2D = _skeleton.get_node("Root")
	_arm_cover = Sprite2D.new()
	_arm_cover.name = "ArmCover"
	_arm_cover.texture = load(PARTS + "arm_cover.png")
	_arm_cover.centered = false
	_arm_cover.position = arm_at - FEET
	_arm_cover.hide()
	root_bone.add_child(_arm_cover)
	root_bone.move_child(_arm_cover, 0)
	_forearm = Node2D.new()
	_forearm.name = "Forearm"
	_forearm.position = elbow - CHEST_PIVOT
	_forearm.hide()
	_chest.add_child(_forearm)
	var fore := Sprite2D.new()
	fore.name = "Sleeve"
	fore.texture = load(PARTS + "arm_fore.png")
	fore.centered = false
	fore.position = arm_at - elbow
	_forearm.add_child(fore)


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
	var picture := get_parent().get_node_or_null("Sprite2D") as Sprite2D
	if picture:
		match_picture(picture)
	_time += delta
	_talk_weight = move_toward(_talk_weight, 1.0 if talking else 0.0, delta / 0.25)
	if talking:
		_talk_time += delta
		_mouth_wait -= delta
		if _mouth_wait <= 0.0:
			# closed, half, open, half, ... with a little randomness, like syllables.
			_mouth_step = (_mouth_step + 1) % 4
			_mouth_wait = _rng.randf_range(0.07, 0.13)
			_show_mouth(["closed", "half", "open", "half"][_mouth_step])
	_blink_wait -= delta
	if _blink_wait <= 0.0 and not _blinking and expression != "surprised":
		blink()
	if not talking and expression != "happy":
		# A sad or surprised face stays a moment after the line, then his smile returns.
		_mood_hold -= delta
		if _mood_hold <= 0.0:
			set_expression("happy")
	if idle_life and not talking:
		_idle_wait -= delta
		if _idle_wait <= 0.0:
			_idle_wait = _rng.randf_range(6.0, 11.0)
			if _rng.randf() < 0.5:
				nod(0.035, 0.55)
			else:
				tap_fingers()
	_apply()


## Puts the three bones where the current state says. Everything is small and eased.
func _apply() -> void:
	var breath := 0.5 - 0.5 * cos(_time * TAU / breath_time)
	var talk_bob := sin(_talk_time * 9.5) * 0.6 + sin(_talk_time * 5.3 + 1.0) * 0.4
	_chest.position = _rest_chest + Vector2(0, -breathing * breath - _mood_lift)
	_chest.scale = Vector2(1.0 + breath_swell * breath, 1.0 + breath_swell * 0.5 * breath)
	_head.scale = Vector2.ONE / _chest.scale
	_chest.rotation = 0.010 * _talk_weight * talk_energy + 0.004 * _talk_weight * talk_bob
	var sway := sin(_time * TAU / 7.3) * 0.010 if idle_life else 0.0
	_head.rotation = sway * (1.0 - _talk_weight) + _mood_tilt + _nod \
			+ 0.022 * talk_bob * _talk_weight * talk_energy
	_head.position.y = (HEAD_PIVOT - CHEST_PIVOT).y - breathing * 0.25 * breath
	var beat := maxf(0.0, sin(_talk_time * 4.1)) * 0.035 * _talk_weight * _gesture
	_hand.rotation = -_hand_lift - beat
	_show_heart_arm(_heart)


## The greeting arm: hidden at 0 (the picture shows his arm), on his heart at 1.
func _show_heart_arm(amount: float) -> void:
	var shown := amount > 0.001
	_arm_cover.visible = shown
	_forearm.visible = shown
	if not shown:
		return
	var alpha := smoothstep(0.0, 0.3, amount)
	_arm_cover.modulate.a = alpha
	_forearm.modulate.a = alpha
	_forearm.rotation = _arm_rest_angle * (1.0 - amount)


func set_talking(value: bool) -> void:
	if talking == value:
		return
	talking = value
	_mouth_step = 0
	_mouth_wait = 0.0
	_show_mouth("closed")
	if value:
		_talk_time = 0.0
		# Every second line or so, his hand leaves his knee a little while he explains.
		_gesture = 1.0 if _rng.randf() < 0.6 else 0.0
		if _gesture > 0.0:
			_lift_hand(0.10, 0.35)
	else:
		_mood_hold = 1.2
		_lift_hand(0.0, 0.45)


func set_expression(value: String) -> void:
	expression = value
	_show_mouth("closed")
	_show_upper_face(value)
	if is_instance_valid(_mood_tween):
		_mood_tween.kill()
	_mood_tween = create_tween().set_parallel().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	# He faces right in the picture: a positive angle lowers his face.
	_mood_tween.tween_property(self, "_mood_tilt", {"sad": 0.05, "surprised": -0.035}.get(value, 0.0), 0.3)
	_mood_tween.tween_property(self, "_mood_lift", 3.0 if value == "surprised" else 0.0, 0.3)


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


## Greeting of peace: his right hand rises to his heart, with a small nod and his warm smile.
func greet() -> void:
	set_expression("happy")
	if is_instance_valid(_heart_tween):
		_heart_tween.kill()
	_heart_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	_heart_tween.tween_property(self, "_heart", 1.0, 0.5)
	_heart_tween.tween_callback(nod.bind(0.05, 0.4))
	_heart_tween.tween_interval(1.7)
	_heart_tween.tween_property(self, "_heart", 0.0, 0.55)


## Eyebrows, eyelids and eye size of the mood (nothing for his normal happy face).
func _show_upper_face(mood: String) -> void:
	if is_instance_valid(_face_tween):
		_face_tween.kill()
	_face_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	if _faces.has(mood):
		_upper_face.texture = _faces[mood]
		_upper_face.show()
		_face_tween.tween_property(_upper_face, "modulate:a", 1.0, 0.12)
	else:
		_face_tween.tween_property(_upper_face, "modulate:a", 0.0, 0.12)
		_face_tween.tween_callback(_upper_face.hide)


func tap_fingers() -> void:
	if is_instance_valid(_hand_tween):
		_hand_tween.kill()
	_hand_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	for index in 2:
		_hand_tween.tween_property(self, "_hand_lift", 0.07, 0.16)
		_hand_tween.tween_property(self, "_hand_lift", 0.0, 0.16)


func _lift_hand(amount: float, time: float) -> void:
	if is_instance_valid(_hand_tween):
		_hand_tween.kill()
	_hand_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	_hand_tween.tween_property(self, "_hand_lift", amount, time)


func _show_mouth(shape: String) -> void:
	if not is_instance_valid(_mouth):
		return
	if shape == "closed" and not talking:
		shape = {"sad": "sad", "surprised": "surprised"}.get(expression, "closed")
	# "closed" is the smile already drawn in the picture: no patch needed.
	_mouth.visible = shape != "closed"
	if _mouth.visible:
		_mouth.texture = _mouths[shape]


#endregion

#region Review ######################################################################################
## Freezes the rig in one exact pose, for the review pictures (tools/fable_review.gd).
func pose_for_review(pose: Dictionary) -> void:
	set_process(false)
	for tween in [_blink_tween, _mood_tween, _nod_tween, _hand_tween, _heart_tween, _face_tween]:
		if is_instance_valid(tween):
			tween.kill()
	var breath := float(pose.get("breath", 0.0))
	_chest.position = _rest_chest + Vector2(0, -breathing * breath - float(pose.get("rise", 0.0)))
	_chest.scale = Vector2(1.0 + breath_swell * breath, 1.0 + breath_swell * 0.5 * breath)
	_head.scale = Vector2.ONE / _chest.scale
	_show_heart_arm(float(pose.get("heart", 0.0)))
	var face := str(pose.get("face", ""))
	_upper_face.visible = _faces.has(face)
	_upper_face.modulate.a = 1.0
	if _upper_face.visible:
		_upper_face.texture = _faces[face]
	_chest.rotation = float(pose.get("lean", 0.0))
	_head.position = HEAD_PIVOT - CHEST_PIVOT
	_head.rotation = float(pose.get("head", 0.0))
	_hand.rotation = -float(pose.get("hand", 0.0))
	_closed_eyes.visible = bool(pose.get("blink", false))
	_closed_eyes.modulate.a = 1.0
	var mouth := str(pose.get("mouth", "closed"))
	_mouth.visible = mouth != "closed"
	if _mouth.visible:
		_mouth.texture = _mouths[mouth]


#endregion
