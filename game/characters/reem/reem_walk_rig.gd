class_name ReemWalkRig
extends Node2D
## Original-pixel cutout. All rest transforms and UVs live in reem_cutout.tscn.
const SOURCE := preload("res://assets/art/characters/reem/reem_base.png")
const PARTS := "res://game/characters/reem/cutout/"
const FEET := Vector2(627, 1254)
const LAYOUT_PATH := "res://game/characters/reem/cutout_layout.json"
@export var stride := 90.0
@export var bob_height := 4.0
@export var breathing := 2.5
var walking := false
var talking := false
var expression := "happy"
var _body: Bone2D
var _hem: Bone2D
var _head: Bone2D
var _arms: Array[Bone2D] = []
var _elbows: Array[Bone2D] = []
var _wrists: Array[Bone2D] = []
var _hips: Array[Bone2D] = []
var _knees: Array[Bone2D] = []
var _feet: Array[Bone2D] = []
var _eyes: Sprite2D
var _closed_eyes: Node2D
var _mouth: Sprite2D
var _neutral_mouth: Texture2D
var _rest_head := Vector2.ZERO
var _rest_hips: Array[Vector2] = []
var _rest_ankles: Array[Vector2] = []
var _upper_vectors: Array[Vector2] = []
var _lower_vectors: Array[Vector2] = []
var _phase := .3
var _last_x := 0.0
var _blink_wait := 3.0
var _blinking := false
var _mouth_wait := 0.0
var _mouth_open := false
var _breath: Tween
var _wave: Tween
var _settle: Tween
var _blink_tween: Tween
var _waving := false
var _settling := false
var _lift := 0.0
var _from_feet: Array[Vector2] = []
var _from_hip_shifts: Array[float] = []
var _from_foot_angles: Array[float] = []
var _rng := RandomNumberGenerator.new()
var _layout: Dictionary

func _ready() -> void:
	_layout = JSON.parse_string(FileAccess.get_file_as_string(LAYOUT_PATH))
	_rng.randomize()
	for part in $Skeleton2D.get_children():
		if part is Polygon2D and part.has_meta("skin"):
			var skin: Dictionary = part.get_meta("skin")
			for path in skin:
				part.add_bone(NodePath(path), skin[path])
	_body = $Skeleton2D/Body
	_hem = $Skeleton2D/Body/Hem
	_head = $Skeleton2D/Body/Head
	_rest_head = _head.position
	_eyes = _head.get_node("Eyes/Open")
	_closed_eyes = _head.get_node("Eyes/Closed")
	_mouth = _head.get_node("MouthAnchor/Mouth")
	_neutral_mouth = _mouth.texture
	for side in ["back", "front"]:
		var shoulder: Bone2D = _body.get_node("Shoulder_" + side)
		var elbow: Bone2D = shoulder.get_node("Elbow_" + side)
		_arms.append(shoulder)
		_elbows.append(elbow)
		_wrists.append(elbow.get_node("Wrist_" + side))
		var hip: Bone2D = _body.get_node("Hip_" + side)
		var knee: Bone2D = hip.get_node("Knee_" + side)
		var ankle: Bone2D = knee.get_node("Ankle_" + side)
		_hips.append(hip)
		_rest_hips.append(hip.position)
		_knees.append(knee)
		_feet.append(ankle)
		_upper_vectors.append(knee.position)
		_lower_vectors.append(ankle.position)
		var point: Array = _layout.legs[side].ankle
		_rest_ankles.append(Vector2(point[0], point[1]) - FEET)
	_last_x = get_parent().global_position.x
	_blink_wait = _rng.randf_range(2, 5)
	_breath = create_tween().set_loops().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	_breath.tween_property(_head, "position:y", _rest_head.y - breathing * .4, 1.8)
	_breath.tween_property(_head, "position:y", _rest_head.y, 1.8)

func match_picture(picture: Sprite2D) -> void:
	scale = Vector2(absf(picture.scale.x) * (-1.0 if picture.flip_h else 1.0), picture.scale.y)

