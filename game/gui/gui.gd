# @popochiu-docs-ignore-class
extends "res://addons/popochiu/engine/objects/gui/templates/simple_click_high_res/simple_click_high_res_gui.gd"


## The game's own cursor pictures (res://assets/art/ui/cursors.png, game_spec.md 2), used when
## the mouse is over something that can be clicked. Key = the Popochiu cursor type (the
## `cursor` set on each prop, hotspot and character).
const CURSORS := {
	"use": "res://assets/cut/cursors/cursor_use_small.png",
	"active": "res://assets/cut/cursors/cursor_pickup_small.png",
	"talk": "res://assets/cut/cursors/cursor_talk_small.png",
	"look": "res://assets/cut/cursors/cursor_look_small.png",
	"search": "res://assets/cut/cursors/cursor_look_small.png",
	"right": "res://assets/cut/cursors/cursor_exit_small.png",
	"up": "res://assets/cut/cursors/cursor_exit_small.png",
	"down": "res://assets/cut/cursors/cursor_exit_small.png",
	"left": "res://assets/cut/cursors/cursor_exit_left_small.png",
}


#region Godot ######################################################################################
func _ready() -> void:
	# Must happen before super(): Popochiu copies these frames into its cursor in _ready().
	_install_cursors()
	super()


#endregion

#region Virtual ####################################################################################
# Called when the GUI is blocked and should not handle input events.
func _on_blocked(props := { blocking = true }) -> void:
	super(props)


# Called when the GUI is unblocked and can handle input events again.
func _on_unblocked() -> void:
	super()


# Called to hide the GUI.
func _on_hidden() -> void:
	super()


# Called to show the GUI.
func _on_shown() -> void:
	super()


# Called when `G.show_system_text()` is triggered.
# `super()` shows `msg` in the SystemText component. Override or extend if needed.
func _on_system_text_shown(msg: String) -> void:
	super(msg)


# Called when the player closes the SystemText component (for example by
# clicking the screen anywhere).
func _on_system_text_hidden() -> void:
	super()


# Called when the mouse enters (hovers) a `clickable`.
func _on_mouse_entered_clickable(clickable: PopochiuClickable) -> void:
	super(clickable)
	# No hover text in this game: Popochiu's hover text is English ("Use X with Y") and the
	# players are young children who read Arabic only (game_spec.md: Arabic only).
	G.show_hover_text()


# Called when the mouse exits a `clickable`.
func _on_mouse_exited_clickable(clickable: PopochiuClickable) -> void:
	super(clickable)


# Called when the mouse enters (hovers) an `inventory_item`.
func _on_mouse_entered_inventory_item(inventory_item: PopochiuInventoryItem) -> void:
	super(inventory_item)
	# No hover text in this game: Popochiu's hover text is English ("Use X with Y") and the
	# players are young children who read Arabic only (game_spec.md: Arabic only).
	G.show_hover_text()


# Called when the mouse exits an `inventory_item`.
func _on_mouse_exited_inventory_item(inventory_item: PopochiuInventoryItem) -> void:
	super(inventory_item)


# Called when a dialog line is spoken by a `PopochiuCharacter` (i.e. when
# `PopochiuCharacter.say()` is called).
func _on_dialog_line_started() -> void:
	super()


# Called when a dialog line finishes (for example after the player clicks the
# screen to dismiss it).
func _on_dialog_line_finished() -> void:
	super()


# Called when a `dialog` starts (after calling `PopochiuDialog.start()`).
func _on_dialog_started(dialog: PopochiuDialog) -> void:
	super(dialog)


# Called when a `dialog` finishes (after calling `PopochiuDialog.stop()`).
func _on_dialog_finished(dialog: PopochiuDialog) -> void:
	super(dialog)


# Called when an inventory `item` is selected (for example, by clicking it).
func _on_inventory_item_selected(item: PopochiuInventoryItem) -> void:
	super(item)


# Called by `PopochiuCursor` to get the name of the cursor texture to show.
func _get_cursor_name() -> String:
	return super()


#endregion


#region Private ####################################################################################
## Replaces the pictures of the cursor types listed in CURSORS. The normal arrow and the
## hourglass ("wait") stay Popochiu's own.
func _install_cursors() -> void:
	var cursor := get_node_or_null("Cursor") as AnimatedSprite2D
	if cursor == null or cursor.sprite_frames == null:
		return

	var frames: SpriteFrames = cursor.sprite_frames.duplicate()
	for anim: String in CURSORS:
		var texture: Texture2D = load(CURSORS[anim])
		if texture == null:
			continue
		if not frames.has_animation(anim):
			frames.add_animation(anim)
		frames.clear(anim)
		frames.add_frame(anim, texture)
	cursor.sprite_frames = frames


#endregion
