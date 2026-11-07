@tool
extends ReemRoom

const Data := preload("room_hilltop_festival_state.gd")
const FOX := "res://assets/art/characters/fox/fox_base.png"
const DUBB := "res://assets/art/characters/dubb/dubb_base.png"
const JAD := "res://assets/art/characters/grandpa/grandpa_festival_seated.png"
const GIFT_DIR := "res://game/rooms/hilltop_festival/"
const VALLEY_FRIENDS := [
	"shahd", "duck", "sinjoob", "qunfood", "qatqoota", "ankoob", "dafdoof", "ghazlana", "tawoos", "qarqoor"
]
var state: Data = load("res://game/rooms/hilltop_festival/room_hilltop_festival.tres")
var guests := {}
var hosting := false

@export var guest_slots := PackedVector2Array([
	Vector2(290, 795), Vector2(485, 817), Vector2(660, 806), Vector2(755, 839),
	Vector2(1125, 845), Vector2(1250, 805), Vector2(1360, 824), Vector2(1500, 811),
	Vector2(1640, 810), Vector2(1760, 844), Vector2(760, 750)
])
@export var lantern_points := PackedVector2Array([
	Vector2(1310, 237), Vector2(1425, 227), Vector2(1550, 216), Vector2(1678, 204)
])
@export var gifts_start := Vector2(1310, 550)
@export var bear_spot := Vector2(455, 835)


func _on_room_started() -> void:
	if not Globals.festival.get("introduced", false):
		Globals.festival["introduced"] = true
		await Lines.say("reem_festival_arrive")


func _setup_room() -> void:
	_sync_festival()


func _on_restore_from_savegame() -> void:
	super()
	_sync_festival()


func is_exit_open(exit_name: String) -> bool:
	if exit_name == "ExitMountain":
		return not hosting and Globals.unlocked_packs.get("6", false)
	return not hosting and (exit_name == "ExitLeft" or Globals.festival.get("completed", false))


func has_action(obj: PopochiuClickable) -> bool:
	if obj.script_name == "BigLantern":
		return not hosting and not Globals.festival.get("completed", false)
	return super(obj)


func _on_object_clicked(obj: PopochiuClickable) -> void:
	if not has_action(obj):
		return
	match obj.script_name:
		"ExitLeft": await leave_through(obj, "NarrowPass")
		"ExitRight": await leave_through(obj, "End")
		"ExitMountain":
			await Lines.say("reem_star_offer", true)
			if await Choices.ask_two(Globals.notebook.labels["star_travel"], Globals.notebook.labels["star_stay"]):
				await leave_through(obj, "OwlPerch")
		"BigLantern": await _light_festival()


func _sync_festival() -> void:
	var complete: bool = Globals.festival.get("completed", false)
	$Lights.visible = complete
	$Props/BigLantern/Sprite2D.modulate = Color("#ffe7ad") if complete else Color("#aaa1a0")
	$UnlitShading.visible = not complete
	for layer_node: Node2D in [$Gathering, $Gifts, $Lights, $UnlitShading, $Bearer]:
		for child in layer_node.get_children():
			layer_node.remove_child(child)
			child.queue_free()
	guests.clear()
	Globals.refresh_friend_cards()
	var attended := 0
	for card: Dictionary in Globals.notebook.data.cards:
		if card.id not in VALLEY_FRIENDS or not Globals.friend_cards.has(card.id):
			continue
		if attended >= guest_slots.size():
			break
		var height := 125.0 if card.id in ["shahd", "duck", "dafdoof", "ankoob"] else 190.0
		guests[card.id] = _sprite($Gathering, card.image, guest_slots[attended], height)
		attended += 1
	if Globals.narrow_pass.get("fox_joins", false) and attended < guest_slots.size():
		guests["thaaloob"] = _sprite($Gathering, FOX, guest_slots[attended], 220.0)
	var gift_paths := {
		"nuts": "res://assets/art/items/oak_acorn.png" if Globals.oak.get("nuts", false) else "",
		"leaves": GIFT_DIR + "gift_leaves.svg" if Globals.oak.get("leaves", false) else "",
		"bell": GIFT_DIR + "gift_bell.svg" if Globals.cave.get("bell", false) else "",
		"threads": GIFT_DIR + "gift_threads.svg" if Globals.cave.get("threads", false) else "",
		"flute": GIFT_DIR + "gift_flute.svg" if Globals.lake.get("flute", false) else "",
		"feathers": "res://assets/art/items/tawoos_feather.png" if Globals.hill.get("feathers", false) else "",
		"duck_feather": GIFT_DIR + "gift_duck_feather.svg" if Globals.stream.get("feather", false) else "",
	}
	var gift_x := gifts_start.x
	for kind: String in gift_paths:
		if not gift_paths[kind].is_empty():
			_sprite($Gifts, gift_paths[kind], Vector2(gift_x, gifts_start.y), 72.0)
			gift_x += 54
	for point in lantern_points:
		_glow(point, 130.0)
		_soft_disc($UnlitShading, point, 152.0, Color(0.1, 0.11, 0.22, 0.62))
	_glow($Props/BigLantern.position + Vector2(0, -136), 340.0)
	$Lights.modulate.a = 1.0
	$UnlitShading.modulate.a = 1.0
	if complete:
		_place_jad(false)


