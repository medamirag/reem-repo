@tool
extends PopochiuRoom
## End screen (game_spec.md): to_be_continued.png, the heart tree large in the centre
## (heart_full if every mistake was fixed and there were at least 3 good deeds, otherwise its
## current picture), Grandpa's closing words as narration (jad_s2_071), then «يتبع…» and a
## button «العودة إلى البداية» that starts a new game on the title screen.

const Data := preload('room_end_state.gd')
const HEART_PIECES_DIR := "res://assets/cut/heart_tree_states/"
## Height of the big heart tree on screen, in pixels.
@export var heart_height := 440.0
const CONTINUED_FONT_SIZE := 110
const BUTTON_FONT_SIZE := 46

var state: Data = load("res://game/rooms/end/room_end.tres")
## True once the closing narration is over and the button shows (read by tools/playtest.gd).
var started := false

@onready var _background: Sprite2D = $Background
@onready var _heart: Sprite2D = $BigHeart
@onready var _continued: RichTextLabel = $ContinuedLabel
@onready var _back_button: Button = $BackButton


#region Godot ######################################################################################
func _ready() -> void:
	super()

	_continued.add_theme_font_override("normal_font", ArabicText.get_font())
	_continued.add_theme_font_size_override("normal_font_size", CONTINUED_FONT_SIZE)
	_continued.add_theme_color_override("default_color", Color(1, 0.97, 0.88))
	_continued.add_theme_color_override("font_outline_color", Color(0.25, 0.13, 0.03))
	_continued.add_theme_constant_override("outline_size", 18)
	ArabicText.make_rtl(_continued)

	_back_button.add_theme_font_override("font", ArabicText.get_font())
	_back_button.add_theme_font_size_override("font_size", BUTTON_FONT_SIZE)
	ArabicText.make_rtl(_back_button)

	if Engine.is_editor_hint():
		return

	_back_button.pressed.connect(_on_back_pressed)


#endregion

#region Virtual ####################################################################################
func _on_room_entered() -> void:
	if not Globals.festival.get("completed", false):
		Globals.clear_autosave()
	RoomHelpers.fit_background(_background, width, height)
	Globals.play_ambience("amb_meadow")

	_heart.texture = load(HEART_PIECES_DIR + Globals.end_heart_picture() + ".tres")
	if _heart.texture:
		_heart.scale = Vector2.ONE * (heart_height / _heart.texture.get_size().y)

	_continued.text = "[center]%s[/center]" % Labels.TO_BE_CONTINUED
	_continued.hide()
	_back_button.text = Labels.BACK_TO_START
	_back_button.hide()


func _on_room_transition_finished() -> void:
	# Jad is not on this screen, so Lines shows his words in the narration box.
	if not Globals.festival.get("completed", false):
		await Lines.say("jad_s2_071")
	_continued.show()
	_back_button.show()
	started = true


func _on_room_exited() -> void:
	pass


func _on_restore_from_savegame() -> void:
	pass


#endregion

#region Private ####################################################################################
func _on_back_pressed() -> void:
	A.sfx_ui_click.play()
	_back_button.disabled = true
	if not Globals.festival.get("completed", false):
		await Globals.new_game()
	Globals.play_ambience("")
	R.goto_room("Title")


#endregion
