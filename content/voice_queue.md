# voice_queue.md – voices and dialogue lines to record

Voice studio (Claude Desktop + ElevenLabs), see docs/PIPELINE.md:

1. **Voices:** design every voice in the table below with Status `todo`, save it in ElevenLabs under exactly that name, then set Status to `done`. If Voice Design refuses a child's voice, start the description with "A young woman with a bright, youthful, high-pitched voice".
2. **Lines:** record every row with Status `todo` in the Lines table, with the saved voice named in the Voice column and a model that supports Arabic (`eleven_multilingual_v2`; Thaaloob uses `eleven_v3`, see below). Use the Text exactly as written and keep the diacritics. The Tone column is direction only: never read it aloud or add it to the text. Save each as `assets/audio/lines/<File>.mp3`, then set Status to `done` (or `problem: <short reason>`).

Never delete rows; change their status. The builder adds rows here and the same lines to `game_data/lines.json` at the same time.

Saved settings from the MVP: Reem, Jad and Shahd use `eleven_multilingual_v2` with default settings. Thaaloob uses `eleven_v3` with stability 0.3 and style 0.5, and emotion tags in square brackets that match the Tone (for example `[playful]`, `[sly]`, `[laughs]`, `[embarrassed]`) placed before the Arabic text. This is an exception for Thaaloob only.

## Voices

| Voice name | Voice Design description | Preview text | Status |
| --- | --- | --- | --- |
| Reem | A young woman with a bright, youthful, high-pitched voice. Warm, cheerful, curious and very polite, gentle and respectful. Speaks clear Modern Standard Arabic with soft, friendly intonation at a natural, slightly quick pace. Clean studio recording, no background noise. | السلامُ عليكم يا جدّي! بسم الله، سأذهبُ الآنَ إلى الوادي، ولن أتأخّرَ إن شاء الله. ما شاء الله، ما أجملَ الزهورَ هنا! | done |
| Jad | A warm, wise elderly Arab man in his seventies. Deep, soft and gentle voice with a slight raspiness, calm and loving, a smile can be heard in his voice. Speaks clear Modern Standard Arabic slowly and kindly, like a grandfather telling a story. Clean studio recording. | وعليكمُ السلامُ ورحمةُ اللهِ وبركاتُه يا ريم. باركَ اللهُ فيكِ يا ابنتي. تعالَي واجلسي بجانبي، سأحكي لكِ حكايةً جميلةً عن وادي النسيم. | done |
| Thaaloob | A playful, smooth-talking cartoon fox voice: a light adult male voice, slightly nasal and sing-song, charming, quick and witty, with a cheeky little laugh. Mischievous but friendly, never scary or threatening. Speaks clear Modern Standard Arabic with playful rising intonation. Clean studio recording. | السلامُ عليكم يا صغيرةَ الوادي! انظري إلى هذا الحجرِ العجيب، يلمعُ أكثرَ من الشمس! ما رأيُكِ أن نتبادلَ، ها؟ | done |
| Shahd | A bright, energetic, friendly female cartoon voice with a slight buzzy, bouncy quality, quick and lively, honest and direct, warm-hearted. Speaks clear Modern Standard Arabic. Clean studio recording. | وعليكمُ السلام! نحنُ نحلاتُ الحقل، نعملُ منذُ الفجر. الزهورُ مغلقةٌ اليومَ، ولا نعرفُ كيفَ نصنعُ العسل! | done |

## Lines

All 68 MVP lines are recorded (`assets/audio/lines/`). New lines start below.

| File | Voice | Tone | Text | Status |
| --- | --- | --- | --- | --- |
