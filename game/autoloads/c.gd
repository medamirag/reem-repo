@tool
extends "res://addons/popochiu/engine/interfaces/i_character.gd"

# classes ----
const PCReem := preload("res://game/characters/reem/character_reem.gd")
# ---- classes

# nodes ----
var Reem: PCReem : get = get_Reem
# ---- nodes

# functions ----
func get_Reem() -> PCReem: return get_runtime_character("Reem")
# ---- functions
