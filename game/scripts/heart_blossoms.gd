extends RefCounted
## Additional flowers on the existing canopy after the third good deed.

const SPOTS := [
	Vector2(.41, .29), Vector2(.57, .23), Vector2(.67, .38), Vector2(.34, .40),
	Vector2(.50, .41), Vector2(.53, .14), Vector2(.26, .33), Vector2(.75, .31),
	Vector2(.39, .18), Vector2(.61, .49), Vector2(.47, .53), Vector2(.73, .47),
]


static func draw(canvas: CanvasItem, rect: Rect2) -> void:
	var count := clampi(Globals.blossoms - 3, 0, SPOTS.size())
	var radius := minf(rect.size.x, rect.size.y) * .016
	for index in count:
		var center: Vector2 = rect.position + rect.size * SPOTS[index]
		for petal in 5:
			var offset := Vector2.from_angle(TAU * petal / 5.0) * radius
			canvas.draw_circle(center + offset, radius, Color("#ffbdd2"), true, -1, true)
		canvas.draw_circle(center, radius * .72, Color("#ffdf86"), true, -1, true)