func set_walking(value: bool) -> void:
	if is_instance_valid(_settle):
		_settle.kill()
	walking = value
	_settling = false
	if value:
		_phase = .3
		_lift = 0.0
		_settle = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		_settle.tween_property(self, "_lift", 1.0, .18)
		return
	_from_feet.clear()
	_from_hip_shifts.clear()
	_from_foot_angles.clear()
	for index in 2:
		_from_feet.append(to_local(_feet[index].global_position))
		_from_hip_shifts.append(_hips[index].position.x - _rest_hips[index].x)
		_from_foot_angles.append(_feet[index].global_rotation - global_rotation)
	_settling = true
	_settle = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	_settle.tween_method(_settle_feet, 0.0, 1.0, .22)
	_settle.parallel().tween_property(_body, "position:y", 0.0, .22)
	_settle.parallel().tween_property(_body, "rotation", 0.0, .22)
	_settle.parallel().tween_property(_hem, "rotation", 0.0, .22)
	_settle.parallel().tween_property(_hem, "scale", Vector2.ONE, .22)
	_settle.tween_callback(func():
		_settling = false
		_reset_limbs())
	var arms := create_tween().set_parallel().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	for joint in _arms + _elbows:
		if not _waving:
			arms.tween_property(joint, "rotation", 0.0, .22)

func _reset_limbs() -> void:
	_body.rotation = 0
	_hem.rotation = 0
	_hem.scale = Vector2.ONE
	for joint in _hips + _knees + _feet:
		joint.rotation = 0.0
	for index in 2:
		_hips[index].position = _rest_hips[index]

func _settle_feet(weight: float) -> void:
	for index in 2:
		_solve_leg(index, _body.transform.affine_inverse() * _from_feet[index].lerp(_rest_ankles[index], weight), lerpf(_from_hip_shifts[index], 0.0, weight))
		_feet[index].rotation += lerpf(_from_foot_angles[index], 0.0, weight) - _body.rotation

func _process(delta: float) -> void:
	var picture := get_parent().get_node_or_null("Sprite2D") as Sprite2D
	if picture:
		match_picture(picture)
	var current_x: float = get_parent().global_position.x
	var distance := absf(current_x - _last_x) / maxf(absf(scale.x), .001)
	_last_x = current_x
	if walking:
		_phase = fposmod(_phase + distance / (_effective_stride() / .625), 1.0)
		apply_walk_phase(_phase, _lift)
	elif not _settling:
		_body.position = Vector2.ZERO
		_reset_limbs()
	_blink_wait -= delta
	if _blink_wait <= 0 and not _blinking:
		blink()
	_mouth_wait -= delta
	if talking and _mouth_wait <= 0:
		_mouth_open = not _mouth_open
		_mouth_wait = _rng.randf_range(.09, .18)
		_show_mouth("open" if _mouth_open else "closed")

func _effective_stride() -> float:
	# A wider step would exceed the original short legs' reach and make planted feet slide.
	return clampf(stride, 60.0, 90.0)

# Eight keyed poses: contact, down, passing, up, repeated for the other leg.
# Stance travel remains linear to cancel root movement; all pose changes use Tween easing.
func _pose(values: Array, phase: float) -> float:
	var sample := fposmod(phase, 1.0) * values.size()
	var index := int(sample)
	return float(values[index]) + float(Tween.interpolate_value(0.0,
		float(values[(index + 1) % values.size()]) - float(values[index]),
		sample - index, 1.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT))

