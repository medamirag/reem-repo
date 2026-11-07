@tool
extends ReemRoom

const COINS := ["Coin1", "Coin2", "Coin3", "Coin4", "Coin5"]
@export var state: PopochiuRoomData


func _on_room_started() -> void:
	var story := Globals.market
	if story.get(script_name, false):
		return
	story[script_name] = true
	match script_name:
		"MarketGate": await Lines.say("reem_market_arrive", true)
		"MarketStalls": await Lines.say("reem_market_baker", true)
		"ScaleCourtyard": await Lines.say("reem_market_scale", true)


func _setup_room() -> void:
	_sync_market()


func _on_restore_from_savegame() -> void:
	super()
	_sync_market()


func _sync_market() -> void:
	var story := Globals.market
	match script_name:
		"MarketGate":
			$SaleCoins.visible = story.get("sold", false)
		"MarketStalls":
			var paid: bool = story.get("bread", false)
			var picked: Dictionary = story.get("picked", {})
			for index in COINS.size():
				var coin := get_prop(COINS[index])
				coin.visible = not paid or index < 2
				coin.position.y = 757.0 if picked.has(COINS[index]) else 824.0
				coin.get_node("Sprite2D").modulate = Color("#fff2ac") if picked.has(COINS[index]) else Color.WHITE
			$CatBread.visible = story.get("shared", false)
		"ScaleCourtyard":
			var unfair: bool = story.get("tilted", false) and not story.get("corrected", false)
			$ScaleBeam.rotation = 0.23 if unfair else 0.0
			$ScaleBeam/LeftPan.rotation = -$ScaleBeam.rotation
			$ScaleBeam/RightPan.rotation = -$ScaleBeam.rotation
			$ScaleBeam/LeftPan/Weight.visible = story.get("left_weight", false)
			$ScaleBeam/RightPan/Weight.visible = story.get("right_weight", false)
			$ScaleBeam/Counterweight.position.x = 0 if story.get("corrected", false) else 105
			$Props/MarketFox/Apron.visible = not story.get("corrected", false)


func is_exit_open(exit_name: String) -> bool:
	if exit_name == "ExitLeft":
		return true
	if script_name == "MarketGate":
		return Globals.market.get("sold", false)
	return Globals.market.get("bread", false)


func has_action(obj: PopochiuClickable) -> bool:
	var story := Globals.market
	match obj.script_name:
		"HoneyStall": return not story.get("sold", false)
		"Baker": return not story.get("bread", false)
		"Pay": return story.get("paying", false) and not story.get("bread", false)
		"MarketCat": return story.get("bread", false) and not story.get("shared", false)
		"MarketFox": return not story.get("fair", false)
		"LeftWeight", "RightWeight", "Lever": return story.get("testing", false) and not story.get("fair", false)
		"Witness": return story.get("tested", false) and not story.get("corrected", false)
	if obj.script_name in COINS:
		return story.get("paying", false) and not story.get("bread", false)
	return super(obj)


func _on_object_clicked(obj: PopochiuClickable) -> void:
	if not has_action(obj):
		return
	var story := Globals.market
	match obj.script_name:
		"ExitLeft":
			var back := {"MarketGate": "Gate", "MarketStalls": "MarketGate", "ScaleCourtyard": "MarketStalls"}
			await leave_through(obj, back[script_name])
		"ExitRight":
			var next := {"MarketGate": "MarketStalls", "MarketStalls": "ScaleCourtyard"}
			await leave_through(obj, next[script_name])
		"HoneyStall": await _sell_honey()
		"Baker":
			story["paying"] = true
			await Lines.say("reem_market_baker", true)
		"Pay": await _pay_for_bread()
		"MarketCat": await _offer_bread()
		"MarketFox": await _meet_fox()
		"LeftWeight", "RightWeight":
			var key := "left_weight" if obj.script_name == "LeftWeight" else "right_weight"
			story[key] = not story.get(key, false)
			A.sfx_ui_click.play()
			_sync_market()
			E.save_game(1)
		"Lever": await _test_scale()
		"Witness": await _show_witness()
		_:
			if obj.script_name in COINS:
				var picked: Dictionary = story.get("picked", {})
				if picked.has(obj.script_name):
					picked.erase(obj.script_name)
				else:
					picked[obj.script_name] = true
				story["picked"] = picked
				A.sfx_ui_click.play()
				_sync_market()


func _sell_honey() -> void:
	if C.player.has_inventory_item("HoneyJar"):
		await C.player.remove_from_inventory(I.HoneyJar)
	Globals.market["sold"] = true
	Globals.market["coins"] = 5
	_sync_market()
	await Lines.say("reem_market_sale", true)
	E.save_game(1)


func _pay_for_bread() -> void:
	var story := Globals.market
	var count: int = story.get("picked", {}).size()
	story["picked"] = {}
	if count != 3:
		_sync_market()
		await Lines.say("reem_market_count", true)
		return
	story["coins"] = 2
	story["bread"] = true
	_sync_market()
	await Lines.say("reem_market_paid", true)
	E.save_game(1)


func _offer_bread() -> void:
	var story := Globals.market
	await Lines.say("reem_market_cat", true)
	if await Choices.ask_two(Globals.notebook.labels["market_share"], Globals.notebook.labels["market_keep"]):
		story["shared"] = true
		Globals.friend_cards["market_cat"] = true
		_reward("kept_bread")
		_sync_market()
		await Lines.say("reem_market_share", true)
	else:
		if not story.get("kept_bread", false):
			story["kept_bread"] = true
			Globals.wilt()
		await Lines.say("reem_market_keep", true)
	E.save_game(1)


func _meet_fox() -> void:
	var story := Globals.market
	if story.get("testing", false):
		await Lines.say("reem_market_weights", true)
		return
	await Lines.say("fox_market_offer")
	if await Choices.ask_two(Globals.notebook.labels["market_test"], Globals.notebook.labels["market_agree"]):
		story["testing"] = true
		await Lines.say("reem_market_weights", true)
	else:
		if not story.get("trusted", false):
			story["trusted"] = true
			Globals.wilt()
		story["tilted"] = true
		_sync_market()
		await Lines.say("reem_market_trust", true)
	E.save_game(1)


func _test_scale() -> void:
	var story := Globals.market
	if not story.get("left_weight", false) or not story.get("right_weight", false):
		await Lines.say("reem_market_weights", true)
		return
	if story.get("corrected", false):
		story["fair"] = true
		_reward("trusted")
		_sync_market()
		await Lines.say("reem_market_fair", true)
	else:
		story["tested"] = true
		story["tilted"] = true
		_sync_market()
		await Lines.say("reem_market_tilt", true)
	E.save_game(1)


func _show_witness() -> void:
	var story := Globals.market
	story["corrected"] = true
	story["left_weight"] = false
	story["right_weight"] = false
	_sync_market()
	await Lines.say("fox_market_sorry")
	E.save_game(1)


func _reward(mistake: String) -> void:
	if Globals.market.get(mistake, false):
		Globals.market[mistake] = false
		Globals.heal()
	else:
		Globals.bloom()
