class_name ReemWalkRig
extends Node2D
## Persistent rigid cutout: Bone2D joints carry overlapping Sprite2D pieces.
const PARTS := "res://game/characters/reem/cutout/"
@export var stride := 160.0
@export var bob_height := 4.0
@export var breathing := 2.5
var walking := false
var talking := false
var expression := "happy"
var _body: Bone2D
var _head: Bone2D
var _arms: Array[Bone2D] = []
var _elbows: Array[Bone2D] = []
var _hips: Array[Bone2D] = []
var _knees: Array[Bone2D] = []
var _feet: Array[Bone2D] = []
var _eyes: Sprite2D
var _mouth: Sprite2D
var _phase := 0.0
var _last_x := 0.0
var _blink_wait := 3.0
var _blinking := false
var _mouth_wait := 0.0
var _mouth_open := false
var _breath: Tween
var _chest: Tween
var _wave: Tween
var _waving := false
var _settling := false
var _settle: Tween
var _lift := 1.0
var _from_feet: Array[Vector2] = []
var _rng := RandomNumberGenerator.new()

func _ready() -> void:
	_rng.randomize()
	var skeleton := Skeleton2D.new()
	skeleton.name = "Skeleton2D"
	add_child(skeleton)
	_body = _bone(skeleton, "Body", Vector2.ZERO)
	for side in ["back", "front"]:
		var x := -55.0 if side == "back" else 65.0
		var hip := _bone(_body, "Hip_" + side, Vector2(x, -260))
		_piece(hip, "leg_upper_" + side, Vector2(-55, -20))
		var knee := _bone(hip, "Knee_" + side, Vector2(0, 110))
		_piece(knee, "leg_lower_" + side, Vector2(-50, -20))
		var foot := _bone(knee, "Ankle_" + side, Vector2(0, 110))
		var shoe := _piece(foot, "foot_" + side, Vector2(-55, -15))
		shoe.scale.y = .68
		_hips.append(hip)
		_knees.append(knee)
		_feet.append(foot)
	# Back arm before tunic, front arm after it.
	_arm("back", Vector2(90, -755))
	var tunic := _piece(_body, "torso", Vector2(-169, -819))
	_chest = create_tween().set_loops().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	_chest.tween_property(tunic, "scale", Vector2(1.005, 1.003), 1.8)
	_chest.tween_property(tunic, "scale", Vector2.ONE, 1.8)
	_arm("front", Vector2(-65, -755))
	_head = _bone(_body, "Head", Vector2(-17, -814))
	_piece(_head, "head", Vector2(-193, -415))
	_eyes = _piece(_head, "eyes_open", Vector2(70, -282))
	_mouth = _piece(_head, "mouth_smile", Vector2(122, -137))
	_last_x = get_parent().global_position.x
	_blink_wait = _rng.randf_range(2.0, 5.0)
	_breath = create_tween().set_loops().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	_breath.tween_property(_head, "position:y", -814.0 - breathing, 1.8)
	_breath.tween_property(_head, "position:y", -814.0, 1.8)

func _bone(parent: Node, label: String, at: Vector2) -> Bone2D:
	var bone := Bone2D.new()
	bone.name = label
	bone.position = at
	bone.rest = Transform2D(0.0, at)
	bone.set_autocalculate_length_and_angle(false)
	bone.length = 110
	parent.add_child(bone)
	return bone

func _piece(parent: Node, label: String, at: Vector2) -> Sprite2D:
	var sprite := Sprite2D.new()
	sprite.name = label
	sprite.texture = load(PARTS + label + ".png")
	sprite.centered = false
	sprite.position = at
	parent.add_child(sprite)
	return sprite

func _arm(side: String, at: Vector2) -> void:
	var shoulder := _bone(_body, "Shoulder_" + side, at)
	_piece(shoulder, "arm_upper_" + side, Vector2(-45, -25))
	var elbow := _bone(shoulder, "Elbow_" + side, Vector2(0, 140))
	_piece(elbow, "arm_lower_" + side, Vector2(-42, -25))
	var wrist := _bone(elbow, "Wrist_" + side, Vector2(0, 125))
	_piece(wrist, "hand_" + side, Vector2(-37, -20))
	_arms.append(shoulder)
	_elbows.append(elbow)

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
		_settle.tween_property(self, "_lift", 1.0, .15)
		return
	_from_feet.clear()
	for foot in _feet:
		_from_feet.append(to_local(foot.global_position))
	_settling = true
	_settle = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	_settle.tween_method(_settle_feet, 0.0, 1.0, .2)
	_settle.tween_callback(func(): _settling = false)
	var arms := create_tween().set_parallel().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	for joint in _arms + _elbows:
		arms.tween_property(joint, "rotation", 0.0, .2)

