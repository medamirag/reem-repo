"""Writes game_data/words.json (the word-discovery word list) from the table below, and adds
every word that is not yet in content/word_queue.md to that queue (status "done" if its mp3
already exists, otherwise "todo"). Existing queue rows are never changed or removed.
Edit the table and run:  python3 tools/make_words.py   (from the project folder).
game_data/word_areas.json (where each word is in each room) is edited by hand."""
import json
import os

# id: (Arabic word with full diacritics, rooms, objects that are not background areas)
#   objects: "prop:<Name>", "character:<Name>", "decor:<NodeName>" (a node in the room),
#            "item:<InventoryItemName>"
WORDS = {
    "word_ant": ("نَمْلَة", ["GiantBloom"], ["prop:Worker"]),
    "word_ant_queen": ("مَلِكَةُ النَّمْل", ["AntCity"], ["prop:Queen"]),
    "word_beetle": ("خُنْفُسَاء", ["DewBank"], ["prop:Beetle"]),
    "word_seed": ("بَذْرَة", ["GiantBloom","AntCity"], ["prop:HeavySeed","prop:SeedSmall","prop:SeedMiddle","prop:SeedLarge"]),
    "word_dewdrop": ("قَطْرَةُ مَاء", ["DewBank"], []),
    "word_tunnel": ("نَفَق", ["AntCity"], ["prop:Tunnel"]),
    "word_rain": ("مَطَر", ["AntCity"], ["decor:Rain"]),
    "word_map_dew_bank": ("ضِفَّةُ النَّدَى", [], []),
    "word_map_ant_city": ("مَدِينَةُ النَّمْل", [], []),
    "word_snow": ("ثَلْج", ["SnowEdge","SnowTracks","SledHill"], []),
    "word_goldfinch": ("حَسُّون", ["SnowEdge"], ["prop:Goldfinch"]),
    "word_deer": ("أَيِّل", ["SledHill"], ["prop:SnowDeer"]),
    "word_board": ("لَوْح", ["SledHill"], ["prop:Sled"]),
    "word_shelter": ("مَأْوَى", ["SnowEdge","SledHill"], ["prop:BirdShelter"]),
    "word_animal_track": ("أَثَرُ قَدَم", ["SnowTracks"], ["prop:RabbitPrint","prop:FoxPrint"]),
    "word_map_snow_tracks": ("آثَارُ الثَّلْج", [], []),
    "word_map_sled_hill": ("تَلُّ اللَّوْحِ الْخَشَبِيّ", [], []),
    "word_coin": ("قِطْعَة نَقْدِيَّة", ["MarketGate","MarketStalls"], ["prop:Coin1","prop:Coin2","prop:Coin3","prop:Coin4","prop:Coin5"]),
    "word_bread": ("خُبْز", ["MarketStalls"], []),
    "word_scale": ("مِيزَان", ["ScaleCourtyard"], []),
    "word_weight": ("ثِقْل", ["ScaleCourtyard"], ["prop:LeftWeight","prop:RightWeight"]),
    "word_dish": ("طَبَق", ["MarketStalls"], []),
    "word_oven": ("فُرْن", ["MarketStalls"], []),
    "word_map_market_stalls": ("دَكَاكِينُ السُّوق", [], []),
    "word_map_scale_courtyard": ("سَاحَةُ الْمِيزَان", [], []),
    "word_crescent": ("هِلَال", ["RamadanLane","HedgehogCourt","IftarShelter"], []),
    "word_date_fruit": ("تَمْرَة", ["HedgehogCourt","IftarShelter"], ["prop:DateA","prop:DateB","prop:DateC", "prop:ServedDates"]),
    "word_drum": ("طَبْل", ["RamadanLane"], []),
    "word_palm": ("نَخْلَة", ["HedgehogCourt"], []),
    "word_traveller": ("مُسَافِر", ["IftarShelter"], ["prop:Traveller"]),
    "word_map_hedgehog_court": ("سَاحَةُ الْقَنَافِذ", [], []),
    "word_map_iftar_shelter": ("مَكَانُ الْإِفْطَار", [], []),
    "word_beach": ("شَاطِئ", ["GullShore"], []),
    "word_sea": ("بَحْر", ["GullShore","TideCave","GullLighthouse"], []),
    "word_turtle": ("سُلَحْفَاة", ["GullShore"], ["prop:Turtle"]),
    "word_octopus": ("أُخْطُبُوط", ["TideCave"], ["prop:Octopus"]),
    "word_gull": ("نَوْرَس", ["GullLighthouse"], ["prop:Gull"]),
    "word_shell": ("صَدَفَة", ["TideCave","GullLighthouse"], []),
    "word_pool": ("بِرْكَة", ["GullShore","TideCave"], []),
    "word_lighthouse": ("مَنَارَة", ["GullLighthouse"], []),
    "word_bottle": ("زُجَاجَة", ["GullShore"], ["prop:Bottle"]),
    "word_paper": ("قِطْعَةُ وَرَق", ["GullShore"], ["prop:Paper"]),
    "word_tin": ("عُلْبَة", ["GullShore"], ["prop:Tin"]),
    "word_map_tide_cave": ("كَهْفُ الْمَدّ", [], []),
    "word_map_gull_lighthouse": ("مَنَارَةُ الْجَزِيرَة", [], []),
    "word_star": ("نَجْم", ["HilltopFestival"], []),
    "word_tent": ("خَيْمَة", ["HilltopFestival", "MarketStalls"], []),
    "word_tail": ("ذَيْل", ["NarrowPass"], ["prop:FoxTail"]),
    "word_waterfall": ("شَلَّال", ["WaterfallPath"], []),
    "word_monkey": ("قِرْد", ["WaterfallPath"], ["prop:Qarqoor"]),
    "word_fruit": ("ثَمَرَة", ["WaterfallPath"], ["prop:Fruit"]),
    "word_map_farm": ("سَاحَةُ الْمَزْرَعَة", [], []),
    "word_map_house": ("بَيْتُ الْجَدّ", [], []),
    "word_map_gate": ("بَوَّابَةُ الْمَزْرَعَة", [], []),
    "word_map_meadow": ("مَرْجُ الْأَزْهَار", [], []),
    "word_map_tree": ("الشَّجَرَةُ الْكَبِيرَة", [], []),
    "word_map_fox": ("صَخْرَةُ ثَعْلُوب", [], []),
    "word_map_stream": ("جَدْوَلُ الْمَاء", [], []),
    "word_map_pine": ("مُفْتَرَقُ الصَّنَوْبَر", [], []),
    "word_map_oak": ("غَابَةُ الْبَلُّوط", [], []),
    "word_map_cave": ("التَّلُّ الصَّخْرِيّ", [], []),
    "word_map_lake": ("بُحَيْرَةُ الْوَادِي", [], []),
    "word_map_orchard": ("بُسْتَانُ الْعَسَل", [], []),
    "word_map_slope": ("الْمُنْحَدَرُ الْأَخْضَر", [], []),
    "word_map_waterfall": ("دَرْبُ الشَّلَّال", [], []),
    "word_map_pass": ("الْمَمَرُّ الضَّيِّق", [], []),
    "word_map_festival": ("مِهْرَجَانُ الْقِمَّة", [], []),
    "word_map_island": ("جَزِيرَةُ الْمَنَارَة", [], []),
    "word_map_mountain": ("جَبَلُ الْمَرْصَد", [], []),
    "word_map_tiny": ("عَالَمُ النَّمْل", [], []),
    "word_map_town": ("بَلْدَةُ السُّوق", [], []),
    "word_map_ramadan": ("لَيْلَةُ رَمَضَان", [], []),
    "word_map_snow": ("يَوْمُ الثَّلْج", [], []),
    "word_peacock": ("طَاوُوس", ["HillSlope"], ["prop:Tawoos"]),
    "word_feather": ("رِيشَة", ["HillSlope"], ["prop:HillFeather"]),
    "word_frame": ("إِطَار", ["HillSlope"], ["prop:Display"]),
    "word_bear": ("دُبّ", ["HoneyOrchard"], ["prop:Dubb"]),
    "word_apple": ("تُفَّاحَة", ["HoneyOrchard"], []),
    "word_frog": ("ضِفْدَع", ["MeadowLake"], ["prop:Dafdoof"]),
    "word_gazelle": ("غَزَال", ["MeadowLake"], ["prop:Ghazlana"]),
    "word_boat": ("قَارِب", ["MeadowLake", "GullShore"], ["prop:WoodenBoat", "prop:ReturnBoat"]),
    "word_dock": ("رَصِيف", ["MeadowLake", "GullShore"], []),
    "word_hoofprint": ("أَثَرُ حَافِر", ["MeadowLake", "SnowTracks"], ["prop:Print1", "prop:Print2", "prop:Print3", "prop:Hoof1", "prop:Hoof2", "prop:Hoof3"]),
    "word_cat": ("قِطَّة", ["RockCave", "MarketStalls"], ["prop:Qatqoota", "prop:MarketCat"]),
    "word_spider": ("عَنْكَبُوت", ["RockCave"], ["prop:Ankoob"]),
    "word_web": ("شَبَكَة", ["RockCave"], []),
    "word_oak": ("بَلُّوط", ["OakForest"], []),
    "word_acorn": ("ثَمْرَةُ بَلُّوط", ["OakForest"], ["prop:Acorn1", "prop:Acorn2", "prop:Acorn3"]),
    "word_squirrel": ("سِنْجَاب", ["OakForest"], ["prop:Sinjoob"]),
    "word_hedgehog": ("قُنْفُذ", ["OakForest", "HedgehogCourt"], ["prop:Qunfood", "prop:Hedgehogs"]),
    "word_leaf": ("وَرَقَة", ["OakForest", "GiantBloom", "DewBank"], ["prop:LeafBridge"]),
    "word_fern": ("سَرَخْس", ["OakForest"], []),
    "word_sun": ("شَمْس", ["Stream", "HoneyOrchard", "HillSlope", "WaterfallPath", "GullShore", "SnowEdge", "SledHill"], []),
    "word_olive": ("زَيْتُون", ["Stream"], []),
    "word_pine": ("صَنَوْبَر", ["PineFork", "SnowEdge", "SnowTracks", "SledHill"], []),
    "word_cone": ("مَخْرُوط", ["PineFork"], []),
    "word_cave": ("كَهْف", ["PineFork", "RockCave", "GullShore"], []),
    "word_lake": ("بُحَيْرَة", ["PineFork", "MeadowLake"], []),
    "word_duck": ("بَطَّة", ["Stream"], ["prop:Ducks"]),
    "word_duckling": ("فَرْخ", ["Stream"], ["decor:Duckling1", "decor:Duckling2", "decor:Duckling3"]),
    "word_rabbit": ("أَرْنَب", ["Stream", "SnowTracks"], ["prop:Arnoob"]),
    "word_log": ("جِذْع", ["Stream"], ["prop:Log"]),
    "word_reed": ("قَصَب", ["Stream", "MeadowLake"], []),
    "word_window":       ("نَافِذَة",  ["GrandpaRoom", "Yard", "RamadanLane", "IftarShelter", "AntCity"], []),
    "word_door":         ("بَاب",      ["GrandpaRoom", "Yard", "RamadanLane", "MarketGate"], []),
    "word_plant":        ("نَبْتَة",   ["GrandpaRoom"], []),
    "word_cushion":      ("وِسَادَة",  ["GrandpaRoom"], []),
    "word_table":        ("طَاوِلَة",  ["GrandpaRoom", "HilltopFestival", "IftarShelter"], ["prop:FoodTable"]),
    "word_jug":          ("إِبْرِيق",  ["GrandpaRoom", "HilltopFestival", "RamadanLane", "IftarShelter"], ["prop:WaterJug"]),
    "word_shelf":        ("رَفّ",      ["GrandpaRoom"], []),
    "word_rug":          ("سَجَّادَة", ["GrandpaRoom", "IftarShelter"], []),
    "word_mirror":       ("مِرْآة",    ["GrandpaRoom", "inventory"], ["prop:Mirror", "item:HandMirror"]),
    "word_basket":       ("سَلَّة",    ["GrandpaRoom", "inventory", "HilltopFestival", "RamadanLane", "MarketStalls"], ["prop:BasketProp", "item:Basket", "prop:BasketA", "prop:BasketB"]),
    "word_girl":         ("بِنْت",     ["GrandpaRoom", "Yard", "Gate", "MeadowFork", "BigTree", "FoxRock", "Stream", "PineFork"], ["character:Reem"]),
    "word_grandfather":  ("جَدّ",      ["Yard"], ["character:Jad"]),
    "word_well":         ("بِئْر",     ["Yard"], []),
    "word_bucket":       ("دَلْو",     ["Yard"], []),
    "word_jar":          ("جَرَّة",    ["Yard", "HoneyOrchard", "MarketGate"], ["prop:DubbJar"]),
    "word_beehive":      ("خَلِيَّة",  ["Yard", "BigTree"], []),
    "word_tree":         ("شَجَرَة",   ["Yard", "Gate", "MeadowFork", "BigTree", "FoxRock", "Stream", "PineFork", "MeadowLake", "HoneyOrchard", "WaterfallPath", "SnowEdge", "SnowTracks", "SledHill"], []),
    "word_sky":          ("سَمَاء",    ["Yard", "Gate", "MeadowFork", "BigTree", "FoxRock", "Stream", "PineFork", "MeadowLake"], []),
    "word_bird":         ("عُصْفُور",  ["Yard", "Gate", "MeadowFork", "BigTree", "FoxRock", "Stream", "PineFork"], []),
    "word_path":         ("طَرِيق",    ["Yard", "Gate", "MeadowFork", "BigTree", "FoxRock", "Stream", "PineFork", "MeadowLake", "HillSlope", "WaterfallPath", "NarrowPass", "HilltopFestival", "GullShore", "TideCave", "GullLighthouse", "RamadanLane", "HedgehogCourt", "IftarShelter", "MarketGate", "MarketStalls", "ScaleCourtyard", "SnowEdge", "SnowTracks", "SledHill", "GiantBloom", "DewBank", "AntCity"], []),
    "word_flower":       ("زَهْرَة",   ["Yard", "Gate", "MeadowFork", "BigTree", "FoxRock", "Stream", "PineFork", "MeadowLake", "HillSlope", "HilltopFestival", "GullShore", "RamadanLane", "HedgehogCourt", "IftarShelter", "GiantBloom", "DewBank"], ["prop:FlowersFork", "prop:FlowersShade", "prop:GiantFlower"]),
    "word_grass":        ("عُشْب",     ["Yard", "MeadowFork", "BigTree", "FoxRock", "Stream", "PineFork"], []),
    "word_gate":         ("بَوَّابَة", ["Gate"], []),
    "word_fence":        ("سِيَاج",    ["Gate"], []),
    "word_sign":         ("لَافِتَة",  ["Gate", "MeadowFork", "PineFork"], ["prop:Sign"]),
    "word_cloud":        ("غَيْمَة",   ["Gate", "Stream", "PineFork", "HillSlope", "NarrowPass"], []),
    "word_hill":         ("تَلّ",      ["Gate", "MeadowFork", "FoxRock", "Stream", "PineFork", "HillSlope"], []),
    "word_rock":         ("صَخْرَة",   ["MeadowFork", "BigTree", "FoxRock", "Stream", "PineFork", "RockCave", "MeadowLake", "WaterfallPath", "NarrowPass", "GullShore", "TideCave", "GullLighthouse", "SnowEdge", "SledHill", "GiantBloom", "DewBank"], []),
    "word_shade":        ("ظِلّ",      ["BigTree"], []),
    "word_berries":      ("تُوت",      ["FoxRock"], []),
    "word_stream":       ("جَدْوَل",   ["FoxRock", "Stream", "HoneyOrchard"], []),
    "word_fox":          ("ثَعْلَب",   ["FoxRock", "Stream", "PineFork", "NarrowPass", "GullLighthouse", "IftarShelter", "ScaleCourtyard", "SnowTracks", "DewBank"], ["character:Thaaloob", "prop:StreamFox", "prop:Thaaloob", "prop:IslandFox", "prop:RamadanFox", "prop:MarketFox", "prop:SnowFox", "prop:TinyFox"]),
    "word_bee":          ("نَحْلَة",   ["BigTree"], ["character:Shahd", "decor:BeeSmall1", "decor:BeeSmall2"]),
    "word_lantern":      ("فَانُوس",   ["inventory", "HoneyOrchard", "HilltopFestival", "GullLighthouse", "Yard", "RamadanLane", "HedgehogCourt", "IftarShelter", "AntCity"], ["item:Lantern", "prop:LostLanterns", "prop:BigLantern", "prop:Lamp", "prop:LanternToggle", "prop:RamadanEntry"]),
    "word_notebook":     ("دَفْتَر",   ["inventory"], ["item:Notebook"]),
    "word_watering_can": ("مِرَشَّة",  ["inventory"], ["item:WateringCan"]),
    "word_honey":        ("عَسَل",     ["inventory"], ["item:HoneyJar"]),
    "word_stone":        ("حَجَر",     ["inventory", "NarrowPass"], ["item:Stone", "prop:LooseStone"]),
}

