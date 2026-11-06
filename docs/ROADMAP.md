# ROADMAP.md – Reem and the Festival of Nasim Valley, the full game

The MVP (Grandpa's farm + the flower meadow, 6 screens) is built. This file describes everything after it: the rest of the valley, the game-wide systems, and the six expansion packs. Build in the order of section 5. The style, rules and Arabic conventions in AGENTS.md and game_spec.md apply to everything here.

## 1. Story frame (unchanged)

Grandpa Sulaiman sprained his ankle and cannot light the big lantern at the Festival of Lanterns on the hilltop tonight. Reem carries the small lantern with the festival flame from the farm to the summit before nightfall. On the way she meets animals with problems, makes choices, and learns from her mistakes. The day moves on with each station: morning → noon → afternoon → sunset → night.

**Choice design rules** (for every station): every choice has a kind option and a tempting wrong option. The wrong option has a visible consequence (a branch of the heart tree wilts) and a way to repair it (the branch heals). Never a game over, never shaming: characters stay gentle. The lesson shows in the result, not in a sermon. Dialogue is simple Modern Standard Arabic with Islamic manners (greetings, بسم الله، إن شاء الله، جزاك الله خيراً، الحمد لله). Any Quran or hadith quote must be exact and attributed, and only from Grandpa.

## 2. The valley map (base game)

Paths branch and meet again. One playthrough visits about 7 stations; replaying another path shows new animals. The three **meeting points** are mandatory and carry Thaaloob's story.

```
Farm (MVP) → Flower meadow (MVP) ─┐
           → Stream ──────────────┴→ PINE FORK (meeting 1)
PINE FORK → Oak forest ─┐
          → Rock cave ──┼→ HONEY ORCHARD (meeting 2)
          → Meadow lake ┘
HONEY ORCHARD → Hill slope ──┐
              → Waterfall path ┴→ NARROW PASS (meeting 3) → HILLTOP FESTIVAL (end)
```

Note: the MVP already contains Thaaloob's first meeting (the stone trade at the edge of the flower meadow). The Stream path must also contain a short first meeting with him, so every child meets him before Pine Fork.

| Station | Time | Characters | Situation and choice | Lesson | Gives for the festival |
| --- | --- | --- | --- | --- | --- |
| **Stream** (alternative to the flower meadow) | morning | Duck and ducklings; Arnoob the hasty rabbit; Thaaloob (short first meeting: he offers to "carry" the lantern for her) | The stepping stones moved; Reem rolls a light log to make a bridge. Arnoob rushes off without listening: follow him and get lost, or read Grandpa's notebook map. Lend the lantern to Thaaloob or keep it. | Patience, helping the weak, keeping what is entrusted | A coloured feather |
| **Pine Fork** (meeting 1) | late morning | Thaaloob | He offers a "shortcut" through the cave and says no one will see if she skips helping others. The cave path is allowed, but his promise is a trap. | The easy way has a price | — |
| **Oak forest** | noon | Sinjoob the stingy squirrel; Qunfood the shy hedgehog | Sinjoob forgot where he hid his nuts and won't share; help him find them, then suggest sharing. Everyone avoids Qunfood because of his spines: avoid him too, or get to know him. | Generosity; not judging by looks | Nuts for the festival table; leaves gathered by Qunfood's spines |
| **Rock cave** | noon, dark inside | Qatqoota the kitten afraid of the dark; Ankoob the patient spider; Thaaloob at the exit | Mock the kitten or give her the small lantern's light and walk with her. Ankoob rebuilds his web every time the wind breaks it; a hard puzzle here: give up or try again. At the exit Thaaloob praises Reem's voice so she puts down her basket to sing, then grabs the honey. | Courage in small steps; perseverance; beware excessive flattery | Qatqoota rings the festival bell; Ankoob's threads to hang lanterns |
| **Meadow lake** | afternoon | Dafdoof the singing frog who lost his voice; Ghazlana the little gazelle who wandered off against her mother's advice; the talking wooden boat (stays at the dock) | Share the honey to make warm honey water for the frog, or keep it. Help Ghazlana by following hoof prints back to her mother. The boat introduces itself and says "one day I'll take you to the sea" (entrance to pack 1). | Selflessness; obeying parents' advice | A reed flute from the frog |
| **Honey orchard** (meeting 2) | before sunset | Dubb the little bear with his head stuck in a jar; Thaaloob | Pull hard (he cries) or calm him and put honey round the jar's rim so it slides off. Thaaloob accuses the bear of stealing the festival lanterns: accuse the bear in front of everyone, or look for evidence (the lanterns fell in the stream). | Gentleness, thinking before force; verify before accusing | Dubb helps carry the lanterns |
| **Hill slope** | sunset | Tawoos the proud peacock | He refuses to lend feathers "because he is the most beautiful": flatter him, or show him the beauty of everyone's work together. | Humility | Coloured feathers for the big lantern |
| **Waterfall path** | sunset | Qarqoor the mischievous monkey | He throws fruit at Reem to provoke her: throw back, or stay calm and ask why. He is bored because no one plays with him. | Self-control; understanding others | Qarqoor climbs to hang the high lanterns |
| **Narrow pass** (meeting 3) | dusk | Thaaloob, his tail stuck between two rocks | He asks for help. Reem helps him despite everything. He is ashamed, apologises, returns the honey (if he took it) and asks to come to the festival. | Forgiveness, with wisdom | Thaaloob joins the festival |
| **Hilltop festival** (end) | night | Everyone Reem helped, Grandpa (arrives on the bear's back or the boat, as a surprise) | The friends Reem helped come to help her hang and light everything. Reem lights the big lantern. Grandpa tells everyone what she did, including the mistakes she repaired. | Good returns to those who do it | — |

**Endings:** the festival scene shows only the friends helped on this playthrough, and the final heart tree reflects the choices. A short line from Grandpa invites the child to replay another path ("I heard a hedgehog in the oak forest is lonely…").

## 3. Game-wide systems

1. **Heart tree** (exists): extend to more blossoms over the whole journey; the end screen shows its final state.
2. **Friend cards album:** each animal Reem helps gives a card: its picture, its Arabic name, and one real, simple fact about that species (for example "the hedgehog rolls into a ball to protect itself"). Cards are earned only by playing, never bought. Opened from the notebook.
3. **Word discovery** (in progress): press-and-hold on objects to hear their Arabic name, in every station; a page in the notebook lists the words found.
4. **Valley map and fast travel:** a hand-drawn map page in the notebook showing visited stations; tap a visited station to go there. Used to go back and repair mistakes.
5. **Hints:** the notebook gives a hint for the current station, in up to three steps (a nudge, a clearer hint, the answer).
6. **Hotspot highlight:** a button (or holding two fingers) briefly shows all clickable things.
7. **Save:** autosave on every room change; the title screen offers «متابعة» (continue) and «رحلة جديدة» (new journey).
8. **Settings:** music on/off (off by default: ambience only), voice volume, effects volume, text size.
9. **Parent corner** (later, before store release): behind a parental gate; shows the lessons met in this playthrough and suggested questions to discuss with the child.

## 4. Expansion packs

Each pack is a new area branching from the valley, unlocked after the festival ending. Each has 3 to 4 stations (30 to 45 minutes), one new mechanic, one exciting moment, new animals with cards and words, and a new short Thaaloob story. Build them as normal content now; in-app purchase and parental gate come later.

| Pack | Entrance | Characters | New mechanic | Exciting moment | Lessons |
| --- | --- | --- | --- | --- | --- |
| **1. جزيرة النوارس (Gull island)** | The talking wooden boat returns and carries Reem across the lake to the sea | An old sea turtle, a shy octopus that changes colour, a greedy gull | **Tides:** low tide reveals paths and caves, high tide covers them | A small storm cuts the way back; Reem finds her way by the light of a lighthouse she repaired herself | Protecting the sea; contentment |
| **2. سوق المدينة القديمة (Old city market)** | A road from the farm to the city to sell the honey | Merchants, an old baker, the market cat, Thaaloob disguised as a merchant | **Trading and counting:** buying and selling with simple coins, light arithmetic | Thaaloob cheats with the scales; Reem exposes him with an experiment in front of everyone | Honesty in trade; respecting elders |
| **3. ليلة الفوانيس الرمضانية (Ramadan lantern night)** | The valley itself on Ramadan nights | The musaharati, the hedgehog family, a stranger traveller | **The lantern lights the way:** what is seen in darkness differs from what is seen in light | Preparing a surprise iftar for the stranger minutes before the Maghrib call to prayer | Charity, patience, family ties |
| **4. درب الثلج (Snow trail)** | The valley in winter, old paths under snow | A cold goldfinch, a young deer, Arnoob with his white fur | **Footprints in the snow:** follow tracks to learn who passed and where they went | A fast sled ride down the hill on a wooden board to save the deer before sunset | Helping those in need; gratitude for blessings |
| **5. مملكة النمل (Ant kingdom)** | Reem shrinks by the magic of a strange flower and enters the ant city | The ant queen, a lazy ant, a guard beetle | **Tiny perspective:** a water drop is a lake, a leaf is a bridge | Escaping giant raindrops into a safe tunnel | Teamwork, order |
| **6. مرصد النجوم (Star observatory)** | The owl carries Reem at night to the top of the high mountain | The owl, a cheeky bat, an old astronomer grandfather | **Star puzzles:** connect stars to form the map of the way | Reem guides a lost caravan of animals at night by the stars alone | Courage in the face of fear; love of knowledge |

Free small events between packs (one station, one situation, one card): «يوم الشجرة» (Tree day), «عيد الأم» (Mother's day).

## 5. Build order

1. Finish and stabilise the MVP features in progress (word discovery).
2. Base game systems: save/continue, settings, notebook (hints, words page, map, cards album), hotspot highlight.
3. Base valley stations in map order, one station at a time: Stream, Pine Fork, Oak forest, Rock cave, Meadow lake, Honey orchard, Hill slope, Waterfall path, Narrow pass, Hilltop festival with endings.
4. Packs in this order: 1 Gull island, 3 Ramadan lantern night, 2 Old city market, 4 Snow trail, 5 Ant kingdom, 6 Star observatory.

For each new station, follow docs/PIPELINE.md.
