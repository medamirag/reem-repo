@tool
extends "res://addons/popochiu/engine/interfaces/i_character.gd"

# classes ----
const PCReem := preload("res://game/characters/reem/character_reem.gd")
const PCJad := preload("res://game/characters/jad/character_jad.gd")
const PCThaaloob := preload("res://game/characters/thaaloob/character_thaaloob.gd")
const PCShahd := preload("res://game/characters/shahd/character_shahd.gd")
# ---- classes

# nodes ----
var Reem: PCReem : get = get_Reem
var Jad: PCJad : get = get_Jad
var Thaaloob: PCThaaloob : get = get_Thaaloob
var Shahd: PCShahd : get = get_Shahd
# ---- nodes

# functions ----
func get_Reem() -> PCReem: return get_runtime_character("Reem")
func get_Jad() -> PCJad: return get_runtime_character("Jad")
func get_Thaaloob() -> PCThaaloob: return get_runtime_character("Thaaloob")
func get_Shahd() -> PCShahd: return get_runtime_character("Shahd")
# ---- functions
