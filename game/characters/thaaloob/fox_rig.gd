class_name FoxRig
extends Node2D
## Thaaloob's rig: walk, idle, blink, talk and expressions, made from his approved picture.
##
## tools/build_fox_rig.py cuts the picture into layers (tail, far arm, far leg, head, body with the
## near leg, paws, near arm, scarf) and writes layout.json. Here every layer becomes a flexible
## sheet (a grid of small squares) that follows the bones, so hips, knees, shoulders and elbows
## bend like one skin, with no cut lines.
##
## Walking follows the distance really travelled: the foot on the ground stays where it is, the
## body rises and falls with the legs, arms swing opposite to the legs, tail and scarf follow late.
## It starts by itself whenever the character moves sideways (a Popochiu walk or a tween).

const PARTS := "res://game/characters/thaaloob/rig/"
const CELL := 14.0
# Eight keyed poses per step cycle (contact, down, passing, up, then the other leg), as for Reem.
const THIGH := [25.0, 15.0, 0.0, -15.0, -25.0, -15.0, 15.0, 25.0]
const KNEE := [5.0, 22.0, 8.0, 8.0, 8.0, 30.0, 40.0, 20.0]
const PAW := [-0.20, 0.0, 0.0, 0.16, 0.25, 0.22, 0.16, 0.08]
const SWING := [1.0, 0.7, 0.0, -0.7, -1.0, -0.7, 0.0, 0.7]

## Arm swing while walking, in degrees.
@export var arm_swing := 20.0
## How much the hips come together under the body while walking (0 = stay as in the picture).
@export_range(0.0, 1.0) var hips_together := 1.0
## Breathing: how far the chest rises, in picture pixels.
@export var breathing := 3.0
@export var idle_life := true
## How strongly head and body move while he talks.
@export_range(0.0, 2.0) var talk_energy := 1.0

var walking := false
var talking := false
var expression := "happy"

var _layout: Dictionary
var _feet := Vector2.ZERO
var _skeleton: Skeleton2D
var _bones := {}
var _rest := {}
var _layers := {}
var _far_layers: Array[Polygon2D] = []
var _hips: Array[Bone2D] = []
var _knees: Array[Bone2D] = []
var _ankles: Array[Bone2D] = []
var _upper: Array[Vector2] = []
var _lower: Array[Vector2] = []
var _soles: Array = []
var _hip_shift: Array[float] = [26.0, -40.0]
var _ground := 0.0
var _cycle_length := 600.0
var _plant: Array[float] = [0.0, 0.0]
var _contact_at_zero: Array[float] = [0.0, 0.0]
var _phase := 0.0
var _lift := 0.0
var _last_x := 0.0
var _still_time := 0.0
var _time := 0.0
var _talk_time := 0.0
var _talk_weight := 0.0
var _mood := {"head": 0.0, "ears": 0.0, "tail": 0.0}
var _ear_flick := 0.0
var _gesture := 0.0
var _closed_eyes: Sprite2D
var _upper_face: Sprite2D
var _mouth: Sprite2D
var _faces := {}
var _mouths := {}
var _blink_wait := 3.0
var _blinking := false
var _mouth_wait := 0.0
var _mouth_step := 0
var _idle_wait := 5.0
var _mood_hold := 0.0
var _rng := RandomNumberGenerator.new()
var _lift_tween: Tween
var _blink_tween: Tween
var _mood_tween: Tween
var _flick_tween: Tween
var _gesture_tween: Tween
var _face_tween: Tween


func _ready() -> void:
	texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	_rng.randomize()
	_layout = JSON.parse_string(FileAccess.get_file_as_string(PARTS + "layout.json"))
	_feet = _point(_layout.feet)
	_build_bones()
	for layer in _layout.layers:
		_build_layer(layer)
	_build_face()
	_measure_legs()
	_last_x = _travel_x()
	_blink_wait = _rng.randf_range(2.0, 4.5)
	_apply(0.0)


## Same size, place and facing as the old picture (a negative scale.x means "faces left").
func match_picture(picture: Sprite2D) -> void:
	position = picture.position
	scale = Vector2(picture.scale.x * (-1.0 if picture.flip_h else 1.0), picture.scale.y)


#region Building ####################################################################################
func _point(value: Array) -> Vector2:
	return Vector2(value[0], value[1])


