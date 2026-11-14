extends TextureRect
## The heart tree from game_spec.md 4.3: top-right corner, about 140 px tall, shows the child's
## choices. Picture and pulse are driven entirely by Globals (blossoms/wilts/bloom/wilt/heal).

const Blossoms := preload("res://game/scripts/heart_blossoms.gd")
const PIECES_DIR := "res://assets/cut/heart_tree_states/"
const GROW_SCALE := 1.18
const GROW_TIME := 0.3

var _base_scale: Vector2
var _tween: Tween


func _ready() -> void:
	_base_scale = scale
	Globals.heart_changed.connect(_on_heart_changed)
	_refresh()


func _on_heart_changed(grew: bool) -> void:
	_refresh()

	if grew:
		_pulse()
		ReemEffects.burst(self, size * Vector2(.5, .3), "petals")


func _refresh() -> void:
	var piece_name := Globals.heart_picture()
	texture = load(PIECES_DIR + piece_name + ".tres")
	queue_redraw()


func _draw() -> void:
	if texture:
		var fit := minf(size.x / texture.get_width(), size.y / texture.get_height())
		var drawn_size := texture.get_size() * fit
		Blossoms.draw(self, Rect2((size - drawn_size) / 2.0, drawn_size))


func _pulse() -> void:
	if is_instance_valid(_tween):
		_tween.kill()

	scale = _base_scale * GROW_SCALE
	_tween = create_tween()
	_tween.tween_property(self, "scale", _base_scale, GROW_TIME) \
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
