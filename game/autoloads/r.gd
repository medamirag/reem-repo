@tool
extends "res://addons/popochiu/engine/interfaces/i_room.gd"

# classes ----
const PRTestArabic := preload("res://game/rooms/test_arabic/room_test_arabic.gd")
const PRTitle := preload("res://game/rooms/title/room_title.gd")
const PRGrandpaRoom := preload("res://game/rooms/grandpa_room/room_grandpa_room.gd")
const PRYard := preload("res://game/rooms/yard/room_yard.gd")
# ---- classes

# nodes ----
var TestArabic: PRTestArabic : get = get_TestArabic
var Title: PRTitle : get = get_Title
var GrandpaRoom: PRGrandpaRoom : get = get_GrandpaRoom
var Yard: PRYard : get = get_Yard
# ---- nodes

# functions ----
func get_TestArabic() -> PRTestArabic: return get_runtime_room("TestArabic")
func get_Title() -> PRTitle: return get_runtime_room("Title")
func get_GrandpaRoom() -> PRGrandpaRoom: return get_runtime_room("GrandpaRoom")
func get_Yard() -> PRYard: return get_runtime_room("Yard")
# ---- functions