func _build_bones() -> void:
	_skeleton = Skeleton2D.new()
	_skeleton.name = "Skeleton2D"
	add_child(_skeleton)
	var places := {}
	for entry in _layout.bones:
		var at := _point(entry.at)
		places[entry.name] = at
		var parent: Node = _skeleton if entry.parent == "" else _bones[entry.parent]
		var bone := Bone2D.new()
		bone.name = entry.name
		bone.position = at - (_feet if entry.parent == "" else places[entry.parent])
		bone.rest = Transform2D(0.0, bone.position)
		bone.set_autocalculate_length_and_angle(false)
		bone.set_length(40.0)
		parent.add_child(bone)
		_bones[entry.name] = bone
		_rest[entry.name] = bone.position


## One layer of the picture as a grid of squares; every corner follows the bones by its weights.
func _build_layer(layer: Dictionary) -> void:
	var texture: Texture2D = load(PARTS + layer.file)
	var image := texture.get_image()
	var size := Vector2(image.get_size())
	var at := _point(layer.at)
	var columns := int(ceil(size.x / CELL))
	var rows := int(ceil(size.y / CELL))
	var points := PackedVector2Array()
	var uvs := PackedVector2Array()
	var weights := {}
	for row in rows + 1:
		for column in columns + 1:
			var local := Vector2(minf(column * CELL, size.x), minf(row * CELL, size.y))
			points.append(at + local - _feet)
			uvs.append(local)
			var shares := _shares(layer, at + local)
			for bone_name in shares:
				if not weights.has(bone_name):
					var empty := PackedFloat32Array()
					empty.resize((rows + 1) * (columns + 1))
					weights[bone_name] = empty
				weights[bone_name][points.size() - 1] = shares[bone_name]
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
	sheet.name = str(layer.name).to_pascal_case()
	sheet.texture = texture
	sheet.polygon = points
	sheet.uv = uvs
	sheet.polygons = squares
	_skeleton.add_child(sheet)
	_skeleton.move_child(sheet, _layers.size())
	sheet.skeleton = sheet.get_path_to(_skeleton)
	for bone_name in weights:
		sheet.add_bone(_skeleton.get_path_to(_bones[bone_name]), weights[bone_name])
	_layers[layer.name] = sheet
	if layer.far_side:
		_far_layers.append(sheet)


## How much a point of a layer belongs to each bone (the shares add up to 1).
func _shares(layer: Dictionary, p: Vector2) -> Dictionary:
	var shares := {layer.base: 1.0}
	for chain in layer.chains:
		if chain.area != null:
			var area := PackedVector2Array()
			for corner in chain.area:
				area.append(_point(corner))
			if not Geometry2D.is_point_in_polygon(p, area):
				continue
		var before := 1.0
		var holder: String = chain.base
		for joint in chain.joints:
			var at := _point(joint.at)
			var along := (_point(joint.toward) - at).normalized()
			var past := minf(before, smoothstep(-float(joint.soft), float(joint.soft), (p - at).dot(along)))
			if holder == chain.base:
				shares[holder] = float(shares.get(holder, 0.0)) - past
			else:
				shares[holder] = before - past
			shares[joint.bone] = past
			holder = joint.bone
			before = past
	for bone_name in shares.keys():
		if shares[bone_name] <= 0.0005:
			shares.erase(bone_name)
	return shares


func _build_face() -> void:
	var head: Bone2D = _bones["Head"]
	var head_at := _point(_bone_place("Head"))
	_upper_face = _patch("UpperFace", "face_sad", _layout.eye_box, head, head_at)
	for mood in ["sad", "surprised"]:
		_faces[mood] = load(PARTS + "face_%s.png" % mood)
	_closed_eyes = _patch("EyesClosed", "eyes_closed", _layout.eye_box, head, head_at)
	_mouth = _patch("Mouth", "mouth_open", _layout.mouth_box, head, head_at)
	for shape in ["half", "open", "sad"]:
		_mouths[shape] = load(PARTS + "mouth_%s.png" % shape)


func _bone_place(bone_name: String) -> Array:
	for entry in _layout.bones:
		if entry.name == bone_name:
			return entry.at
	return [0, 0]


func _patch(node_name: String, file: String, box: Array, bone: Bone2D, bone_at: Vector2) -> Sprite2D:
	var sprite := Sprite2D.new()
	sprite.name = node_name
	sprite.texture = load(PARTS + file + ".png")
	sprite.centered = false
	sprite.position = Vector2(box[0], box[1]) - bone_at
	sprite.hide()
	bone.add_child(sprite)
	return sprite


