@tool
extends "res://addons/popochiu/engine/interfaces/i_room.gd"

# classes ----
const PRTestArabic := preload("res://game/rooms/test_arabic/room_test_arabic.gd")
const PRTitle := preload("res://game/rooms/title/room_title.gd")
const PRGrandpaRoom := preload("res://game/rooms/grandpa_room/room_grandpa_room.gd")
const PRYard := preload("res://game/rooms/yard/room_yard.gd")
const PRGate := preload("res://game/rooms/gate/room_gate.gd")
const PRMeadowFork := preload("res://game/rooms/meadow_fork/room_meadow_fork.gd")
const PRBigTree := preload("res://game/rooms/big_tree/room_big_tree.gd")
const PRFoxRock := preload("res://game/rooms/fox_rock/room_fox_rock.gd")
const PREnd := preload("res://game/rooms/end/room_end.gd")
# ---- classes

# nodes ----
var TestArabic: PRTestArabic : get = get_TestArabic
var Title: PRTitle : get = get_Title
var GrandpaRoom: PRGrandpaRoom : get = get_GrandpaRoom
var Yard: PRYard : get = get_Yard
var Gate: PRGate : get = get_Gate
var MeadowFork: PRMeadowFork : get = get_MeadowFork
var BigTree: PRBigTree : get = get_BigTree
var FoxRock: PRFoxRock : get = get_FoxRock
var End: PREnd : get = get_End
# ---- nodes

# functions ----
func get_TestArabic() -> PRTestArabic: return get_runtime_room("TestArabic")
func get_Title() -> PRTitle: return get_runtime_room("Title")
func get_GrandpaRoom() -> PRGrandpaRoom: return get_runtime_room("GrandpaRoom")
func get_Yard() -> PRYard: return get_runtime_room("Yard")
func get_Gate() -> PRGate: return get_runtime_room("Gate")
func get_MeadowFork() -> PRMeadowFork: return get_runtime_room("MeadowFork")
func get_BigTree() -> PRBigTree: return get_runtime_room("BigTree")
func get_FoxRock() -> PRFoxRock: return get_runtime_room("FoxRock")
func get_End() -> PREnd: return get_runtime_room("End")
# ---- functions
