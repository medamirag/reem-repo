extends SceneTree
## Draws Reem's walk rig at several moments of a step next to reem_base.png and saves PNGs, to
## check the walk cycle by eye. Needs a display (or Xvfb):
##   godot --path . --rendering-driver opengl3 --script res://tools/rig_preview.gd -- <out_folder>

var _out := "user://"


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		_out = args[0]
	_run.call_deferred()


func _run() -> void:
	# A fixed-size canvas of our own, so the project's window stretch settings do not matter.
	var viewport := SubViewport.new()
	viewport.size = Vector2i(1920, 1080)
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	root.add_child(viewport)

	var bg := ColorRect.new()
	bg.color = Color(0.75, 0.9, 0.7)
	bg.size = Vector2(1920, 1080)
	viewport.add_child(bg)

	var base := Sprite2D.new()
	base.texture = load("res://assets/art/characters/reem/reem_base.png")
	base.offset = Vector2(0, -627)
	base.scale = Vector2.ONE * 0.36
	base.position = Vector2(300, 1000)
	viewport.add_child(base)

	var rigs: Array[ReemWalkRig] = []
	for i in 4:
		var rig := ReemWalkRig.new()
		rig.scale = Vector2.ONE * 0.36
		rig.position = Vector2(700 + i * 330, 1000)
		viewport.add_child(rig)
		rigs.append(rig)

	await process_frame
	for i in rigs.size():
		rigs[i].set_walking(true)
		rigs[i]._phase = i * PI / 4.0 - 0.0001
		rigs[i]._process(0.0001)
		rigs[i].walking = false  # freeze this pose

	await process_frame
	await RenderingServer.frame_post_draw
	viewport.get_texture().get_image().save_png(_out + "/rig_poses.png")
	print("saved ", _out + "/rig_poses.png")
	quit()
