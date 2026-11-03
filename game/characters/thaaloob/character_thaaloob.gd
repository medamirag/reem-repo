@tool
extends NpcCharacter
## Thaaloob the fox (game_spec.md 3): stands next to the big rock in FoxRock, about Reem's height.
## Small scale pulse while speaking (NpcCharacter).

const Data := preload("character_thaaloob_state.gd")

var state: Data = load("res://game/characters/thaaloob/character_thaaloob.tres")