func _measure_legs() -> void:
	for side in ["near", "far"]:
		var hip: Bone2D = _bones["Hip_" + side]
		var knee: Bone2D = _bones["Knee_" + side]
		var ankle: Bone2D = _bones["Ankle_" + side]
		_hips.append(hip)
		_knees.append(knee)
		_ankles.append(ankle)
		_upper.append(knee.position)
		_lower.append(ankle.position)
		_soles.append([_point(_layout.soles[side].heel), _point(_layout.soles[side].toe)])
	# Ground height under the body bone, from the far paw as drawn (flat on the ground).
	var far_ankle: Vector2 = _rest["Hip_far"] + _upper[1] + _lower[1]
	_ground = far_ankle.y + maxf(_soles[1][0].y, _soles[1][1].y)
	# Length of one full cycle: the two steps, measured on the poses themselves.
	var step := [0.0, 0.0]
	for leg in 2:
		_contact_at_zero[leg] = _leg_pose(leg, 0.0, 1.0).contact.x
		step[leg] = _contact_at_zero[leg] - _leg_pose(leg, 0.5, 1.0).contact.x
	_cycle_length = step[0] + step[1]
	_plant[0] = _contact_at_zero[0]
	_plant[1] = _plant[0] + _contact_at_zero[1] - _leg_pose(0, 0.5, 1.0).contact.x - _cycle_length / 2.0


#endregion

#region Walking #####################################################################################
func _key(values: Array, phase: float) -> float:
	var sample := fposmod(phase, 1.0) * values.size()
	var index := int(sample)
	return float(values[index]) + float(Tween.interpolate_value(0.0,
			float(values[(index + 1) % values.size()]) - float(values[index]),
			sample - index, 1.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT))


## Joint turns of one leg at a moment `p` of its own cycle (0 = its paw lands in front), blended
## with the standing pose by `weight`, and where its paw touches (in the body's own space).
func _leg_pose(leg: int, p: float, weight: float) -> Dictionary:
	var thigh_angle := PI / 2.0 - deg_to_rad(_key(THIGH, p))
	var shin_angle := thigh_angle + deg_to_rad(_key(KNEE, p))
	var hip_turn := lerp_angle(0.0, thigh_angle - _upper[leg].angle(), weight)
	var knee_turn := lerp_angle(0.0, shin_angle - _lower[leg].angle() - (thigh_angle - _upper[leg].angle()), weight)
	var paw_angle := _key(PAW, p) * weight
	var hip_at: Vector2 = _rest[_hips[leg].name] + Vector2(_hip_shift[leg] * hips_together * weight, 0)
	var ankle_at := hip_at + _upper[leg].rotated(hip_turn) + _lower[leg].rotated(hip_turn + knee_turn)
	# The near paw points backwards in the picture; it turns to the front while walking.
	var mirror := 1.0 - 2.0 * weight if leg == 0 else 1.0
	var heel: Vector2 = _soles[leg][0]
	var toe: Vector2 = _soles[leg][1]
	if leg == 0:
		# Given already mirrored: un-mirror for the standing pose.
		heel.x *= -mirror
		toe.x *= -mirror
	var heel_at := ankle_at + heel.rotated(paw_angle)
	var toe_at := ankle_at + toe.rotated(paw_angle)
	return {"hip_at": hip_at, "hip": hip_turn, "knee": knee_turn, "paw": paw_angle, "mirror": mirror,
		"contact": heel_at if heel_at.y > toe_at.y else toe_at}


