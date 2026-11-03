extends Node
## The choice system from game_spec.md 4.2: shows the two wooden buttons, centred on screen,
## and waits for the child to click one.
##
## Registered as the autoload `Choices`. Use it from a room like:
##   var went_green := await Choices.ask_two(green_text, sand_text)

const ChoicePopupScene := preload("res://game/gui/components/choice_popup/choice_popup.tscn")


## Shows the popup with `green_text` on the green button and `sand_text` on the sand button.
## Blocks the game while it waits, the same way Popochiu blocks it during its own dialogs.
## Returns `true` if the child clicked the green button, `false` for the sand one.
func ask_two(green_text: String, sand_text: String) -> bool:
	G.block()

	var popup: ChoicePopup = ChoicePopupScene.instantiate()
	popup.setup(green_text, sand_text)
	G.gui.add_child(popup)

	var is_green: bool = await popup.picked

	popup.queue_free()
	G.unblock()

	return is_green
