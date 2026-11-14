class_name ReemEffects
extends Node2D
## Disposable CPU particles work with Godot's Compatibility renderer.
static func burst(parent: Node, at: Vector2, kind: String) -> CPUParticles2D:
	var particles := CPUParticles2D.new()
	particles.name = kind.capitalize() + "Particles"
	particles.position = at
	particles.z_index = 150
	particles.amount = 20 if kind == "petals" else 14
	particles.one_shot = true
	particles.explosiveness = .95
	particles.lifetime = 1.15
	particles.direction = Vector2.UP
	particles.spread = 65
	particles.gravity = Vector2(0, 100 if kind == "water" else 45)
	particles.initial_velocity_min = 35
	particles.initial_velocity_max = 105
	particles.scale_amount_min = 2
	particles.scale_amount_max = 5
	particles.color = {"petals": Color("ffbad4"), "sparkles": Color("ffe18b"), "water": Color("87d9ff")}.get(kind, Color.WHITE)
	var image := Image.create(12, 12, false, Image.FORMAT_RGBA8)
	for y in 12:
		for x in 12:
			var p := Vector2(x - 5.5, y - 5.5)
			var inside := p.length() < 4.5
			if kind == "sparkles":
				inside = absf(p.x) + absf(p.y) < 5.5
			elif kind == "petals":
				inside = Vector2(p.x * .7, p.y * 1.3).length() < 4.5
			image.set_pixel(x, y, Color.WHITE if inside else Color.TRANSPARENT)
	particles.texture = ImageTexture.create_from_image(image)
	# Texture pixels define shape; these values keep the bursts small and gentle.
	particles.scale_amount_min = .35
	particles.scale_amount_max = .8
	var fade := Gradient.new()
	fade.set_color(0, Color.WHITE)
	fade.set_color(1, Color(1, 1, 1, 0))
	particles.color_ramp = fade
	parent.add_child(particles)
	particles.finished.connect(particles.queue_free)
	particles.emitting = true
	return particles

var _card_count := 0

func _ready() -> void:
	_card_count = Globals.friend_cards.size()
	I.item_added.connect(_reward)
	Globals.heart_changed.connect(func(grew: bool):
		if grew:
			_reward(null, null))

func _process(_delta: float) -> void:
	var count := Globals.friend_cards.size()
	if count > _card_count:
		_reward(null, null)
	_card_count = count

func _reward(_item: PopochiuInventoryItem, _character: PopochiuCharacter) -> void:
	if is_instance_valid(C.player):
		burst(self, C.player.position + Vector2(0, -190), "sparkles")
