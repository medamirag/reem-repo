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
const PRStream := preload("res://game/rooms/stream/room_stream.gd")
const PRPineFork := preload("res://game/rooms/pine_fork/room_pine_fork.gd")
const PROakForest := preload("res://game/rooms/oak_forest/room_oak_forest.gd")
const PRRockCave := preload("res://game/rooms/rock_cave/room_rock_cave.gd")
const PRMeadowLake := preload("res://game/rooms/meadow_lake/room_meadow_lake.gd")
const PRHoneyOrchard := preload("res://game/rooms/honey_orchard/room_honey_orchard.gd")
const PRHillSlope := preload("res://game/rooms/hill_slope/room_hill_slope.gd")
const PRWaterfallPath := preload("res://game/rooms/waterfall_path/room_waterfall_path.gd")
const PRNarrowPass := preload("res://game/rooms/narrow_pass/room_narrow_pass.gd")
const PRHilltopFestival := preload("res://game/rooms/hilltop_festival/room_hilltop_festival.gd")
const PRGullShore := preload("res://game/rooms/gull_shore/room_gull_shore.gd")
const PRTideCave := preload("res://game/rooms/tide_cave/room_tide_cave.gd")
const PRGullLighthouse := preload("res://game/rooms/gull_lighthouse/room_gull_lighthouse.gd")
const PRRamadanLane := preload("res://game/rooms/ramadan_lane/room_ramadan_lane.gd")
const PRHedgehogCourt := preload("res://game/rooms/hedgehog_court/room_hedgehog_court.gd")
const PRIftarShelter := preload("res://game/rooms/iftar_shelter/room_iftar_shelter.gd")
const PRMarketGate := preload("res://game/rooms/market_gate/room_market_gate.gd")
const PRMarketStalls := preload("res://game/rooms/market_stalls/room_market_stalls.gd")
const PRScaleCourtyard := preload("res://game/rooms/scale_courtyard/room_scale_courtyard.gd")
const PRSnowEdge := preload("res://game/rooms/snow_edge/room_snow_edge.gd")
const PRSnowTracks := preload("res://game/rooms/snow_tracks/room_snow_tracks.gd")
const PRSledHill := preload("res://game/rooms/sled_hill/room_sled_hill.gd")
const PRGiantBloom := preload("res://game/rooms/giant_bloom/room_giant_bloom.gd")
const PRDewBank := preload("res://game/rooms/dew_bank/room_dew_bank.gd")
const PRAntCity := preload("res://game/rooms/ant_city/room_ant_city.gd")
const PRStarRidge := preload("res://game/rooms/star_ridge/room_star_ridge.gd")
const PRObservatoryDome := preload("res://game/rooms/observatory_dome/room_observatory_dome.gd")
const PROwlPerch := preload("res://game/rooms/owl_perch/room_owl_perch.gd")
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
var Stream: PRStream : get = get_Stream
var PineFork: PRPineFork : get = get_PineFork
var OakForest: PROakForest : get = get_OakForest
var RockCave: PRRockCave : get = get_RockCave
var MeadowLake: PRMeadowLake : get = get_MeadowLake
var HoneyOrchard: PRHoneyOrchard : get = get_HoneyOrchard
var HillSlope: PRHillSlope : get = get_HillSlope
var WaterfallPath: PRWaterfallPath : get = get_WaterfallPath
var NarrowPass: PRNarrowPass : get = get_NarrowPass
var HilltopFestival: PRHilltopFestival : get = get_HilltopFestival
var GullShore: PRGullShore : get = get_GullShore
var TideCave: PRTideCave : get = get_TideCave
var GullLighthouse: PRGullLighthouse : get = get_GullLighthouse
var RamadanLane: PRRamadanLane : get = get_RamadanLane
var HedgehogCourt: PRHedgehogCourt : get = get_HedgehogCourt
var IftarShelter: PRIftarShelter : get = get_IftarShelter
var MarketGate: PRMarketGate : get = get_MarketGate
var MarketStalls: PRMarketStalls : get = get_MarketStalls
var ScaleCourtyard: PRScaleCourtyard : get = get_ScaleCourtyard
var SnowEdge: PRSnowEdge : get = get_SnowEdge
var SnowTracks: PRSnowTracks : get = get_SnowTracks
var SledHill: PRSledHill : get = get_SledHill
var GiantBloom: PRGiantBloom : get = get_GiantBloom
var DewBank: PRDewBank : get = get_DewBank
var AntCity: PRAntCity : get = get_AntCity
var StarRidge: PRStarRidge : get = get_StarRidge
var ObservatoryDome: PRObservatoryDome : get = get_ObservatoryDome
var OwlPerch: PROwlPerch : get = get_OwlPerch
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
func get_Stream() -> PRStream: return get_runtime_room("Stream")
func get_PineFork() -> PRPineFork: return get_runtime_room("PineFork")
func get_OakForest() -> PROakForest: return get_runtime_room("OakForest")
func get_RockCave() -> PRRockCave: return get_runtime_room("RockCave")
func get_MeadowLake() -> PRMeadowLake: return get_runtime_room("MeadowLake")
func get_HoneyOrchard() -> PRHoneyOrchard: return get_runtime_room("HoneyOrchard")
func get_HillSlope() -> PRHillSlope: return get_runtime_room("HillSlope")
func get_WaterfallPath() -> PRWaterfallPath: return get_runtime_room("WaterfallPath")
func get_NarrowPass() -> PRNarrowPass: return get_runtime_room("NarrowPass")
func get_HilltopFestival() -> PRHilltopFestival: return get_runtime_room("HilltopFestival")
func get_GullShore() -> PRGullShore: return get_runtime_room("GullShore")
func get_TideCave() -> PRTideCave: return get_runtime_room("TideCave")
func get_GullLighthouse() -> PRGullLighthouse: return get_runtime_room("GullLighthouse")
func get_RamadanLane() -> PRRamadanLane: return get_runtime_room("RamadanLane")
func get_HedgehogCourt() -> PRHedgehogCourt: return get_runtime_room("HedgehogCourt")
func get_IftarShelter() -> PRIftarShelter: return get_runtime_room("IftarShelter")
func get_MarketGate() -> PRMarketGate: return get_runtime_room("MarketGate")
func get_MarketStalls() -> PRMarketStalls: return get_runtime_room("MarketStalls")
func get_ScaleCourtyard() -> PRScaleCourtyard: return get_runtime_room("ScaleCourtyard")
func get_SnowEdge() -> PRSnowEdge: return get_runtime_room("SnowEdge")
func get_SnowTracks() -> PRSnowTracks: return get_runtime_room("SnowTracks")
func get_SledHill() -> PRSledHill: return get_runtime_room("SledHill")
func get_GiantBloom() -> PRGiantBloom: return get_runtime_room("GiantBloom")
func get_DewBank() -> PRDewBank: return get_runtime_room("DewBank")
func get_AntCity() -> PRAntCity: return get_runtime_room("AntCity")
func get_StarRidge() -> PRStarRidge: return get_runtime_room("StarRidge")
func get_ObservatoryDome() -> PRObservatoryDome: return get_runtime_room("ObservatoryDome")
func get_OwlPerch() -> PROwlPerch: return get_runtime_room("OwlPerch")
# ---- functions
