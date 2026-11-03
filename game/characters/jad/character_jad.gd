@tool
extends NpcCharacter
## Grandpa Sulaiman (game_spec.md 3): seated on his bench under the olive tree in the Yard.
## Never walks. Small scale pulse while speaking (NpcCharacter).

const Data := preload("character_jad_state.gd")

var state: Data = load("res://game/characters/jad/character_jad.tres")
