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


func _ready() -> void:
	green_label.theme = ArabicText.get_theme()
	sand_label.theme = ArabicText.get_theme()
	ArabicText.make_rtl(green_label)
	ArabicText.make_rtl(sand_label)

	green_button.pressed.connect(_on_green_pressed)
	sand_button.pressed.connect(_on_sand_pressed)


## Shows `green_text` on the green button and `sand_text` on the sand button. Call this right
## after instancing the scene, before adding it to the tree (or right after).
func setup(green_text: String, sand_text: String) -> void:
	green_label.text = "[center]%s[/center]" % green_text
	sand_label.text = "[center]%s[/center]" % sand_text


func _on_green_pressed() -> void:
	A.sfx_ui_click.play()
	picked.emit(true)


func _on_sand_pressed() -> void:
	A.sfx_ui_click.play()
	picked.emit(false)
