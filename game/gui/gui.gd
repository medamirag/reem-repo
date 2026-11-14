# @popochiu-docs-ignore-class
extends "res://addons/popochiu/engine/objects/gui/templates/simple_click_high_res/simple_click_high_res_gui.gd"


## Legacy frame resources retained for Popochiu cursor API compatibility.
## Rendering uses only the native arrow; both software cursor sources stay hidden.
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
	process_mode = Node.PROCESS_MODE_ALWAYS
	_use_normal_pointer()


func _process(_delta: float) -> void:
	_use_normal_pointer()


func _use_normal_pointer() -> void:
	# Hide the whole software-cursor layer: blocked GUI/inventory calls cannot reveal it.
	var cursor := PopochiuUtils.cursor
	if not is_instance_valid(cursor):
		return
	$Cursor.hide()
	cursor.hide()
	cursor.set_process(false)
	var point := get_viewport().get_mouse_position()
	cursor.main_cursor.position = point
	cursor.secondary_cursor.position = point
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)


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
	# players are young children who read Arabic only (game_spec.md: Arabic only). Cleared
	# first, also while an item is held (docs/BUGS.md #9).
	G.show_hover_text()
	# Over something that would do nothing if clicked right now, keep the normal arrow.
	var room := R.current as ReemRoom
	if PopochiuUtils.g.is_blocked or PopochiuUtils.i.active:
		return
	if room and not room.has_action(clickable):
		PopochiuUtils.cursor.show_cursor("normal")


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
## hourglass ("wait") resources stay Popochiu's own, but are never rendered.
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


## Automatic saves and Continue must never wait for a confirmation popup.
func _on_game_saved() -> void:
	pass


func _on_game_loaded(_loaded_game: Dictionary) -> void:
	G.load_feedback_finished.emit.call_deferred()
