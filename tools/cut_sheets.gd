extends SceneTree
## Cuts the art sheets listed in game_spec.md section 2 into their separate pieces.
##
## Finds connected non-transparent regions (alpha > ALPHA_THRESHOLD) in each sheet, ignores
## specks smaller than MIN_AREA, numbers the pieces left to right then top to bottom, and saves
## each one as its own PNG under res://assets/cut/<sheet_name>/.
##
## Run with (all sheets below):
##   godot --headless --path . --script res://tools/cut_sheets.gd
## or only some sheets:
##   godot --headless --path . --script res://tools/cut_sheets.gd -- res://assets/art/characters/bees/bees_sheet.png
##
## After running, open res://assets/cut/<sheet_name>/ and rename the numbered pieces you need
## using the clear names from the table in game_spec.md section 2. This script only numbers them;
## it does not know which piece is which.
##
## Never touches the original files in res://assets/ — it only reads them.

const ALPHA_THRESHOLD := 20 # 0-255. Pixels at or below this are treated as transparent.
const MIN_AREA := 60 # Ignore connected regions smaller than this many pixels (tiny specks).

const SHEETS := [
	"res://assets/art/items/mirror_states.png",
	"res://assets/art/items/handmirror_basket.png",
	"res://assets/art/items/notebook_lantern.png",
	"res://assets/art/items/wateringcan_honey.png",
	"res://assets/art/items/stone_states.png",
	"res://assets/art/items/flowers_states.png",
	"res://assets/art/ui/heart_tree_states.png",
	"res://assets/art/characters/bees/bees_sheet.png",
	"res://assets/art/ui/ui_inventory.png",
	"res://assets/art/ui/ui_dialogue.png",
	"res://assets/art/characters/grandpa/grandpa_bench.png",
	"res://assets/art/characters/reem/reem_parts.png",
]


func _init() -> void:
	var sheets: Array = Array(OS.get_cmdline_user_args())
	if sheets.is_empty():
		sheets = SHEETS

	for sheet_path in sheets:
		_cut_sheet(sheet_path)

	print("Done. Check res://assets/cut/<sheet_name>/ and rename the pieces you need.")
	quit()


func _cut_sheet(sheet_path: String) -> void:
	var image := Image.load_from_file(ProjectSettings.globalize_path(sheet_path))

	if image == null:
		printerr("Could not open ", sheet_path)
		return

	var sheet_name := sheet_path.get_file().get_basename()
	var out_dir := "res://assets/cut/%s" % sheet_name
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(out_dir))

	var w := image.get_width()
	var h := image.get_height()
	var visited := PackedByteArray()
	visited.resize(w * h)
	# Which region each pixel belongs to (0 = none), so a piece only keeps its own pixels even
	# when another piece pokes into its bounding box.
	var labels := PackedInt32Array()
	labels.resize(w * h)
	var next_label := 0

	var boxes := [] # Array of Rect2i, one per connected region.

	for y in h:
		for x in w:
			var idx := y * w + x
			if visited[idx]:
				continue
			if image.get_pixel(x, y).a8 <= ALPHA_THRESHOLD:
				visited[idx] = 1
				continue

			# Flood fill this region (4-connected) with a manual stack (no recursion).
			var min_x := x
			var max_x := x
			var min_y := y
			var max_y := y
			var area := 0
			var stack: Array[Vector2i] = [Vector2i(x, y)]
			visited[idx] = 1
			next_label += 1
			labels[idx] = next_label

			while not stack.is_empty():
				var p: Vector2i = stack.pop_back()
				area += 1
				min_x = mini(min_x, p.x)
				max_x = maxi(max_x, p.x)
				min_y = mini(min_y, p.y)
				max_y = maxi(max_y, p.y)

				for d: Vector2i in [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]:
					var np := p + d
					if np.x < 0 or np.x >= w or np.y < 0 or np.y >= h:
						continue
					var nidx := np.y * w + np.x
					if visited[nidx]:
						continue
					visited[nidx] = 1
					if image.get_pixel(np.x, np.y).a8 > ALPHA_THRESHOLD:
						labels[nidx] = next_label
						stack.append(np)

			if area >= MIN_AREA:
				boxes.append({
					rect = Rect2i(min_x, min_y, max_x - min_x + 1, max_y - min_y + 1),
					label = next_label,
				})

	# Number left to right, then top to bottom: sort by the box's vertical band first (using a
	# generous band height so pieces roughly on the same row stay together), then by x.
	var band_height: int = maxi(1, h / 8)
	boxes.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		var ra: Rect2i = a.rect
		var rb: Rect2i = b.rect
		var band_a := ra.position.y / band_height
		var band_b := rb.position.y / band_height
		if band_a != band_b:
			return band_a < band_b
		return ra.position.x < rb.position.x
	)

	var n := 1
	for entry: Dictionary in boxes:
		var box: Rect2i = entry.rect
		var piece: Image = image.get_region(box)
		# Clear pixels that belong to other regions (or to no region: faint halo pixels).
		for py in box.size.y:
			for px in box.size.x:
				if labels[(box.position.y + py) * w + box.position.x + px] != entry.label:
					piece.set_pixel(px, py, Color(0, 0, 0, 0))
		var out_path := "%s/%02d.png" % [out_dir, n]
		piece.save_png(ProjectSettings.globalize_path(out_path))
		print("%s -> %s  (%d x %d at %d,%d)" % [
			sheet_name, out_path, box.size.x, box.size.y, box.position.x, box.position.y
		])
		n += 1
