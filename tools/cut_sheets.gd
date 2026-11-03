extends SceneTree
## Cuts the art sheets listed in game_spec.md section 2 into their separate pieces.
##
## Finds connected non-transparent regions (alpha > ALPHA_THRESHOLD) in each sheet, ignores
## specks smaller than MIN_AREA, numbers the pieces left to right then top to bottom, and saves
## each one as its own PNG under res://assets/cut/<sheet_name>/.
##
## Run with:
##   godot --headless --script res://tools/cut_sheets.gd
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
]


func _init() -> void:
	for sheet_path in SHEETS:
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

			while not stack.is_empty():
				var p: Vector2i = stack.pop_back()
				area += 1
				min_x = mini(min_x, p.x)
				max_x = maxi(max_x, p.x)
				min_y = mini(min_y, p.y)
				max_y = maxi(max_y, p.y)

				for d in [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]:
					var np := p + d
					if np.x < 0 or np.x >= w or np.y < 0 or np.y >= h:
						continue
					var nidx := np.y * w + np.x
					if visited[nidx]:
						continue
					visited[nidx] = 1
					if image.get_pixel(np.x, np.y).a8 > ALPHA_THRESHOLD:
						stack.append(np)

			if area >= MIN_AREA:
				boxes.append(Rect2i(min_x, min_y, max_x - min_x + 1, max_y - min_y + 1))

	# Number left to right, then top to bottom: sort by the box's vertical band first (using a
	# generous band height so pieces roughly on the same row stay together), then by x.
	var band_height: int = maxi(1, h / 8)
	boxes.sort_custom(func(a: Rect2i, b: Rect2i) -> bool:
		var band_a := a.position.y / band_height
		var band_b := b.position.y / band_height
		if band_a != band_b:
			return band_a < band_b
		return a.position.x < b.position.x
	)

	var n := 1
	for box in boxes:
		var piece: Image = image.get_region(box)
		var out_path := "%s/%02d.png" % [out_dir, n]
		piece.save_png(ProjectSettings.globalize_path(out_path))
		print("%s -> %s  (%d x %d at %d,%d)" % [
			sheet_name, out_path, box.size.x, box.size.y, box.position.x, box.position.y
		])
		n += 1
