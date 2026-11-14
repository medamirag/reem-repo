extends SceneTree
## Isolated walk fixture: approved face/neutral and eight distance-driven gait poses.
const CUTOUT := preload("res://game/characters/reem/reem_cutout.tscn")
const SOURCE := preload("res://assets/art/characters/reem/reem_base.png")
const PAD := Vector2(96, 96)
const OUT := "res://docs/reem_walk_v2"
var failed := false
var actor: Node2D
var rig: ReemWalkRig
var viewport: SubViewport
var canvas: Control
var caption: Label

func _initialize() -> void:
	_run.call_deferred()

func check(value: bool, message: String) -> void:
	print("[ALIGN] ", "ok: " if value else "FAIL: ", message)
	failed = failed or not value

func _run() -> void:
	root.size = Vector2i(1450, 820)
	root.content_scale_size = Vector2i(1450, 820)
	root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	viewport = SubViewport.new()
	viewport.size = Vector2i(1446, 1446)
	viewport.transparent_bg = true
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	root.add_child(viewport)
	actor = Node2D.new()
	actor.position = ReemWalkRig.FEET + PAD
	viewport.add_child(actor)
	rig = CUTOUT.instantiate()
	actor.add_child(rig)
	rig.neutral_for_review()
	_make_review_window()
	rig.apply_walk_phase(0.0, 0.0)
	var fade_neutral := true
	for leg in 2:
		fade_neutral = fade_neutral and rig._hips[leg].position.is_equal_approx(rig._rest_hips[leg]) and absf(rig._hips[leg].rotation) < .00001 and absf(rig._knees[leg].rotation) < .00001
	check(fade_neutral, "walk fade begins at the exact neutral joints")
	rig.neutral_for_review()
	await process_frame
	await process_frame
	var geometry_ok := true
	for part in rig.find_children("*", "Polygon2D", true, false):
		for index in part.polygon.size():
			var at: Vector2 = part.global_transform * part.polygon[index] - PAD
			var hidden_cap: bool = part.get_meta("virtual_cap", false) and part.uv[index].y == 1030
			if not hidden_cap and at.distance_to(part.uv[index]) > .001:
				geometry_ok = false
	check(geometry_ok, "every neutral body polygon is registered to the original source pixels")
	check(rig._eyes.global_position.is_equal_approx(Vector2(718.5, 238.5) + PAD), "open/closed eyes share original eye anchor")
	var mouth_anchor := rig._mouth.global_position
	for shape in ["smile", "closed", "open", "sad", "surprised"]:
		rig.talking = true
		rig._show_mouth(shape)
		check(rig._mouth.global_position.is_equal_approx(mouth_anchor), "fixed mouth anchor: " + shape)
	rig.neutral_for_review()
	var overlay := Sprite2D.new()
	overlay.name = "ReferenceOverlay"
	overlay.texture = SOURCE
	overlay.centered = false
	overlay.position = -ReemWalkRig.FEET
	overlay.modulate.a = .5
	actor.add_child(overlay)
	await capture("overlay_50", "Original (left) / cutout + 50% original overlay (right)")
	overlay.queue_free()
	await process_frame
	check(not actor.has_node("ReferenceOverlay"), "temporary reference overlay removed")
	await capture("neutral_side_by_side", "Original (left) / aligned neutral cutout (right)")
	await native_capture("neutral_rgba")
	# Test a planted back foot while translating the character by the matching distance.
	rig.apply_walk_phase(.16)
	var planted := rig._feet[1].global_position
	actor.position.x += 12
	rig.apply_walk_phase(.16 + 12.0 / (rig._effective_stride() / .5))
	check(planted.distance_to(rig._feet[1].global_position) < .02, "stance foot stays planted during root travel")
	actor.position = ReemWalkRig.FEET + PAD
	for roll in [[.015, Vector2(-50, 71)], [.40, Vector2(88, 71)]]:
		rig.apply_walk_phase(roll[0])
		var contact: Vector2 = rig._feet[1].global_transform * roll[1]
		actor.position.x += 2
		rig.apply_walk_phase(roll[0] + 2.0 / (rig._effective_stride() / .5))
		check(contact.distance_to(rig._feet[1].global_transform * roll[1]) < .02, "heel/toe contact remains planted while rolling")
		actor.position = ReemWalkRig.FEET + PAD
	var knee_ok := true
	var sole_ok := true
	var arms_ok := true
	var knee_limit_ok := true
	var poses: Array = []
	for index in 8:
		var phase: float = index / 8.0
		rig.apply_walk_phase(phase)
		arms_ok = arms_ok and rig._arms[0].rotation * rig._arms[1].rotation <= .00001
		poses.append([rig._feet[0].global_position, rig._feet[1].global_position])
		if index % 4 == 0:
			check(absf(absf(rig._arms[1].rotation) - deg_to_rad(20)) < .001, "near shoulder swings 20 degrees at contact")
			var front_leg := 1 if index == 0 else 0
			var rear_leg := 1 - front_leg
			var front_heel: Vector2 = rig._feet[front_leg].global_transform * Vector2(-50, 71)
			var rear_toe: Vector2 = rig._feet[rear_leg].global_transform * Vector2(88, 71)
			check(absf((front_heel.x - rear_toe.x) / 155.0 - 1.5) < .01, "heel-to-toe contact gap is 1.5 foot lengths")
			var hand: Vector2 = rig._wrists[1].global_transform * Vector2(-15, 53)
			var bag: Vector2 = rig._body.global_transform * (Vector2(510, 780) - ReemWalkRig.FEET)
			check(hand.distance_to(bag) > 90.0, "near hand leaves the bag on both contact poses")
			for leg in 2:
				var thigh_angle := (rig._knees[leg].global_position - rig._hips[leg].global_position).angle() - PI / 2
				check(absf(absf(thigh_angle) - deg_to_rad(25)) < .001, "contact thigh angle is 25 degrees")
		if index % 4 == 1 or index % 4 == 3:
			check(absf(absf(rig._body.position.y) / 1203.0 - .02606) < .001, "Down/Up bob is 2.6 percent of visible height")
		for leg in 2:
			var hip := rig._hips[leg].global_position
			var knee := rig._knees[leg].global_position
			var foot := rig._feet[leg].global_position
			var line_x := lerpf(hip.x, foot.x, (knee.y - hip.y) / (foot.y - hip.y))
			knee_ok = knee_ok and knee.x >= line_x - .01
			var upper := (knee - hip).normalized()
			var lower := (foot - knee).normalized()
			if (index == 2 and leg == 0) or (index == 6 and leg == 1):
				check(absf(absf(upper.angle_to(lower)) - deg_to_rad(40)) < .001, "passing knee bends 40 degrees")
				var lowest_toe: Vector2 = rig._feet[leg].global_transform * Vector2(100, 71)
				check(PAD.y + 1227.0 - lowest_toe.y > 30.0, "passing shoe is clearly off the floor")
			knee_limit_ok = knee_limit_ok and absf(upper.angle_to(lower)) <= deg_to_rad(40.01)
			sole_ok = sole_ok and absf(rig._feet[leg].global_rotation) < .27
		await capture("walk_%d" % (index + 1), "Original (left) / walk phase %.2f (right)" % phase)
		await native_capture("walk_%d_rgba" % (index + 1))
	check(knee_ok, "both knees bend forward")
	check(knee_limit_ok, "knee bend stays within 40 degrees without stretching the trousers")
	check(arms_ok, "arms swing in opposition on all eight poses")
	check(sole_ok, "heel/toe angles remain gentle")
	for index in 4:
		check(poses[index][0].distance_to(poses[index + 4][1]) < .01 and poses[index][1].distance_to(poses[index + 4][0]) < .01, "half-cycle exchanges legs exactly: %d/%d" % [index+1,index+5])
	check(rig.get_node("Skeleton2D/LegBackLower").modulate.r < .9, "far leg is visibly darker")
	check(rig._hips[1].get_index() > rig._hips[0].get_index(), "near leg draws in front of far leg")
	rig.neutral_for_review()
	rig._show_mouth("open")
	await native_capture("face_talking")
	rig._show_mouth("smile")
	rig._eyes.modulate.a = 0
	rig._closed_eyes.show()
	rig._closed_eyes.modulate.a = 1
	await native_capture("face_blinking")
	rig.neutral_for_review()
	check(not rig.has_node("ReferenceOverlay") and not actor.has_node("ReferenceOverlay"), "finished cutout has no reference overlay")
	print("[ALIGN] ", "FAILED" if failed else "DONE")
	quit(1 if failed else 0)

