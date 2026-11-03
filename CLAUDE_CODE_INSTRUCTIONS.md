# Claude Code instructions – building ReemGame in Godot

These steps let Claude Code build the first playable version of the game in your `ReemGame` folder, room by room. You test each room, and Claude Code continues.

---

## 1. Install Claude Code (once)

Use **PowerShell**, not the black Command Prompt (CMD): these commands only work in PowerShell. Press the Windows key, type PowerShell, and open it.

1. Install **Git for Windows** first. Claude Code needs it to run commands, and it also lets it save a safe point after each room:

```
winget install Git.Git
```

2. Install Claude Code:

```
irm https://claude.ai/install.ps1 | iex
```

3. Close PowerShell and open it again. Check both work:

```
git --version
claude --version
```

If `winget` is not recognized, download Git from git-scm.com instead and keep the default options. Installation details change often: if a step fails, check Anthropic's official Claude Code page.

## 2. Put the package files in the project

Copy these files into `C:\Users\ACER\Desktop\ReemGame\` (next to the `addons` and `assets` folders):

```
ReemGame\
├── CLAUDE.md
├── game_spec.md
├── game_data\
│   └── lines.json
├── addons\        (Popochiu, already there)
└── assets\        (your art, audio and font, already there)
```

## 3. Tell Claude Code where Godot is

1. Find the Godot program you use (for example `C:\Godot\Godot_v4.7.2-stable_win64.exe`). Right-click it → **Copy as path**.
2. Open `CLAUDE.md` in Notepad. Replace **both** `GODOT_EXE_PATH_HERE` with that path, without the quotes, and save.

## 4. Start Claude Code in the project

In PowerShell:

```
cd C:\Users\ACER\Desktop\ReemGame
claude
```

The first time, it asks you to sign in: choose your **Claude Pro** account. When it asks for permission to read and edit files or run commands in this folder, allow it.

**Close Godot before Claude Code edits the project, and reopen it to test.** Godot open at the same time can overwrite Claude Code's changes.

---

## 5. Step one: the Arabic test

Paste:

```
Read CLAUDE.md, game_spec.md and game_data/lines.json. Then do only the first task from CLAUDE.md: prove that Arabic text displays correctly in Popochiu's dialogue text and in a choice button, using the font in assets/fonts. Make a minimal test room with bg1_room as the background and Reem standing in it, and have her say reem_s1_002 with its audio when the room starts, then show a two-button choice. Run the headless check, then stop and tell me exactly how to test it.
```

Open Godot, press **F5**, and check:
1. The Arabic text is **connected and right to left**, in the dialogue and on the buttons.
2. You hear Reem's voice.
3. Reem walks when you click the floor.

Tell Claude Code what you saw. If the text is wrong, send it a screenshot.

## 6. Build the game, room by room

When the test is good, paste:

```
The Arabic test works. Now build the game following game_spec.md, one room at a time and in order: first section 2 (cutting the sheets into pieces), then section 4 (global systems), then the title screen and the rooms. After each room, run the checks, update PROGRESS.md, and stop to tell me how to test it.
```

After each room, test it in Godot (F5) using the checklist in section 6 of `game_spec.md`, then reply, for example:

```
GrandpaRoom works. Two changes: the mirror is too small, make it about 20% bigger, and Reem is a bit too big compared to the table. Then continue with the Yard.
```

## 7. In a new session

If you close Claude Code or hit a usage limit, start it again in the folder and paste:

```
Read CLAUDE.md and PROGRESS.md, and continue from where we stopped.
```

---

## Tips

- **Describe what you see, simply:** "The basket is floating above the floor", "The voice cuts off before the text ends". Screenshots help a lot: you can paste an image directly into Claude Code.
- **One change at a time:** if several things are wrong, list them all in one message, but test after each room before moving on.
- **Positions and sizes:** you can also adjust them yourself in Godot. Select the object in the scene, then drag it, or change Position and Scale in the Inspector on the right.
- **Back up:** before a big step, copy the whole `ReemGame` folder somewhere safe, or ask Claude Code to make a git commit.

## Troubleshooting

| Problem | Fix |
|---|---|
| `irm` is not recognized | You are in CMD: open PowerShell instead |
| `claude` is not recognized | Close and reopen PowerShell. If it still fails, run the install command again |
| Claude Code says the Godot path is a placeholder | Edit `CLAUDE.md` as in step 3 |
| Arabic shows as boxes | The font is missing or not set: check that the `.ttf` file is in `assets\fonts\`, and tell Claude Code |
| Arabic letters are separate or in the wrong order | Tell Claude Code: "the Arabic is not shaped correctly in the dialogue text", with a screenshot |
| Red errors in Godot's Output panel | Copy the red lines and paste them into Claude Code |
| Changes disappear after opening Godot | Godot was open while Claude Code edited. Close Godot, ask Claude Code to check its changes are still there, then reopen Godot |
| Usage limit reached | Wait for the reset, then use the "new session" message in step 7 |