func _settle_feet(weight: float) -> void:
	for index in 2:
		var goal := Vector2(-55 if index == 0 else 65, -60)
		_solve_leg(index, _from_feet[index].lerp(goal, weight) - _body.position)


func _process(delta: float) -> void:
	var picture := get_parent().get_node_or_null("Sprite2D") as Sprite2D
	if picture:
		match_picture(picture)
	var current_x: float = get_parent().global_position.x
	var distance := absf(current_x - _last_x) / maxf(absf(scale.x), .001)
	_last_x = current_x
	if walking:
		_phase = fmod(_phase + distance / (stride / .6), 1.0)
		_body.position.y = -_lift * bob_height * sin(_phase * TAU * 2.0) ** 2
	else:
		_body.position.y = move_toward(_body.position.y, 0.0, delta * 30)
	for index in 2:
		var p := fmod(_phase + index * .5, 1.0)
		var target := Vector2(-55 if index == 0 else 65, -60)
		if walking:
			if p < .6:
				# Linear stance cancels root travel exactly; toes stay on the ground.
				target.x += stride * (.5 - p / .6)
			else:
				var t := (p - .6) / .4
				var eased: float = Tween.interpolate_value(0.0, 1.0, t, 1.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
				target.x += stride * (eased - .5)
				target.y -= _lift * 38.0 * sin(t * PI)
		if not _settling:
			_solve_leg(index, target - _body.position)
		if walking and not (_waving and index == 1):
			_arms[index].rotation = .24 * _lift * _eased_swing(p)
			_elbows[index].rotation = -.08 - .08 * sin(p * TAU)
	_blink_wait -= delta
	if _blink_wait <= 0 and not _blinking:
		blink()
	_mouth_wait -= delta
	if talking and _mouth_wait <= 0:
		_mouth_open = not _mouth_open
		_mouth_wait = _rng.randf_range(.09, .18)
		_show_mouth("open" if _mouth_open else "closed")

func _solve_leg(index: int, target: Vector2) -> void:
	var offset := target - _hips[index].position
	var distance := clampf(offset.length(), 5.0, 219.9)
	var bend := acos(distance / 220.0)
	_hips[index].rotation = offset.angle() - PI / 2.0 - bend
	_knees[index].rotation = bend * 2.0
	_feet[index].rotation = -_hips[index].rotation - _knees[index].rotation

func blink() -> void:
	_blinking = true
	_eyes.texture = load(PARTS + "eyes_closed.png")
	var tween := create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(_eyes, "scale:y", .7, .06)
	tween.tween_property(_eyes, "scale:y", 1.0, .08)
	await tween.finished
	_eyes.texture = load(PARTS + "eyes_open.png")
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
	tween.tween_property(_head, "rotation", -.025 if value == "sad" else 0.0, .22)

func _show_mouth(shape: String) -> void:
	if not is_instance_valid(_mouth):
		return
	if shape == "closed" and not talking:
		shape = {"happy": "smile", "sad": "sad", "surprised": "surprised"}.get(expression, "closed")
	_mouth.texture = load(PARTS + "mouth_" + shape + ".png")

func wave() -> void:
	if _waving:
		return
	_waving = true
	_wave = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	_wave.tween_property(_arms[1], "rotation", -2.2, .3)
	for index in 3:
		_wave.tween_property(_elbows[1], "rotation", -.55, .16)
		_wave.tween_property(_elbows[1], "rotation", .1, .16)
	_wave.tween_property(_arms[1], "rotation", 0.0, .3)
	_wave.parallel().tween_property(_elbows[1], "rotation", 0.0, .3)
	await _wave.finished
	_waving = false


## Sine easing sampled by distance keeps gait independent of frame rate and walk speed.
func _eased_swing(phase: float) -> float:
	var t := fmod(phase + .25, 1.0)
	return Tween.interpolate_value(-1.0 if t < .5 else 1.0, 2.0 if t < .5 else -2.0, fmod(t, .5) * 2.0, 1.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
