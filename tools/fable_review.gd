extends SceneTree
## Review pictures of a character rig: every pose at real game size and at 400%.
## Needs a real renderer (a small window opens for a few seconds):
##   godot --path . --script res://tools/fable_review.gd -- grandpa
## Saves <pose>_100.png and <pose>_400.png in docs/rigs/<name>_review/. Then
## tools/fable_review_sheet.py arranges them into the sheets for the user.

const PAD := 24.0

var _name := "grandpa"


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		_name = args[0]
	_run.call_deferred()


func _config() -> Dictionary:
	match _name:
		"grandpa":
			return {
				"script": "res://game/characters/jad/grandpa_rig.gd",
				"canvas": Vector2(604, 982), "feet": Vector2(302, 982), "scale": 0.438,
				"poses": [
					["1_rest", {}],
					["2_breath_in", {"breath": 1.0}],
					["3_blink", {"blink": true, "breath": 0.5}],
					["4_talk_open", {"mouth": "open", "lean": 0.014, "head": -0.018, "hand": 0.135}],
					["5_greeting_rising", {"heart": 0.55, "head": 0.01}],
					["6_greeting_hand_on_heart", {"heart": 1.0, "head": 0.05, "breath": 0.3}],
					["7_sad", {"face": "sad", "mouth": "sad", "head": 0.05}],
					["8_surprised", {"face": "surprised", "mouth": "surprised", "head": -0.035, "rise": 3.0}],
				],
			}
	return {}


func _run() -> void:
	var config := _config()
	if config.is_empty():
		print("[REVIEW] unknown character ", _name)
		quit(1)
		return
	var out := "res://docs/rigs/%s_review" % _name
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(out))
	root.size = Vector2i(640, 360)
	var views := {}
	for zoom in [1.0, 4.0]:
		var view := SubViewport.new()
		var view_scale: float = config.scale * zoom
		view.size = Vector2i((config.canvas * view_scale + Vector2.ONE * PAD * 2.0 * zoom).ceil())
		view.transparent_bg = true
		view.render_target_update_mode = SubViewport.UPDATE_ALWAYS
		root.add_child(view)
		var actor := Node2D.new()
		actor.position = config.feet * view_scale + Vector2.ONE * PAD * zoom
		view.add_child(actor)
		var rig: Node2D = load(config.script).new()
		rig.scale = Vector2.ONE * view_scale
		actor.add_child(rig)
		views[zoom] = [view, rig]
	await process_frame
	for entry in config.poses:
		for zoom in views:
			views[zoom][1].pose_for_review(entry[1])
		await process_frame
		await process_frame
		await RenderingServer.frame_post_draw
		for zoom in views:
			var image: Image = views[zoom][0].get_texture().get_image()
			image.save_png("%s/%s_%d.png" % [out, entry[0], int(zoom * 100)])
		print("[REVIEW] ok: ", entry[0])
	print("[REVIEW] DONE")
	quit()
