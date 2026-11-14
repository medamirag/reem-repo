extends SceneTree
## Isolated alignment fixture: original/overlay/neutral, face closeups and four gait phases.
const CUTOUT := preload("res://game/characters/reem/reem_cutout.tscn")
const SOURCE := preload("res://assets/art/characters/reem/reem_base.png")
const OUT := "res://docs/reem_alignment"
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
	viewport.size = Vector2i(1254, 1254)
	viewport.transparent_bg = true
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	root.add_child(viewport)
	actor = Node2D.new()
	actor.position = ReemWalkRig.FEET
	viewport.add_child(actor)
	rig = CUTOUT.instantiate()
	actor.add_child(rig)
	rig.neutral_for_review()
	_make_review_window()
	await process_frame
	await process_frame
	var geometry_ok := true
	for part in rig.find_children("*", "Polygon2D", true, false):
		for index in part.polygon.size():
			var at: Vector2 = part.global_transform * part.polygon[index]
			var hidden_cap: bool = part.get_meta("virtual_cap", false) and at.y < 1000 and part.uv[index].y == 1000
			if not hidden_cap and at.distance_to(part.uv[index]) > .001:
				geometry_ok = false
	check(geometry_ok, "every neutral body polygon is registered to the original source pixels")
	check(rig._eyes.global_position.is_equal_approx(Vector2(718.5, 238.5)), "open/closed eyes share original eye anchor")
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
	rig.apply_walk_phase(.1)
	var planted := rig._feet[0].global_position
	actor.position.x += 12
	rig.apply_walk_phase(.1 + 12.0 / (rig._effective_stride() / .6))
	check(planted.distance_to(rig._feet[0].global_position) < .02, "stance foot stays planted during root travel")
	actor.position = ReemWalkRig.FEET
	var knee_ok := true
	var sole_ok := true
	for index in 4:
		var phase: float = [.05, .3, .55, .8][index]
		rig.apply_walk_phase(phase)
		for leg in 2:
			var hip := rig._hips[leg].global_position
			var knee := rig._knees[leg].global_position
			var foot := rig._feet[leg].global_position
			var line_x := lerpf(hip.x, foot.x, (knee.y - hip.y) / (foot.y - hip.y))
			knee_ok = knee_ok and knee.x >= line_x - .01
			sole_ok = sole_ok and absf(rig._feet[leg].global_rotation) < .001
		await capture("walk_%d" % (index + 1), "Original (left) / walk phase %.2f (right)" % phase)
		await native_capture("walk_%d_rgba" % (index + 1))
	check(knee_ok, "both knees bend forward")
	check(sole_ok, "ankles keep both soles level")
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
		image.position = Vector2(10 + index * 710, 65)
		image.size = Vector2(710, 710)
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
	viewport.get_texture().get_image().save_png(OUT + "/" + name + ".png")
