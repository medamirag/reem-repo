# art_queue.md – images the game still needs

Artist (Codex), see docs/PIPELINE.md: generate every row with Status `todo`, in order, exactly as described in its section below. Use the Prompt exactly as written, attach the reference images listed under "Attach" (paths in this project), and follow the Background rule (transparent or opaque). Save at the "Save as" path.

After each image, check: no text or letters, no border or frame, the character matches its references, characters face right, correct number of arms and legs, separate pieces have clear gaps between them, and a transparent background is really transparent. Also check the row's "Extra check". Regenerate once if a check fails; then set Status to `done` or `problem: <short reason>`. Never delete rows.

Style rules: every new character gets a turnaround sheet first, and that sheet is attached to all its later images. Every new background attaches `assets/art/backgrounds/bg1_room.png` (or the station's first background) as a style reference. Every prompt starts with the STYLE block from the MVP (copied into each section, so each prompt can be used on its own).

Originals in `assets/` are never edited: new images are new files with the names below.

| ID | Save as | Attach | Background | Size | Prompt | Extra check | Status |
| --- | --- | --- | --- | --- | --- | --- | --- |

<!-- One section per row, in the same order:

## <ID>

- **Save as:** `assets/art/...`
- **Attach:** `assets/art/...` (or none)
- **Background:** opaque | transparent
- **Size:** 1536x1024
- **Extra check:** ...

**Prompt:**

```text
STYLE: ...
```
-->
