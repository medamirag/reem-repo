extends PopochiuInventoryItem
## game_spec.md: starts as `stone_shiny`, becomes `stone_dull` once wiped clean (FoxRock room).

const Data := preload("res://addons/popochiu/engine/templates/inventory_item_state_template.gd")
const DULL_TEXTURE := preload("res://assets/cut/stone_states/stone_dull.tres")
const SHINY_TEXTURE := preload("res://assets/cut/stone_states/stone_shiny.tres")

var state: Data = load("res://game/inventory_items/stone/inventory_item_stone.tres")


#region Virtual ####################################################################################
func _on_click() -> void:
	# game_spec.md FoxRock: "After trading, use or click the Stone in the inventory: it becomes
	# stone_dull, reem_s2_055b (Wilt), reem_s2_056b. stone_wiped = true."
	if Globals.traded and not Globals.stone_wiped:
		await _wipe()
	else:
		E.command_fallback()


func _on_right_click() -> void:
	E.command_fallback()


func _on_middle_click() -> void:
	E.command_fallback()


func _on_item_used(_item: PopochiuInventoryItem) -> void:
	# "use or click": using the stone on another item counts too.
	if Globals.traded and not Globals.stone_wiped:
		I.active = null
		await _wipe()
	else:
		E.command_fallback()


func _on_added_to_inventory() -> void:
	super()
	# A new game after the end screen: the stone is shiny again until it is wiped.
	texture = DULL_TEXTURE if Globals.stone_wiped else SHINY_TEXTURE
	A.sfx_pickup.play()


func _on_discard() -> void:
	super()


#endregion

#region Public #####################################################################################
## Swaps the picture to the wiped-clean, dull version (game_spec.md, FoxRock room).
func set_dull() -> void:
	texture = DULL_TEXTURE


func _wipe() -> void:
	set_dull()
	await Lines.say("reem_s2_055b")
	Globals.wilt()
	await Lines.say("reem_s2_056b")
	Globals.stone_wiped = true


#endregion
