"""Read-only pipeline consistency check. Run from the project folder with Python."""
import ast
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def read_json(path):
    return json.loads((ROOT / path).read_text(encoding="utf-8"))


def queue_rows(path, columns):
    rows = {}
    for line in (ROOT / path).read_text(encoding="utf-8").splitlines():
        if not line.startswith("| "):
            continue
        cells = [cell.strip() for cell in line.strip("|").split("|")]
        if len(cells) == columns and cells[0] not in ["File", "ID", "---"]:
            assert cells[0] not in rows, f"Duplicate queue ID: {cells[0]}"
            rows[cells[0]] = cells
    return rows


def main():
    lines = read_json("game_data/lines.json")
    words = read_json("game_data/words.json")
    # Check the generator's literal table without executing it or changing any files.
    tree = ast.parse((ROOT / "tools/make_words.py").read_text(encoding="utf-8"))
    table = next(ast.literal_eval(node.value) for node in tree.body
                 if isinstance(node, ast.Assign)
                 and any(isinstance(t, ast.Name) and t.id == "WORDS" for t in node.targets))
    expected = {key: dict(text=text, rooms=rooms,
                         audio=f"res://assets/audio/words/{key}.mp3", objects=objects)
                for key, (text, rooms, objects) in table.items()}
    assert words == expected, "words.json differs from make_words.py; rerun the generator"
    assert len({word["text"] for word in words.values()}) == len(words), "Duplicate vocabulary"
    for path, data in [("content/voice_queue.md", lines), ("content/word_queue.md", words)]:
        rows = queue_rows(path, 5)
        for key, entry in data.items():
            # The inherited queue documents the 68 recorded MVP lines as a group.
            if key not in rows and path == "content/voice_queue.md":
                assert (ROOT / entry["audio"].removeprefix("res://")).is_file(), f"Missing queue row/audio: {key}"
                continue
            assert key in rows, f"Missing queue row: {key}"
            row = rows[key]
            assert row[3] == entry["text"], f"Queue/data Arabic mismatch: {key}"
            assert row[4] in ["todo", "done"] or row[4].startswith("problem:"), key
            if row[4] == "done":
                assert (ROOT / entry["audio"].removeprefix("res://")).is_file(), key
    for key, entry in lines.items():
        assert entry["speaker"] in ["Reem", "Jad", "Thaaloob", "Shahd"], key
        assert not re.search(r"\[[A-Za-z ]+\]", entry["text"]), f"Synthesis tag in displayed text: {key}"
    for room, areas in read_json("game_data/word_areas.json").items():
        if room.startswith("_"):
            continue
        for area in areas:
            assert area["word"] in words, (room, area)
            assert room in words[area["word"]]["rooms"], (room, area["word"])
            assert len(area["polygon"]) >= 3, (room, area)
            assert all(len(p) == 2 and all(0 <= v <= 1 for v in p)
                       for p in area["polygon"]), (room, area)
    for key, row in queue_rows("content/art_queue.md", 8).items():
        if row[7] == "done":
            for cell in [row[1], row[2]]:
                for path in re.findall(r"`([^`]+)`", cell):
                    assert (ROOT / path).is_file(), (key, path)
    book = read_json("game_data/notebook.json")
    for context, ids in book["hints"].items():
        assert len(ids) == 3 and all(key in lines for key in ids), context
    for card in book["cards"]:
        assert card["name_line"] in lines and card["fact_line"] in lines, card["id"]
        assert (ROOT / card["image"].removeprefix("res://")).is_file(), card["id"]
    print(f"[CONTENT] ok: {len(lines)} lines, {len(words)} words, queues, areas, art and notebook")


if __name__ == "__main__":
    main()
