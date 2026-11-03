class_name ChoicePopup
extends Control
## The small custom choice popup described in game_spec.md 4.2: the two wooden buttons
## (`choice_green`, `choice_sand`) with Arabic labels, centred on screen. Used instead of
## Popochiu's own dialog-option strip, which is meant for the generic black bottom bar, not
## this game's wooden-sign look.

signal picked(is_green: bool)

@onready var green_button: TextureButton = %GreenButton
@onready var sand_button: TextureButton = %SandButton
@onready var green_label: RichTextLabel = %GreenLabel
@onready var sand_label: RichTextLabel = %SandLabel

# The labels only exist once the popup is in the scene tree (@onready), so setup() stores the
# texts here and _ready() writes them.
var _green_text := ""
var _sand_text := ""


func _ready() -> void:
	green_label.theme = ArabicText.get_theme()
	sand_label.theme = ArabicText.get_theme()
	ArabicText.make_rtl(green_label)
	ArabicText.make_rtl(sand_label)

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
	green_label.text = "[center]%s[/center]" % _green_text
	sand_label.text = "[center]%s[/center]" % _sand_text


func _on_green_pressed() -> void:
	A.sfx_ui_click.play()
	picked.emit(true)


func _on_sand_pressed() -> void:
	A.sfx_ui_click.play()
	picked.emit(false)