## Puts the whole body in the walk pose of `phase` (0..1), blended with standing by `weight`.
func apply_walk_phase(phase: float, weight := 1.0) -> void:
	_phase = fposmod(phase, 1.0)
	var body: Bone2D = _bones["Body"]
	var lowest := -INF
	var poses := []
	for leg in 2:
		var p := fposmod(_phase + leg * 0.5, 1.0)
		var pose := _leg_pose(leg, p, weight)
		poses.append(pose)
		_hips[leg].position = pose.hip_at
		_hips[leg].rotation = pose.hip
		_knees[leg].rotation = pose.knee
		_ankles[leg].rotation = pose.paw - pose.hip - pose.knee
		_ankles[leg].scale = Vector2(pose.mirror if absf(pose.mirror) > 0.02 else 0.02, 1.0)
		lowest = maxf(lowest, pose.contact.y)
	# The paw on the ground stays where it is: the body moves over it and rises or sinks with it.
	var stance := 0 if _phase < 0.5 else 1
	var p_stance := fposmod(_phase + stance * 0.5, 1.0)
	var planted := _plant[stance] - _cycle_length * p_stance
	var offset := Vector2(planted - poses[stance].contact.x, _ground - lowest)
	body.position = _rest["Body"] + offset * weight + Vector2(0, _breath_rise())
	body.rotation = 0.025 * weight
	var near_swing := _key(SWING, _phase)
	for side in 2:
		var side_name := "near" if side == 0 else "far"
		var swing := near_swing if side == 0 else -near_swing
		_bones["Shoulder_" + side_name].rotation = deg_to_rad(arm_swing) * swing * weight
		_bones["Elbow_" + side_name].rotation = -deg_to_rad(9.0 + 9.0 * maxf(0.0, -swing)) * weight
	var late := sin((_phase - 0.12) * TAU * 2.0)
	_bones["Tail"].rotation = (0.05 + 0.05 * late) * weight + _mood.tail
	_bones["TailTip"].rotation = 0.09 * sin((_phase - 0.26) * TAU * 2.0) * weight
	_bones["ScarfEnd"].rotation = (0.10 + 0.09 * sin((_phase - 0.2) * TAU * 2.0)) * weight
	_bones["Head"].rotation = (-0.015 + 0.012 * late) * weight + _mood.head
	_bones["EarNear"].rotation = 0.035 * late * weight + _mood.ears + _ear_flick
	_bones["EarFar"].rotation = 0.03 * late * weight
	for sheet in _far_layers:
		sheet.modulate = Color.WHITE.lerp(Color(0.88, 0.88, 0.88), weight)


func set_walking(value: bool) -> void:
	if walking == value:
		return
	walking = value
	if is_instance_valid(_lift_tween):
		_lift_tween.kill()
	_lift_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	if value:
		_phase = 0.92
		_lift_tween.tween_property(self, "_lift", 1.0, 0.2)
	else:
		_lift_tween.tween_property(self, "_lift", 0.0, 0.26)


func _travel_x() -> float:
	var mover := get_parent() as Node2D
	return mover.global_position.x if mover else global_position.x


#endregion

#region Idle, talk, face ############################################################################
func _process(delta: float) -> void:
	var picture := get_parent().get_node_or_null("Sprite2D") as Sprite2D
	if picture:
		match_picture(picture)
	_time += delta
	# Walk by itself whenever the character really moves sideways.
	var x := _travel_x()
	var moved := absf(x - _last_x) / maxf(absf(global_scale.x), 0.001)
	_last_x = x
	if moved > 0.05:
		_still_time = 0.0
		set_walking(true)
	else:
		_still_time += delta
		if _still_time > 0.1:
			set_walking(false)
	if _lift > 0.0:
		_phase = fposmod(_phase + moved / _cycle_length, 1.0)

	_talk_weight = move_toward(_talk_weight, 1.0 if talking else 0.0, delta / 0.25)
	if talking:
		_talk_time += delta
		_mouth_wait -= delta
		if _mouth_wait <= 0.0:
			_mouth_step = (_mouth_step + 1) % 4
			_mouth_wait = _rng.randf_range(0.07, 0.13)
			_show_mouth(["closed", "half", "open", "half"][_mouth_step])
	elif expression != "happy":
		_mood_hold -= delta
		if _mood_hold <= 0.0:
			set_expression("happy")
	_blink_wait -= delta
	if _blink_wait <= 0.0 and not _blinking and expression != "surprised":
		blink()
	if idle_life and not talking and not walking:
		_idle_wait -= delta
		if _idle_wait <= 0.0:
			_idle_wait = _rng.randf_range(4.0, 9.0)
			flick_ear()
	_apply(_lift)


func _breath_rise() -> float:
	return -breathing * (0.5 - 0.5 * cos(_time * TAU / 3.4))


