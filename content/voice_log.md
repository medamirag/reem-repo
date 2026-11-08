# voice_log.md – what each recording batch used

One section per batch, newest last: voices, model, tags, reference files, fallback, and what is
still open. The rules and the saved-voice registry stay in AGENTS.md ("Saved voices and
consistent recordings"). Moved here verbatim from AGENTS.md on 2026-11-08.

### Approved Reem sample and November 7 batch

- User approved the Stream sample. The same take is installed at `res://assets/audio/lines/reem_stream_arrive.mp3`. Reference was `res://assets/audio/lines/reem_s1_002.mp3`.
- Saved Reem and Thaaloob voices recorded dialogue with `eleven_v3` and synthesis-only tags `[warmly]` and `[playful]` respectively. Reem recorded vocabulary with `eleven_multilingual_v2` without tags. No model fallback was needed.
- The connected generation call exposes no numeric controls. Stability, similarity, style, speed and speaker boost values were neither sent nor verified. Historical Thaaloob stability 0.3 is not an offered value in the connected v3 schema. No numeric substitution was made.
- Sample approval covered Reem's Stream take. The full set and Thaaloob's new takes were checked for file delivery and import, with listening review still open.

### Valley map and Waterfall Path batch

- Map introduction used saved Jad with `eleven_v3` and the synthesis-only tag `[warmly]`. Existing reference is `res://assets/audio/lines/jad_s1_015.mp3`.
- Waterfall dialogue used saved Reem with `eleven_v3` and synthesis-only tags `[warmly]`, `[gently]`, `[playful]` and `[surprised]`. Reem's reference remains `res://assets/audio/lines/reem_s1_002.mp3`. Map names and Waterfall words used saved Reem with `eleven_multilingual_v2` and no tags.
- No model fallback. The connected tool exposed no stability, similarity boost, style, speed or speaker boost controls. The delivered files were checked against the queues. Listening comparison for pace, pronunciation and loudness remains open.

### Narrow Pass batch

- Reem and Thaaloob recorded their own lines with the saved voices and `eleven_v3`. Reem used `[warmly]` and `[gently]`, and Thaaloob used `[worried]`, `[embarrassed]` and `[gently]`. Reference lines are `res://assets/audio/lines/reem_s1_002.mp3` and `res://assets/audio/lines/fox_cave_praise.mp3`.
- Reem recorded the tail word with `eleven_multilingual_v2` and no tags. No model fallback. Numeric controls remain unsupported in this tool. Listening comparison remains open.

### Hilltop Festival batch

- Reem and Jad used their saved voices with `eleven_v3` and synthesis-only tags `[warmly]`, `[gently]` or `[playful]`, as appropriate. Reference files are `res://assets/audio/lines/reem_s1_002.mp3` and `res://assets/audio/lines/jad_s1_015.mp3`. Reem recorded the two words with `eleven_multilingual_v2` and no tags.
- No model fallback or numeric settings were used. Listening comparison remains open.

### Gull Island batch

- Reem narrates the turtle, octopus and gull. Reem dialogue uses the saved Reem voice and `eleven_v3` with `[warmly]` and `[gently]`. Thaaloob's line uses the saved Thaaloob voice and `[playful]` on `eleven_v3`. Existing references remain `res://assets/audio/lines/reem_s1_002.mp3` and `res://assets/audio/lines/fox_cave_praise.mp3`.
- Reem recorded the vocabulary with `eleven_multilingual_v2` and no tags. No fallback or numeric settings were used. Listening comparison remains open.

### Ramadan Lantern Night batch

- Reem narrates the musaharati, hedgehog family and traveller. Reem used the saved voice with `eleven_v3` and `[warmly]` or `[gently]`. Thaaloob used his saved voice with `eleven_v3` and `[playful]`. Reem recorded the words in `eleven_multilingual_v2` without tags.
- No fallback or numeric settings were used. The existing reference files are `res://assets/audio/lines/reem_s1_002.mp3` and `res://assets/audio/lines/fox_cave_praise.mp3`. Listening comparison remains open.

### Old City Market batch

- Reem narrates the merchant, baker and market cat using her saved voice on `eleven_v3` with `[warmly]` or `[gently]`. Thaaloob used his saved voice on `eleven_v3` with `[playful]` and `[embarrassed]`. Reem used `eleven_multilingual_v2` with no tags for words.
- No model fallback or numeric controls were used. Reference files remain `res://assets/audio/lines/reem_s1_002.mp3` and `res://assets/audio/lines/fox_cave_praise.mp3`. Listening comparison remains open.

### Snow Trail batch

- Reem narrates the goldfinch, Arnoob and deer. Her saved voice used `eleven_v3` with `[warmly]` and `[gently]`. Thaaloob's saved voice used `eleven_v3` with `[playful]`. Reem recorded words with `eleven_multilingual_v2` and no tags.
- No model fallback or numeric settings were used. References are `res://assets/audio/lines/reem_s1_002.mp3` and `res://assets/audio/lines/fox_cave_praise.mp3`. Listening comparison remains open.

### Ant Kingdom batch

- Reem narrates the worker, beetle and queen. Her saved voice used `eleven_v3` with `[warmly]` and `[gently]`. Thaaloob's saved voice used `eleven_v3` with `[playful]`. Reem recorded words on `eleven_multilingual_v2` with no tags.
- No model fallback or numeric controls were used. References are `res://assets/audio/lines/reem_s1_002.mp3` and `res://assets/audio/lines/fox_cave_praise.mp3`. Listening comparison remains open.

### Diacritised map introduction

- Saved Jad recorded jad_map_intro_vocalised using eleven_v3 and [warmly], without fallback. Numeric settings were unavailable. Reference take is assets/audio/lines/jad_map_intro.mp3. The new file imported and the map playtest passed. Listening comparison remains open.

### Star Observatory audio

- The saved Reem and Thaaloob voices recorded 18 dialogue lines on v3 with warm, gentle or playful synthesis-only tags. The saved Reem voice recorded eight vocabulary files on multilingual v2 without tags. No fallback was used. Numeric controls were unavailable. The existing Reem Stream sample and Thaaloob lines remain the listening references. File delivery was verified and full listening comparison remains open.

- Tree Day used the same saved Reem voice and approved Stream reference. Seven dialogue files used v3 with [warmly]. Two isolated vocabulary files used multilingual v2. No numeric controls or fallback were used. File delivery was checked. Listening comparison remains open.

- Mother Garden used saved Reem with v3 [warmly] for seven dialogue recordings and multilingual v2 for two vocabulary recordings. No fallback or explicit numeric controls were used. File delivery passed; listening comparison remains open.
