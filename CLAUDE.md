# CLAUDE.md – ReemGame

You are building the MVP of a 2D point-and-click adventure game for Muslim Arab children, in Godot with the Popochiu plugin. The user is a beginner in Godot: explain what you did in plain words, and tell them exactly what to click when they need to check something.

## Sources of truth

* `game\\\_spec.md`: what to build, room by room. Follow it exactly. If something in it is impossible or unclear, ask instead of inventing.
* `game\\\_data/lines.json`: every dialogue line (Arabic text + audio path), keyed by line ID. Never retype or change the Arabic text.
* `res://assets/`: the original art, audio and fonts. **Read-only: never edit, move, rename or delete anything in it.** Put cut pieces and anything generated in `res://assets/cut/` or under `res://game/`.

## Environment

* Windows. Godot 4.7.2, Compatibility renderer, project at `C:\\\\Users\\\\ACER\\\\Desktop\\\\ReemGame`.
* Godot executable: `C:\\\\Users\\\\ACER\\\\Desktop\\\\Godot` (the user fills this in; ask if it is still a placeholder).
* Popochiu 2.0.3 in `res://addons/popochiu/`. **Before writing Popochiu code, read its source and its example templates in `res://addons/popochiu/` to confirm class names, method names and signals. Do not guess the API.** Popochiu was not officially tested on Godot 4.7: if something in it breaks, say so plainly and propose the smallest fix.
* Godot scene (`.tscn`) and resource (`.tres`) files are text, but prefer creating Popochiu rooms, characters, props, hotspots and inventory items the way Popochiu expects (its own templates and folder layout under `res://game/`). If you must write `.tscn` files by hand, keep them minimal and valid.

## Working rules

1. **One room at a time**, in the order of `game\\\_spec.md`. After finishing a room, run the project's checks, then **stop and ask the user to test it** with clear steps (which key to press, what they should see and hear). Do not start the next room until they confirm.
2. **Check your work:** after changes, run Godot headless to catch script and scene errors, for example:
`"GODOT\\\_EXE\\\_PATH\\\_HERE" --headless --path . --quit-after 120`
and read the output. Fix every error you caused before reporting.
3. **Arabic first:** the very first task is to prove that Arabic text displays correctly (connected letters, right to left) in Popochiu's dialogue text and in a choice button, with the font in `res://assets/fonts/`. Nothing else is built until the user confirms they see it correctly.
4. **Small, safe steps:** if the folder is a git repository, commit after each finished room with a clear message. If it is not, suggest once that the user installs Git so changes can be undone.
5. **Keep a progress file** `PROGRESS.md`: what is done, what the user confirmed, what is next, and any known problems. Update it at the end of every session, and read it at the start of every session.
6. **Ask, don't assume,** about anything visual you cannot see: positions and sizes are starting points from the spec, and the user adjusts them. Make positions easy to change (exported variables or clearly named nodes).
7. **Child-friendly behavior:** no game over, no timers, no scary effects. Every click does something or nothing; it never breaks the game.
8. If you hit a usage limit, write in `PROGRESS.md` exactly where you stopped.

