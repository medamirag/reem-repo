@tool
extends NpcCharacter
## Shahd the bee (game_spec.md 3): hovers near the hives in BigTree, about 1/5 of Reem's height.
## Wings flap and the body bobs (child node "Hover", shahd_hover.gd); she pulses softly while
## speaking (NpcCharacter).

const Data := preload("character_shahd_state.gd")

var state: Data = load("res://game/characters/shahd/character_shahd.tres")
