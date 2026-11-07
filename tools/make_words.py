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
    "word_cat": ("قِطَّة", ["RockCave"], ["prop:Qatqoota"]),
    "word_spider": ("عَنْكَبُوت", ["RockCave"], ["prop:Ankoob"]),
    "word_web": ("شَبَكَة", ["RockCave"], []),
    "word_oak": ("بَلُّوط", ["OakForest"], []),
    "word_acorn": ("ثَمْرَةُ بَلُّوط", ["OakForest"], ["prop:Acorn1", "prop:Acorn2", "prop:Acorn3"]),
    "word_squirrel": ("سِنْجَاب", ["OakForest"], ["prop:Sinjoob"]),
    "word_hedgehog": ("قُنْفُذ", ["OakForest"], ["prop:Qunfood"]),
    "word_leaf": ("وَرَقَة", ["OakForest"], []),
    "word_fern": ("سَرَخْس", ["OakForest"], []),
    "word_sun": ("شَمْس", ["Stream"], []),
    "word_olive": ("زَيْتُون", ["Stream"], []),
    "word_pine": ("صَنَوْبَر", ["PineFork"], []),
    "word_cone": ("مَخْرُوط", ["PineFork"], []),
    "word_cave": ("كَهْف", ["PineFork", "RockCave"], []),
    "word_lake": ("بُحَيْرَة", ["PineFork"], []),
    "word_duck": ("بَطَّة", ["Stream"], ["prop:Ducks"]),
    "word_duckling": ("فَرْخ", ["Stream"], ["decor:Duckling1", "decor:Duckling2", "decor:Duckling3"]),
    "word_rabbit": ("أَرْنَب", ["Stream"], ["prop:Arnoob"]),
    "word_log": ("جِذْع", ["Stream"], ["prop:Log"]),
    "word_reed": ("قَصَب", ["Stream"], []),
    "word_window":       ("نَافِذَة",  ["GrandpaRoom", "Yard"], []),
    "word_door":         ("بَاب",      ["GrandpaRoom", "Yard"], []),
    "word_plant":        ("نَبْتَة",   ["GrandpaRoom"], []),
    "word_cushion":      ("وِسَادَة",  ["GrandpaRoom"], []),
    "word_table":        ("طَاوِلَة",  ["GrandpaRoom"], []),
    "word_jug":          ("إِبْرِيق",  ["GrandpaRoom"], []),
    "word_shelf":        ("رَفّ",      ["GrandpaRoom"], []),
    "word_rug":          ("سَجَّادَة", ["GrandpaRoom"], []),
    "word_mirror":       ("مِرْآة",    ["GrandpaRoom", "inventory"], ["prop:Mirror", "item:HandMirror"]),
    "word_basket":       ("سَلَّة",    ["GrandpaRoom", "inventory"], ["prop:BasketProp", "item:Basket"]),
    "word_girl":         ("بِنْت",     ["GrandpaRoom", "Yard", "Gate", "MeadowFork", "BigTree", "FoxRock", "Stream", "PineFork"], ["character:Reem"]),
    "word_grandfather":  ("جَدّ",      ["Yard"], ["character:Jad"]),
    "word_well":         ("بِئْر",     ["Yard"], []),
    "word_bucket":       ("دَلْو",     ["Yard"], []),
    "word_jar":          ("جَرَّة",    ["Yard"], []),
    "word_beehive":      ("خَلِيَّة",  ["Yard", "BigTree"], []),
    "word_tree":         ("شَجَرَة",   ["Yard", "Gate", "MeadowFork", "BigTree", "FoxRock", "Stream", "PineFork"], []),
    "word_sky":          ("سَمَاء",    ["Yard", "Gate", "MeadowFork", "BigTree", "FoxRock", "Stream", "PineFork"], []),
    "word_bird":         ("عُصْفُور",  ["Yard", "Gate", "MeadowFork", "BigTree", "FoxRock", "Stream", "PineFork"], []),
    "word_path":         ("طَرِيق",    ["Yard", "Gate", "MeadowFork", "BigTree", "FoxRock", "Stream", "PineFork"], []),
    "word_flower":       ("زَهْرَة",   ["Yard", "Gate", "MeadowFork", "BigTree", "FoxRock", "Stream", "PineFork"], ["prop:FlowersFork", "prop:FlowersShade"]),
    "word_grass":        ("عُشْب",     ["Yard", "MeadowFork", "BigTree", "FoxRock", "Stream", "PineFork"], []),
    "word_gate":         ("بَوَّابَة", ["Gate"], []),
    "word_fence":        ("سِيَاج",    ["Gate"], []),
    "word_sign":         ("لَافِتَة",  ["Gate", "MeadowFork", "PineFork"], ["prop:Sign"]),
    "word_cloud":        ("غَيْمَة",   ["Gate", "Stream", "PineFork"], []),
    "word_hill":         ("تَلّ",      ["Gate", "MeadowFork", "FoxRock", "Stream", "PineFork"], []),
    "word_rock":         ("صَخْرَة",   ["MeadowFork", "BigTree", "FoxRock", "Stream", "PineFork", "RockCave"], []),
    "word_shade":        ("ظِلّ",      ["BigTree"], []),
    "word_berries":      ("تُوت",      ["FoxRock"], []),
    "word_stream":       ("جَدْوَل",   ["FoxRock", "Stream"], []),
    "word_fox":          ("ثَعْلَب",   ["FoxRock", "Stream", "PineFork"], ["character:Thaaloob", "prop:StreamFox"]),
    "word_bee":          ("نَحْلَة",   ["BigTree"], ["character:Shahd", "decor:BeeSmall1", "decor:BeeSmall2"]),
    "word_lantern":      ("فَانُوس",   ["inventory"], ["item:Lantern"]),
    "word_notebook":     ("دَفْتَر",   ["inventory"], ["item:Notebook"]),
    "word_watering_can": ("مِرَشَّة",  ["inventory"], ["item:WateringCan"]),
    "word_honey":        ("عَسَل",     ["inventory"], ["item:HoneyJar"]),
    "word_stone":        ("حَجَر",     ["inventory"], ["item:Stone"]),
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