func _make_review_window() -> void:
	var layer := CanvasLayer.new()
	layer.layer = 1000
	root.add_child(layer)
	canvas = Control.new()
	canvas.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	layer.add_child(canvas)
	var background := ColorRect.new()
	background.color = Color("fff4de")
	background.size = Vector2(1450, 820)
	canvas.add_child(background)
	caption = Label.new()
	caption.position = Vector2(35, 20)
	caption.add_theme_color_override("font_color", Color("4c2e1d"))
	caption.add_theme_font_size_override("font_size", 26)
	canvas.add_child(caption)
	for index in 2:
		var image := TextureRect.new()
		image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		image.texture = SOURCE if index == 0 else viewport.get_texture()
		image.position = Vector2(57, 112) if index == 0 else Vector2(720, 65)
		image.size = Vector2(616, 616) if index == 0 else Vector2(710, 710)
		image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		canvas.add_child(image)

func capture(name: String, title: String) -> void:
	caption.text = title
	if DisplayServer.get_name() == "headless":
		return
	await process_frame
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(OUT + "/" + name + ".png")

func native_capture(name: String) -> void:
	if DisplayServer.get_name() == "headless":
		return
	await process_frame
	await RenderingServer.frame_post_draw
	var frame := viewport.get_texture().get_image()
	if not name.begins_with("walk_"):
		frame = frame.get_region(Rect2i(96, 96, 1254, 1254))
	frame.save_png(OUT + "/" + name + ".png")