func apply_walk_phase(phase: float, weight := 1.0) -> void:
	_phase = fposmod(phase, 1.0)
	_body.position.y = weight * _pose([2.0, 5.0, -5.0, -8.0, 2.0, 5.0, -5.0, -8.0], _phase) * bob_height / 4.0
	_body.rotation = weight * .008
	_hem.scale.y = 1.0 + .07 * weight
	_hem.rotation = weight * _pose([0.0, .008, .012, .008, 0.0, -.008, -.012, -.008], _phase - .10)
	for index in 2:
		var p := fposmod(_phase + index * .5, 1.0)
		var target := _rest_ankles[index]
		target.x = lerpf(target.x, 620.0 - FEET.x, weight)
		var angle := weight * _pose([-.10, 0.0, 0.0, 0.0, .02, .14, .10, .08], p)
		if p < .625:
			# The ground contact advances backward exactly as far as the actor advances.
			target.x += _effective_stride() * (.5 - p / .625)
			var contact := Vector2(-42, 71) if p < .125 else Vector2(62, 71)
			# Roll around the heel/toe on the ground, rather than around a floating ankle.
			target += contact - contact.rotated(angle)
		else:
			var t := (p - .625) / .375
			var eased: float = Tween.interpolate_value(0.0, 1.0, t, 1.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
			target.x += _effective_stride() * (eased - .5)
			var toe := Vector2(62, 71)
			var heel := Vector2(-42, 71)
			target += (toe - toe.rotated(.14 * weight)).lerp(heel - heel.rotated(-.10 * weight), eased)
			target.y -= weight * 13.0 * sin(t * PI) ** 2
		_solve_leg(index, _body.transform.affine_inverse() * target, weight * (620.0 - FEET.x - _rest_hips[index].x))
		_feet[index].rotation += angle - _body.rotation
		if not (_waving and index == 1):
			# Positive shoulder rotation carries an arm back while its own leg is forward.
			_arms[index].rotation = weight * ((.34 if index == 0 else -.38) + _pose([.12, .08, 0.0, -.08, -.12, -.08, 0.0, .08], p))
			_elbows[index].rotation = weight * _pose([-.035, -.05, -.06, -.05, -.035, -.02, -.01, -.02], p)

func _solve_leg(index: int, target: Vector2, hip_shift := 0.0) -> void:
	_hips[index].position = _rest_hips[index] + Vector2(hip_shift, 0)
	var v := target - _hips[index].position
	var upper := _upper_vectors[index]
	var lower := _lower_vectors[index]
	var a := upper.length()
	var b := lower.length()
	# Hidden hip correction keeps the short trouser leg within reach without sliding
	# the planted shoe or forcing a wide, swollen knee fold.
	var minimum := sqrt(a*a + b*b + 2*a*b*cos(deg_to_rad(35.0)))
	var d := clampf(v.length(), minimum, a + b - .01)
	_hips[index].position.y = target.y - sqrt(maxf(1.0, d*d - v.x*v.x))
	v = target - _hips[index].position
	var direction := v.angle()
	var bend := acos(clampf((a*a + d*d - b*b) / (2*a*d), -1, 1))
	var upper_angle := direction - bend
	var shin_angle := direction + acos(clampf((b*b + d*d - a*a) / (2*b*d), -1, 1))
	_hips[index].rotation = upper_angle - upper.angle()
	_knees[index].rotation = shin_angle - lower.angle() - _hips[index].rotation
	# Ankle counter-rotation keeps the original shoe and sole level.
	_feet[index].rotation = -_hips[index].rotation - _knees[index].rotation

func blink() -> void:
	if _blinking:
		return
	_blinking = true
	_closed_eyes.show()
	_closed_eyes.modulate.a = 0
	_blink_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	_blink_tween.tween_property(_eyes, "modulate:a", 0.0, .06)
	_blink_tween.parallel().tween_property(_closed_eyes, "modulate:a", 1.0, .06)
	_blink_tween.tween_property(_eyes, "modulate:a", 1.0, .08)
	_blink_tween.parallel().tween_property(_closed_eyes, "modulate:a", 0.0, .08)
	await _blink_tween.finished
	_closed_eyes.hide()
	_blinking = false
	_blink_wait = _rng.randf_range(2, 5)

func set_talking(value: bool) -> void:
	talking = value
	_mouth_open = false
	_mouth_wait = 0
	_show_mouth("closed")

func set_expression(value: String) -> void:
	expression = value
	_show_mouth("closed")
	var tween := create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(_head, "rotation", -.015 if value == "sad" else 0.0, .22)

func _show_mouth(shape: String) -> void:
	if not is_instance_valid(_mouth):
		return
	if shape == "closed" and not talking:
		shape = {"happy": "smile", "sad": "sad", "surprised": "surprised"}.get(expression, "closed")
	_mouth.texture = _neutral_mouth if shape == "smile" else load(PARTS + "mouth_" + shape + ".png")
	# All textures stay centred on the same source-pixel anchor, never on a crop corner.
	_mouth.position = Vector2.ZERO
	_mouth.scale = Vector2.ONE if shape == "smile" else Vector2.ONE * .85

func wave() -> void:
	if _waving:
		return
	_waving = true
	_wave = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	_wave.tween_property(_arms[1], "rotation", -2.0, .3)
	for index in 3:
		_wave.tween_property(_elbows[1], "rotation", -.35, .16)
		_wave.tween_property(_elbows[1], "rotation", .1, .16)
	_wave.tween_property(_arms[1], "rotation", 0.0, .3)
	_wave.parallel().tween_property(_elbows[1], "rotation", 0.0, .3)
	await _wave.finished
	_waving = false

func neutral_for_review() -> void:
	set_process(false)
	for tween in [_breath, _settle, _wave, _blink_tween]:
		if is_instance_valid(tween):
			tween.kill()
	walking = false
	talking = false
	_body.position = Vector2.ZERO
	_body.scale = Vector2.ONE
	_head.position = _rest_head
	_head.rotation = 0
	for joint in _arms + _elbows + _wrists:
		joint.rotation = 0
	_reset_limbs()
	_eyes.modulate.a = 1
	_closed_eyes.hide()
	_show_mouth("smile")
