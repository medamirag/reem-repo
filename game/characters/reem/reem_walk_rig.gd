class_name ReemWalkRig
extends Node2D
## Reem's walk cycle, built from the separate pieces of reem_parts.png (cut into
## res://assets/cut/reem_parts/) plus an eye and a smile from reem_face.png. Shown only while
## she walks; standing and talking still use reem_base.png. Turn it off with
## CharacterReem.use_walk_rig if it ever looks wrong: Reem then walks with the simple bob.
##
## All positions are in the pixels of reem_base.png (1254 x 1254, feet at the bottom middle),
## so the rig gets exactly the same scale as Reem's normal picture. Pivots are the joints:
## shoulders, elbows, hips, knees.

const PARTS := "res://assets/cut/reem_parts/"
const FACE := "res://assets/cut/reem_face/"
## Where reem_base.png's bottom-middle (Reem's feet) is, in its own pixels.
const FEET := Vector2(627, 1254)

## Steps per second (one step = one leg forward).
@export var steps_per_second := 2.0
## How far the legs swing forward and back, in degrees.
@export var leg_swing := 24.0
## How much the knee of the back leg bends while it swings forward, in degrees.
@export var knee_bend := 30.0
## How far the arms swing, in degrees (opposite to the legs).
@export var arm_swing := 16.0
## Up-down bounce of the whole body while walking, in reem_base pixels.
@export var bounce := 14.0

var walking := false
var _phase := 0.0

var _shoulder_back: Node2D
var _elbow_back: Node2D
var _shoulder_front: Node2D
var _elbow_front: Node2D
var _hip_back: Node2D
var _knee_back: Node2D
var _hip_front: Node2D
var _knee_front: Node2D
var _body: Node2D


func _ready() -> void:
	_build()


func _process(delta: float) -> void:
	if not walking:
		return

	# Keep the size and facing of Reem's normal picture (Popochiu flips it when she turns).
	var picture := get_parent().get_node_or_null("Sprite2D") as Sprite2D
	if picture:
		match_picture(picture)

	_phase += delta * steps_per_second * PI
	var s := sin(_phase)
	# Legs: forward is a negative rotation when Reem faces right (Godot's y axis points down).
	_hip_front.rotation_degrees = -leg_swing * s
	_hip_back.rotation_degrees = leg_swing * s
	# The leg that is swinging forward bends at the knee; the standing leg stays straight.
	_knee_front.rotation_degrees = knee_bend * maxf(0.0, -cos(_phase)) * (1.0 if s > 0.0 else 0.0)
	_knee_back.rotation_degrees = knee_bend * maxf(0.0, -cos(_phase)) * (1.0 if s < 0.0 else 0.0)
	# Arms swing opposite to the legs on the same side.
	_shoulder_front.rotation_degrees = arm_swing * s
	_shoulder_back.rotation_degrees = -arm_swing * s
	_elbow_front.rotation_degrees = -6.0 - 6.0 * maxf(0.0, s)
	_elbow_back.rotation_degrees = -6.0 - 6.0 * maxf(0.0, -s)
	# Body goes up a little at mid-step.
	_body.position.y = -absf(s) * bounce


## Copies the size and facing (flip) of Reem's normal picture, so the rig always matches it.
func match_picture(picture: Sprite2D) -> void:
	var facing := -1.0 if picture.flip_h else 1.0
	scale = Vector2(absf(picture.scale.x) * facing, picture.scale.y)


## Starts or stops the walk cycle. Stopping puts every joint back to standing.
func set_walking(value: bool) -> void:
	walking = value
	if walking:
		return

	_phase = 0.0
	for joint in [_hip_front, _hip_back, _knee_front, _knee_back, _shoulder_front,
			_shoulder_back, _elbow_front, _elbow_back]:
		(joint as Node2D).rotation = 0.0
	_body.position.y = 0.0


#region Building ###################################################################################
func _build() -> void:
	for child in get_children():
		child.queue_free()

	_body = Node2D.new()
	_body.name = "Body"
	add_child(_body)

	# Drawn back to front.
	var arm_back := _limb(_body, "ArmBack", Vector2(565, 525),
		"arm_upper_back.png", Vector2(69, 20), "arm_lower_back.png", Vector2(48, 15), 0.65, 147.0)
	_shoulder_back = arm_back[0]
	_elbow_back = arm_back[1]

	var leg_back := _limb(_body, "LegBack", Vector2(585, 790),
		"leg_upper_back.png", Vector2(61, 15), "leg_lower_back.png", Vector2(84, 10), 0.85, 165.0)
	_hip_back = leg_back[0]
	_knee_back = leg_back[1]

	var leg_front := _limb(_body, "LegFront", Vector2(650, 790),
		"leg_upper_front.png", Vector2(60, 15), "leg_lower_front.png", Vector2(84, 10), 0.85, 165.0)
	_hip_front = leg_front[0]
	_knee_front = leg_front[1]

	_piece(_body, "Tunic", PARTS + "body.png", Vector2(615, 455), Vector2(165, 0), 1.0)
	_piece(_body, "Head", PARTS + "head.png", Vector2(610, 440), Vector2(180, 400), 1.0)
	_piece(_body, "Eye", FACE + "eye_open.png", Vector2(738, 252), Vector2(89, 92), 0.36)
	_piece(_body, "Mouth", FACE + "mouth_smile.png", Vector2(745, 325), Vector2(92, 31), 0.3)
	_piece(_body, "Bag", PARTS + "bag.png", Vector2(602, 659), Vector2(127, 209), 1.0)

	var arm_front := _limb(_body, "ArmFront", Vector2(672, 525),
		"arm_upper_front.png", Vector2(70, 20), "arm_lower_front.png", Vector2(48, 15), 0.65, 147.0)
	_shoulder_front = arm_front[0]
	_elbow_front = arm_front[1]


## A picture whose point `pivot` (in its own pixels) sits at `at` (in reem_base pixels).
func _piece(
	parent: Node2D, piece_name: String, path: String, at: Vector2, pivot: Vector2, piece_scale: float
) -> Sprite2D:
	var sprite := Sprite2D.new()
	sprite.name = piece_name
	sprite.texture = load(path)
	sprite.centered = false
	sprite.scale = Vector2.ONE * piece_scale
	sprite.position = at - FEET - pivot * piece_scale
	parent.add_child(sprite)
	return sprite


## An arm or a leg: an upper piece turning at `joint` (shoulder or hip) and a lower piece turning
## at a second joint `length` pixels further down (elbow or knee). Returns [upper joint, lower joint].
func _limb(
	parent: Node2D, limb_name: String, joint: Vector2, upper: String, upper_pivot: Vector2,
	lower: String, lower_pivot: Vector2, piece_scale: float, length: float
) -> Array:
	var top := Node2D.new()
	top.name = limb_name
	top.position = joint - FEET
	parent.add_child(top)

	var upper_sprite := Sprite2D.new()
	upper_sprite.texture = load(PARTS + upper)
	upper_sprite.centered = false
	upper_sprite.scale = Vector2.ONE * piece_scale
	upper_sprite.position = -upper_pivot * piece_scale
	top.add_child(upper_sprite)

	var bottom := Node2D.new()
	bottom.name = limb_name + "Lower"
	bottom.position = Vector2(0, length)
	top.add_child(bottom)

	var lower_sprite := Sprite2D.new()
	lower_sprite.texture = load(PARTS + lower)
	lower_sprite.centered = false
	lower_sprite.scale = Vector2.ONE * piece_scale
	lower_sprite.position = -lower_pivot * piece_scale
	bottom.add_child(lower_sprite)

	return [top, bottom]


#endregion