func _apply(weight: float) -> void:
	apply_walk_phase(_phase, weight)
	# Standing life, faded out while he walks.
	var calm := 1.0 - weight
	var talk_bob := (sin(_talk_time * 9.5) * 0.6 + sin(_talk_time * 5.3 + 1.0) * 0.4) * _talk_weight * talk_energy
	_bones["Head"].rotation += (sin(_time * TAU / 6.1) * 0.012 * calm if idle_life else 0.0) + 0.028 * talk_bob
	_bones["Body"].rotation += 0.008 * talk_bob
	_bones["Tail"].rotation += sin(_time * TAU / 2.9) * 0.045 * calm
	_bones["TailTip"].rotation += sin(_time * TAU / 2.9 - 0.9) * 0.08 * calm
	_bones["ScarfEnd"].rotation += sin(_time * TAU / 4.3) * 0.02 * calm
	# While talking his near forearm comes up a little, with small beats.
	var beat := maxf(0.0, sin(_talk_time * 4.3)) * 0.10 * _talk_weight
	_bones["Elbow_near"].rotation -= (0.42 * _gesture + beat * _gesture) * calm
	_bones["Shoulder_near"].rotation -= 0.10 * _gesture * calm


func set_talking(value: bool) -> void:
	if talking == value:
		return
	talking = value
	_mouth_step = 0
	_mouth_wait = 0.0
	_show_mouth("closed")
	if is_instance_valid(_gesture_tween):
		_gesture_tween.kill()
	_gesture_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	if value:
		_talk_time = 0.0
		_gesture_tween.tween_property(self, "_gesture", 1.0 if _rng.randf() < 0.65 else 0.0, 0.3)
	else:
		_mood_hold = 1.2
		_gesture_tween.tween_property(self, "_gesture", 0.0, 0.4)


func set_expression(value: String) -> void:
	expression = value
	_show_mouth("closed")
	_show_upper_face(value)
	if is_instance_valid(_mood_tween):
		_mood_tween.kill()
	# He faces right in the picture: a positive head angle lowers his nose; negative ears go back.
	var goal := {"head": 0.0, "ears": 0.0, "tail": 0.0}
	match value:
		"sad":
			goal = {"head": 0.07, "ears": -0.2, "tail": -0.16}
		"surprised":
			goal = {"head": -0.045, "ears": 0.04, "tail": 0.12}
	_mood_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	_mood_tween.tween_method(_blend_mood.bind(_mood.duplicate(), goal), 0.0, 1.0, 0.3)


func _blend_mood(amount: float, from: Dictionary, to: Dictionary) -> void:
	for key in to:
		_mood[key] = lerpf(from[key], to[key], amount)


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


func flick_ear() -> void:
	if is_instance_valid(_flick_tween):
		_flick_tween.kill()
	_flick_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	for index in 2:
		_flick_tween.tween_property(self, "_ear_flick", -0.16, 0.07)
		_flick_tween.tween_property(self, "_ear_flick", 0.0, 0.10)


func _show_mouth(shape: String) -> void:
	if not is_instance_valid(_mouth):
		return
	if shape == "closed" and not talking:
		shape = {"sad": "sad", "surprised": "open"}.get(expression, "closed")
	# "closed" is the smile already drawn in the picture: no patch needed.
	_mouth.visible = shape != "closed"
	if _mouth.visible:
		_mouth.texture = _mouths[shape]


#endregion

#region Review ######################################################################################
## Freezes the rig in one exact pose, for the review pictures (tools/fable_review.gd).
func pose_for_review(pose: Dictionary) -> void:
	set_process(false)
	for tween in [_lift_tween, _blink_tween, _mood_tween, _flick_tween, _gesture_tween, _face_tween]:
		if is_instance_valid(tween):
			tween.kill()
	_time = 0.0
	_talk_time = 0.0
	_talk_weight = float(pose.get("talk", 0.0))
	_gesture = float(pose.get("gesture", 0.0))
	_ear_flick = 0.0
	_mood = {"head": float(pose.get("head", 0.0)), "ears": float(pose.get("ears", 0.0)), "tail": float(pose.get("tail", 0.0))}
	_phase = float(pose.get("walk", 0.0))
	_lift = 1.0 if pose.has("walk") else 0.0
	_apply(_lift)
	_closed_eyes.visible = bool(pose.get("blink", false))
	_closed_eyes.modulate.a = 1.0
	var face := str(pose.get("face", ""))
	_upper_face.visible = _faces.has(face)
	_upper_face.modulate.a = 1.0
	if _upper_face.visible:
		_upper_face.texture = _faces[face]
	var mouth := str(pose.get("mouth", "closed"))
	_mouth.visible = mouth != "closed"
	if _mouth.visible:
		_mouth.texture = _mouths[mouth]


#endregion
