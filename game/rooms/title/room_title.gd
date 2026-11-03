@tool
extends PopochiuRoom
## The title screen from game_spec.md: the title in large Arabic text over the empty sky, and
## a button below it that starts the game. Not part of the point-and-click rooms, so it has no
## player character and hides Popochiu's own GUI (inventory bar, etc.).

const Data := preload('room_title_state.gd')
const TITLE_FONT_SIZE := 90
const BUTTON_FONT_SIZE := 46

var state: Data = load("res://game/rooms/title/room_title.tres")

@onready var _background: Sprite2D = $Background
@onready var _title_label: RichTextLabel = $TitleLabel
@onready var _start_button: Button = $StartButton


#region Godot ######################################################################################
func _ready() -> void:
	super()

	_title_label.add_theme_font_override("normal_font", ArabicText.get_font())
	_title_label.add_theme_font_size_override("normal_font_size", TITLE_FONT_SIZE)
	_title_label.add_theme_color_override("font_outline_color", Color(0.35, 0.18, 0.05))
	_title_label.add_theme_constant_override("outline_size", 16)
	ArabicText.make_rtl(_title_label)

	_start_button.add_theme_font_override("font", ArabicText.get_font())
	_start_button.add_theme_font_size_override("font_size", BUTTON_FONT_SIZE)
	ArabicText.make_rtl(_start_button)

	if Engine.is_editor_hint():
		return

	_start_button.pressed.connect(_on_start_pressed)


#endregion

#region Virtual ####################################################################################
func _on_room_entered() -> void:
	_fit_background()


func _on_room_transition_finished() -> void:
	pass


func _on_room_exited() -> void:
	pass


func _on_restore_from_savegame() -> void:
	pass


#endregion

#region Private ####################################################################################
func _fit_background() -> void:
	if not is_instance_valid(_background) or _background.texture == null:
		return

	var texture_size := _background.texture.get_size()
	_background.scale = Vector2.ONE * maxf(width / texture_size.x, height / texture_size.y)


func _on_start_pressed() -> void:
	A.sfx_ui_click.play()
	R.goto_room("GrandpaRoom")


#endregion