func _sprite(layer_node: Node2D, path: String, feet: Vector2, height: float) -> Sprite2D:
	var sprite := Sprite2D.new()
	sprite.texture = load(path)
	sprite.scale = Vector2.ONE * height / sprite.texture.get_height()
	sprite.position = feet - Vector2(0, height / 2.0)
	layer_node.add_child(sprite)
	return sprite


func _glow(center: Vector2, extent: float) -> void:
	_soft_disc($Lights, center, extent, Color(1, 0.78, 0.34, 0.57))


func _soft_disc(layer_node: Node2D, center: Vector2, extent: float, color: Color) -> void:
	var gradient := Gradient.new()
	gradient.colors = PackedColorArray([color, Color(color, 0.0)])
	var texture := GradientTexture2D.new()
	texture.gradient = gradient
	texture.fill = GradientTexture2D.FILL_RADIAL
	texture.fill_from = Vector2(0.5, 0.5)
	texture.fill_to = Vector2(1.0, 0.5)
	var light := Sprite2D.new()
	light.texture = texture
	light.scale = Vector2.ONE * extent / texture.get_width()
	light.position = center
	layer_node.add_child(light)


func _place_jad(animate: bool) -> void:
	$Bearer.position = bear_spot + (Vector2(-660, 0) if animate else Vector2.ZERO)
	if Globals.orchard.get("carrier", false):
		_sprite($Bearer, DUBB, Vector2.ZERO, 300)
		_sprite($Bearer, JAD, Vector2(19, -163), 179)
	else:
		_sprite($Bearer, JAD, Vector2.ZERO, 190)


func _light_festival() -> void:
	hosting = true
	if guests.has("qarqoor"):
		await Lines.say("reem_festival_high")
		var climb := create_tween()
		climb.tween_property(guests.qarqoor, "position:y", 470.0, 0.8)
		climb.tween_property(guests.qarqoor, "position:y", guests.qarqoor.position.y, 0.8)
		await climb.finished
	await Lines.say("reem_festival_light")
	$Lights.modulate.a = 0.0
	$Lights.show()
	var kindle := create_tween().set_parallel()
	kindle.tween_property($Lights, "modulate:a", 1.0, 1.2)
	kindle.tween_property($UnlitShading, "modulate:a", 0.0, 1.2)
	kindle.tween_property($Props/BigLantern/Sprite2D, "modulate", Color("#ffe7ad"), 1.2)
	await kindle.finished
	_place_jad(true)
	var arrival := create_tween()
	arrival.tween_property($Bearer, "position", bear_spot, 1.5)
	await arrival.finished
	if Globals.orchard.get("carrier", false):
		await Lines.say("jad_festival_arrive")
	await Lines.say("jad_festival_thanks")
	if Globals.repairs > 0 or Globals.flowers_fixed or Globals.mirror_recovered:
		await Lines.say("jad_festival_repair")
	if Globals.wilts > 0:
		await Lines.say("jad_festival_wilt")
	await Lines.say(replay_line())
	Globals.festival["completed"] = true
	for pack in range(1, 7):
		Globals.unlocked_packs[str(pack)] = true
	hosting = false
	E.save_game(1)


func replay_line() -> String:
	if not Globals.friend_cards.has("qunfood"):
		return "jad_festival_oak"
	if not Globals.friend_cards.has("qatqoota"):
		return "jad_festival_cave"
	if not Globals.friend_cards.has("dafdoof"):
		return "jad_festival_lake"
	return "jad_festival_other"
