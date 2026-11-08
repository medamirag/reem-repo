class_name ChoicePopup
extends Control
## The small custom choice popup described in game_spec.md 4.2: the two wooden buttons
## (`choice_green`, `choice_sand`) with Arabic labels, centred on screen. Used instead of
## Popochiu's own dialog-option strip, which is meant for the generic black bottom bar, not
## this game's wooden-sign look.

signal picked(is_green: bool)

@onready var green_button: TextureButton = %GreenButton
@onready var sand_button: TextureButton = %SandButton
@onready var green_label: Label = %GreenLabel
@onready var sand_label: Label = %SandLabel

# The labels only exist once the popup is in the scene tree (@onready), so setup() stores the
# texts here and _ready() writes them.
var _green_text := ""
var _sand_text := ""


func _ready() -> void:
	green_label.theme = ArabicText.get_theme()
	sand_label.theme = ArabicText.get_theme()
	ArabicText.make_rtl(green_label)
	ArabicText.make_rtl(sand_label)
	# Readable on both boards (docs/BUGS.md #3): dark brown on the pale sand wood, and a dark
	# green outline around the white letters on the green wood.
	sand_label.add_theme_color_override("font_color", Color(0.30, 0.16, 0.04))
	green_label.add_theme_constant_override("outline_size", 10)
	green_label.add_theme_color_override("font_outline_color", Color(0.13, 0.30, 0.06))

	green_button.pressed.connect(_on_green_pressed)
	sand_button.pressed.connect(_on_sand_pressed)

	_show_texts()


## Shows `green_text` on the green button and `sand_text` on the sand button. Safe to call
## before or after adding the popup to the tree.
func setup(green_text: String, sand_text: String) -> void:
	_green_text = green_text
	_sand_text = sand_text

	if is_node_ready():
		_show_texts()


func _show_texts() -> void:
	green_label.text = _green_text
	sand_label.text = _sand_text
	# A choice with only one button (Yard: «عندي شيءٌ أقولُه لك») passes an empty sand text.
	sand_button.visible = not _sand_text.is_empty()


func _on_green_pressed() -> void:
	A.sfx_ui_click.play()
	picked.emit(true)


func _on_sand_pressed() -> void:
	A.sfx_ui_click.play()
	picked.emit(false)
