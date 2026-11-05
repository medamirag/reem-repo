"""Writes game_data/words.json and words.md (the word-discovery word list) from the table
below. Edit the table and run:  python3 tools/make_words.py   (from the project folder).
game_data/word_areas.json (where each word is in each room) is edited by hand."""
import json

# id: (Arabic word with full diacritics, rooms, objects that are not background areas)
#   objects: "prop:<Name>", "character:<Name>", "decor:<NodeName>" (a node in the room),
#            "item:<InventoryItemName>"
WORDS = {
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
    "word_girl":         ("بِنْت",     ["GrandpaRoom", "Yard", "Gate", "MeadowFork", "BigTree", "FoxRock"], ["character:Reem"]),
    "word_grandfather":  ("جَدّ",      ["Yard"], ["character:Jad"]),
    "word_well":         ("بِئْر",     ["Yard"], []),
    "word_bucket":       ("دَلْو",     ["Yard"], []),
    "word_jar":          ("جَرَّة",    ["Yard"], []),
    "word_beehive":      ("خَلِيَّة",  ["Yard", "BigTree"], []),
    "word_tree":         ("شَجَرَة",   ["Yard", "Gate", "MeadowFork", "BigTree", "FoxRock"], []),
    "word_sky":          ("سَمَاء",    ["Yard", "Gate", "MeadowFork", "BigTree", "FoxRock"], []),
    "word_bird":         ("عُصْفُور",  ["Yard", "Gate", "MeadowFork", "BigTree", "FoxRock"], []),
    "word_path":         ("طَرِيق",    ["Yard", "Gate", "MeadowFork", "BigTree", "FoxRock"], []),
    "word_flower":       ("زَهْرَة",   ["Yard", "Gate", "MeadowFork", "BigTree", "FoxRock"], ["prop:FlowersFork", "prop:FlowersShade"]),
    "word_grass":        ("عُشْب",     ["Yard", "MeadowFork", "BigTree", "FoxRock"], []),
    "word_gate":         ("بَوَّابَة", ["Gate"], []),
    "word_fence":        ("سِيَاج",    ["Gate"], []),
    "word_sign":         ("لَافِتَة",  ["Gate", "MeadowFork"], ["prop:Sign"]),
    "word_cloud":        ("غَيْمَة",   ["Gate"], []),
    "word_hill":         ("تَلّ",      ["Gate", "MeadowFork", "FoxRock"], []),
    "word_rock":         ("صَخْرَة",   ["MeadowFork", "BigTree", "FoxRock"], []),
    "word_shade":        ("ظِلّ",      ["BigTree"], []),
    "word_berries":      ("تُوت",      ["FoxRock"], []),
    "word_stream":       ("جَدْوَل",   ["FoxRock"], []),
    "word_fox":          ("ثَعْلَب",   ["FoxRock"], ["character:Thaaloob"]),
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
with open("game_data/words.json", "w", encoding="utf-8") as f:
    json.dump(data, f, ensure_ascii=False, indent=2)
    f.write("\n")

lines = [
    "# Word discovery: words to record",
    "",
    "Hold on an object in the game for half a second: its Arabic name shows and is spoken.",
    "One audio file per word. Save each as `assets/audio/words/<File>` (mp3).",
    "Generated from tools/make_words.py (do not edit by hand; edit the script and run it).",
    "",
    "| File | Voice | Tone | Text |",
    "| --- | --- | --- | --- |",
]
for wid, (text, _, _) in WORDS.items():
    lines.append(f"| {wid}.mp3 | Reem | {TONE} | {text} |")
with open("words.md", "w", encoding="utf-8") as f:
    f.write("\n".join(lines) + "\n")
print(len(WORDS), "words")
