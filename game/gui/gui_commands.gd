# @popochiu-docs-ignore-class
extends SimpleClickCommands
## Child-friendly fallbacks (CLAUDE.md rule 7: "Every click does something or nothing").
## Popochiu's SimpleClick template shows English system text such as "Can't INTERACT with it"
## when a click has nothing to do. For this game such a click simply does nothing.


# Called when `E.command_fallback()` is triggered.
func fallback() -> void:
	super()


# Called when the player left-clicks a `PopochiuClickable` that has nothing to do.
# If an inventory item was selected, it is quietly put back instead of showing a message.
func click_clickable() -> void:
	if PopochiuUtils.i.active:
		PopochiuUtils.i.active.deselect()
	await RenderingServer.frame_post_draw


# Called when the player right-clicks a `PopochiuClickable` that has nothing to do.
func right_click_clickable() -> void:
	await RenderingServer.frame_post_draw


# Called when the player left-clicks a `PopochiuInventoryItem`: selects it (Popochiu default).
func click_inventory_item() -> void:
	if PopochiuUtils.i.active and PopochiuUtils.i.active != PopochiuUtils.i.clicked:
		PopochiuUtils.i.active.deselect()
		return
	PopochiuUtils.i.clicked.set_active()


# Called when the player right-clicks a `PopochiuInventoryItem`.
func right_click_inventory_item() -> void:
	await RenderingServer.frame_post_draw
