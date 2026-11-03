class_name ArabicText
extends RefCounted
## One place to control how Arabic text is drawn in the GUI.
##
## Godot shapes and connects Arabic by itself, but only if the font actually contains Arabic
## letters. Popochiu's GUI theme ships with Open Sans, which does not, so every GUI node that
## shows Arabic gets the Cairo font (res://assets/fonts/) and a right-to-left reading direction
## from here. Change the two constants below to change the look everywhere at once.

## The Arabic font used by every piece of on-screen text.
const FONT_PATH := "res://assets/fonts/static/Cairo-Regular.ttf"
## Size of the dialogue text and of the choice buttons, in pixels on a 1920x1080 screen.
const FONT_SIZE := 40
## Height reserved for one line of text. Arabic needs more room than Latin because of the
## vowel marks that sit above and below the letters.
const LINE_HEIGHT := 72

static var _theme: Theme = null
static var _font: FontFile = null


## Returns the shared Theme that makes text use the Arabic font at [constant FONT_SIZE].
## Assign it to a Control and every node under it inherits it.
static func get_theme() -> Theme:
	if _theme == null:
		_theme = Theme.new()
		_theme.default_font = get_font()
		_theme.default_font_size = FONT_SIZE

	return _theme


## Returns the shared Cairo font resource, for nodes (titles, buttons) that need a different
## size than [constant FONT_SIZE] and so set their own font-size override instead of using
## [method get_theme].
static func get_font() -> FontFile:
	if _font == null:
		_font = load(FONT_PATH)

	return _font


## Makes [param control] read right to left and shape its letters as Arabic. Works on any
## Control that renders text (RichTextLabel, Label, Button, ...).
static func make_rtl(control: Control) -> void:
	control.text_direction = Control.TEXT_DIRECTION_RTL
	control.language = "ar"