TONE = "clear and cheerful, saying one word to teach a child"

data = {}
for wid, (text, rooms, objects) in WORDS.items():
    data[wid] = {
        "text": text,
        "rooms": rooms,
        "audio": f"res://assets/audio/words/{wid}.mp3",
        "objects": objects,
    }
with open("game_data/words.json", "w", encoding="utf-8", newline="\n") as f:
    json.dump(data, f, ensure_ascii=False, indent=2)
    f.write("\n")

QUEUE = "content/word_queue.md"
QUEUE_HEADER = [
    "# word_queue.md – object names to record",
    "",
    "Voice studio (Codex or Claude Desktop + ElevenLabs): record every row with Status `todo`, with the",
    "saved voice in the Voice column and the model/settings policy in AGENTS.md. Use the Text exactly as",
    "written (keep the diacritics); the Tone column is direction only. Save each as",
    "`assets/audio/words/<File>.mp3`, then set Status to `done` (or `problem: <short reason>`).",
    "Never delete rows. New rows are added by `python tools/make_words.py` (see docs/PIPELINE.md).",
    "",
    "| File | Voice | Tone | Text | Status |",
    "| --- | --- | --- | --- | --- |",
]

if os.path.exists(QUEUE):
    with open(QUEUE, encoding="utf-8") as f:
        queue = f.read().rstrip("\n").split("\n")
else:
    queue = list(QUEUE_HEADER)
in_queue = {row.split("|")[1].strip() for row in queue if row.startswith("| word_")}
added = 0
for wid, (text, _, _) in WORDS.items():
    if wid not in in_queue:
        status = "done" if os.path.exists(f"assets/audio/words/{wid}.mp3") else "todo"
        queue.append(f"| {wid} | Reem | {TONE} | {text} | {status} |")
        added += 1
with open(QUEUE, "w", encoding="utf-8", newline="\n") as f:
    f.write("\n".join(queue) + "\n")
print(len(WORDS), "words;", added, "added to", QUEUE)
