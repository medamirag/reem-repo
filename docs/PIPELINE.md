# PIPELINE.md – how new content is made, and who does what

Three tools take turns in the same local folder (`C:\Users\ACER\Desktop\Games\reem-game`). Claude Code and Codex are both **builders**, with the same role and the same rules; Codex is also the only one that can generate images. Claude Desktop is the **voice studio**, the only one that generates voices. The local folder is the source of truth and GitHub is only a backup: do not pull between turns; commit at the end of every session, then push.

Whoever is working **continues exactly where the other stopped**, using the Handoff section at the top of `PROGRESS.md`.

## The three queues

All in `content/`. Each is a table with a **Status** column: `todo`, `done`, or `problem: <short reason>`. Never delete rows; change their status.

| Queue | What it holds | Same format as |
| --- | --- | --- |
| `content/art_queue.md` | Every image the game still needs | the MVP `assets.md`: ID, Save as, Attach (reference images), Background (transparent/opaque), Size, Prompt, Extra check, Status |
| `content/voice_queue.md` | Every dialogue line still to record | the MVP `voices.md`: File, Voice, Tone, Text, Status. Audio goes to `assets/audio/lines/<File>.mp3` |
| `content/word_queue.md` | Every object name still to record | same as the voice queue. Audio goes to `assets/audio/words/<File>.mp3` |

New voices for new characters go in a "Voices" table at the top of `voice_queue.md` (name, Voice Design description, Arabic preview text, Status).

## Roles

### Claude Code and Codex (the builders)

Both do exactly the same work, with the same rules (`AGENTS.md`). At the start of a session, read the Handoff in `PROGRESS.md` and continue from the exact point where the last builder stopped, whoever it was; finish a half-done step before starting a new one.

1. **Writes each new station before anything is drawn:** a section in `game_spec.md` (screens, props, choices, flags, line IDs), in the same detail as the MVP rooms, following the station table in `docs/ROADMAP.md`.
2. **Fills the queues for that station:** its images in `art_queue.md` (full prompts with the STYLE block and character descriptions, and the right reference images to attach for consistency), its lines in `voice_queue.md`, and its new lines in `game_data/lines.json`.
3. **After the images exist** (status `done`): looks at each new background and character, identifies the objects a child would recognise, adds them to `game_data/words.json`, `game_data/word_areas.json` and `content/word_queue.md` (status `todo`). Never add a word already in `words.json`.
4. **Builds the station in Godot** using whatever art and audio exist. If audio is missing, the game shows the text without sound; if an image is missing, it uses a clearly marked placeholder. It never waits for images or voices.
5. Moves on to the next step in the roadmap.

### Image generation (Codex only)

Claude Code cannot generate images: it only writes the rows in `content/art_queue.md`. When Codex is working, it also generates every row with status `todo`:

1. In order, exactly as described (prompt as written, references attached, transparency rules), saved at its "Save as" path.
2. After each image: the same checks as the MVP (no text, no border, character matches references, faces right, correct number of limbs, separate pieces with gaps, real transparency). Regenerate once if it fails; then mark `done` or `problem: <reason>`.
3. Commits after every few images, and when stopping (then pushes as a backup).

Codex chooses when to generate images and when to build, so that neither waits too long; it notes in the Handoff which it did.

### Claude Desktop with ElevenLabs (the voice studio, voices only)

Only Claude Desktop generates voices; the builders only write the rows.

1. Designs any voice in the "Voices" table with status `todo`, saves it in ElevenLabs under that name, marks it `done`.
2. Generates every row with status `todo` in `content/voice_queue.md` and `content/word_queue.md`, with the right saved voice and a model that supports Arabic, Text exactly as written, Tone as direction only. Saves to the right folder and name, marks `done`.
3. It cannot use git: when it finishes, the user commits and pushes the new audio.

## Rules for everyone

- **No pulling between turns; commit at the end, then push as a backup.** Update the Handoff section of PROGRESS.md at the end of every session: who, what was done, what is next, and exactly where a half-finished step stopped, so the next tool can continue it.
- **Only one tool works at a time.**
- **Originals are never edited.** New files are added; generated files are named exactly as in the queues.
- **Style consistency:** new characters get a turnaround sheet first, used as the reference for all their later images; new backgrounds attach `assets/art/backgrounds/bg1_room.png` (or the station's first background) as a style reference.
- **Don't ask the user during building:** choose the most reasonable option, note it in PROGRESS.md under "Decisions to review", and continue. Bug fixing and polishing happen at the end.
