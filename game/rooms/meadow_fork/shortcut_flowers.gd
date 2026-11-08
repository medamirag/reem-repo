extends Node2D
## Small flowers on the shortcut that react when Reem steps on them.

@export var roots := PackedVector2Array()
var bent := false


func show_bent(value: bool) -> void:
	bent = value
	queue_redraw()


func _draw() -> void:
	var petals := [Color("#ef8cab"), Color("#f5cf53"), Color("#fff6dc")]
	for index in roots.size():
		var root := roots[index]
		var tip := root + (Vector2(21, -6) if bent else Vector2(-3, -23))
		draw_line(root, tip, Color("#416d16"), 3.0, true)
		draw_line(root.lerp(tip, 0.4), root.lerp(tip, 0.4) + Vector2(-8, -5), Color("#619a20"), 3.0, true)
		for petal in 5:
			var center := tip + Vector2.from_angle(petal * TAU / 5.0) * 5.0
			draw_circle(center, 4.5, Color("#775521"), true, -1, true)
			draw_circle(center, 3.6, petals[index % petals.size()], true, -1, true)
		draw_circle(tip, 3.4, Color("#f7aa35"), true, -1, true)
