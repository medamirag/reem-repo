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
| reem_hint_briefing_1 | Reem | gentle, clear, thoughtful notebook reading | سَأَسْأَلُ جَدِّي عَنِ الرِّحْلَة. | todo |
| reem_hint_briefing_2 | Reem | gentle, clear, thoughtful notebook reading | جَدِّي يَجْلِسُ تَحْتَ الشَّجَرَة. | todo |
| reem_hint_briefing_3 | Reem | gentle, clear, thoughtful notebook reading | سَأَضْغَطُ عَلَى جَدِّي لِأَتَحَدَّثَ مَعَهُ. | todo |
| reem_hint_yard_1 | Reem | gentle, clear, thoughtful notebook reading | أَنَا مُسْتَعِدَّةٌ لِلرِّحْلَة. | todo |
| reem_hint_yard_2 | Reem | gentle, clear, thoughtful notebook reading | الْبَوَّابَةُ عَلَى يَمِينِ السَّاحَة. | todo |
| reem_hint_yard_3 | Reem | gentle, clear, thoughtful notebook reading | سَأَضْغَطُ عَلَى السَّهْمِ الْأَيْمَنِ لِأَذْهَبَ إِلَى الْبَوَّابَة. | todo |
| reem_hint_path_1 | Reem | gentle, clear, thoughtful notebook reading | سَأَنْظُرُ إِلَى الطَّرِيق. | todo |
| reem_hint_path_2 | Reem | gentle, clear, thoughtful notebook reading | اللَّافِتَةُ تُسَاعِدُنِي عَلَى الْمَشْيِ بِرِفْقٍ. | todo |
| reem_hint_path_3 | Reem | gentle, clear, thoughtful notebook reading | سَأَقْرَأُ اللَّافِتَةَ، ثُمَّ أَتَّبِعُ الطَّرِيقَ نَحْوَ الْيَمِينِ. | todo |
| reem_hint_bee_1 | Reem | gentle, clear, thoughtful notebook reading | لَعَلَّ شَهْدَ تَحْتَاجُ إِلَى مُسَاعَدَتِي. | todo |
| reem_hint_bee_2 | Reem | gentle, clear, thoughtful notebook reading | سَأَسْأَلُ النَّحْلَةَ عَنِ الزُّهُورِ. | todo |
| reem_hint_bee_3 | Reem | gentle, clear, thoughtful notebook reading | سَأَضْغَطُ عَلَى شَهْدَ بِجَانِبِ خَلَايَا النَّحْلِ. | todo |
| reem_hint_water_1 | Reem | gentle, clear, thoughtful notebook reading | يُمْكِنُنِي إِصْلَاحُ مَا حَدَثَ لِلزُّهُورِ. | todo |
| reem_hint_water_2 | Reem | gentle, clear, thoughtful notebook reading | الزُّهُورُ الذَّابِلَةُ تَحْتَاجُ إِلَى الْمَاءِ. | todo |
| reem_hint_water_3 | Reem | gentle, clear, thoughtful notebook reading | سَآخُذُ إِبْرِيقَ الرَّيِّ مِنَ الْبِئْرِ، ثُمَّ أَضْغَطُ عَلَى الزُّهُورِ الَّتِي دُسْتُهَا. | todo |
| reem_hint_examine_1 | Reem | gentle, clear, thoughtful notebook reading | سَأَنْظُرُ إِلَى الزُّهُورِ الْمُغْلَقَةِ. | todo |
| reem_hint_examine_2 | Reem | gentle, clear, thoughtful notebook reading | رُبَّمَا أَحْتَاجُ إِلَى شَيْءٍ يُسَاعِدُهَا. | todo |
| reem_hint_examine_3 | Reem | gentle, clear, thoughtful notebook reading | سَأَضْغَطُ عَلَى الزُّهُورِ فِي الظِّلِّ لِأَعْرِفَ مَا يَنْقُصُنِي. | todo |
| reem_hint_confess_1 | Reem | gentle, clear, thoughtful notebook reading | يُمْكِنُنِي أَنْ أَتَحَدَّثَ مَعَ جَدِّي بِصِدْقٍ. | todo |
| reem_hint_confess_2 | Reem | gentle, clear, thoughtful notebook reading | جَدِّي يُسَاعِدُنِي حِينَ أُخْبِرُهُ بِمَا حَدَثَ. | todo |
| reem_hint_confess_3 | Reem | gentle, clear, thoughtful notebook reading | سَأَعُودُ إِلَى السَّاحَةِ وَأَضْغَطُ عَلَى جَدِّي لِأُخْبِرَهُ عَنِ الْمِرْآةِ. | todo |
| reem_hint_mirror_1 | Reem | gentle, clear, thoughtful notebook reading | الزُّهُورُ فِي الظِّلِّ تَحْتَاجُ إِلَى الضَّوْءِ. | todo |
| reem_hint_mirror_2 | Reem | gentle, clear, thoughtful notebook reading | الْمِرْآةُ تَعْكِسُ ضَوْءَ الشَّمْسِ. | todo |
| reem_hint_mirror_3 | Reem | gentle, clear, thoughtful notebook reading | مَعِي مِرْآةُ جَدِّي؛ سَأَضْغَطُ عَلَى الزُّهُورِ الْمُغْلَقَةِ لِأُوَجِّهَ الضَّوْءَ إِلَيْهَا. | todo |
| reem_hint_forward_1 | Reem | gentle, clear, thoughtful notebook reading | يُمْكِنُنِي أَنْ أُكْمِلَ رِحْلَتِي. | todo |
| reem_hint_forward_2 | Reem | gentle, clear, thoughtful notebook reading | الطَّرِيقُ يَمْتَدُّ نَحْوَ الْيَمِينِ. | todo |
| reem_hint_forward_3 | Reem | gentle, clear, thoughtful notebook reading | سَأَضْغَطُ عَلَى السَّهْمِ الْأَيْمَنِ لِأُكْمِلَ الطَّرِيقَ. | todo |
| reem_hint_stone_1 | Reem | gentle, clear, thoughtful notebook reading | هَلِ الْحَجَرُ كَمَا وَصَفَهُ ثَعْلُوبُ؟ | todo |
| reem_hint_stone_2 | Reem | gentle, clear, thoughtful notebook reading | سَأَفْحَصُ الْحَجَرَ الَّذِي أَعْطَانِي إِيَّاهُ. | todo |
| reem_hint_stone_3 | Reem | gentle, clear, thoughtful notebook reading | سَأَضْغَطُ عَلَى الْحَجَرِ فِي السَّلَّةِ لِأَمْسَحَهُ. | todo |
| reem_hint_return_stone_1 | Reem | gentle, clear, thoughtful notebook reading | يُمْكِنُنِي إِصْلَاحُ هَذَا الْخَطَإِ. | todo |
| reem_hint_return_stone_2 | Reem | gentle, clear, thoughtful notebook reading | ثَعْلُوبُ مَا زَالَ بِجَانِبِ الصَّخْرَةِ. | todo |
| reem_hint_return_stone_3 | Reem | gentle, clear, thoughtful notebook reading | سَأَضْغَطُ عَلَى ثَعْلُوبَ لِأُعِيدَ الْحَجَرَ وَأَسْتَرِدَّ الْمِرْآةَ. | todo |
| reem_card_shahd_name | Reem | gentle, clear, thoughtful notebook reading | شَهْد | todo |
| reem_card_shahd_fact | Reem | gentle, clear, thoughtful notebook reading | تَجْمَعُ النَّحْلَةُ الرَّحِيقَ مِنَ الْأَزْهَارِ. | todo |
