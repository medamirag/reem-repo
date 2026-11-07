# voice_queue.md – voices and dialogue lines to record

Voice studio (Codex or Claude Desktop + ElevenLabs), see docs/PIPELINE.md:

1. **Voices:** design every voice in the table below with Status `todo`, save it in ElevenLabs under exactly that name, then set Status to `done`. If Voice Design refuses a child's voice, start the description with "A young woman with a bright, youthful, high-pitched voice".
2. **Lines:** record every row with Status `todo` in the Lines table, with the saved voice named in the Voice column and the model/settings policy in AGENTS.md. Use the Text exactly as written and keep the diacritics. The Tone column is direction only: never read it aloud or add it to the text. Save each as `assets/audio/lines/<File>.mp3`, then set Status to `done` (or `problem: <short reason>`).

Never delete rows; change their status. The builder adds rows here and the same lines to `game_data/lines.json` at the same time.

Use the verified voice IDs, historical working settings and future batch records in **AGENTS.md, Saved voices and consistent recordings**. New expressive lines use `eleven_v3`, with `eleven_multilingual_v2` if v3 fails. Keep the same saved voice.

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
| reem_hint_briefing_1 | Reem | gentle, clear, thoughtful notebook reading | سَأَسْأَلُ جَدِّي عَنِ الرِّحْلَة. | done |
| reem_hint_briefing_2 | Reem | gentle, clear, thoughtful notebook reading | جَدِّي يَجْلِسُ تَحْتَ الشَّجَرَة. | done |
| reem_hint_briefing_3 | Reem | gentle, clear, thoughtful notebook reading | سَأَضْغَطُ عَلَى جَدِّي لِأَتَحَدَّثَ مَعَهُ. | done |
| reem_hint_yard_1 | Reem | gentle, clear, thoughtful notebook reading | أَنَا مُسْتَعِدَّةٌ لِلرِّحْلَة. | done |
| reem_hint_yard_2 | Reem | gentle, clear, thoughtful notebook reading | الْبَوَّابَةُ عَلَى يَمِينِ السَّاحَة. | done |
| reem_hint_yard_3 | Reem | gentle, clear, thoughtful notebook reading | سَأَضْغَطُ عَلَى السَّهْمِ الْأَيْمَنِ لِأَذْهَبَ إِلَى الْبَوَّابَة. | done |
| reem_hint_path_1 | Reem | gentle, clear, thoughtful notebook reading | سَأَنْظُرُ إِلَى الطَّرِيق. | done |
| reem_hint_path_2 | Reem | gentle, clear, thoughtful notebook reading | اللَّافِتَةُ تُسَاعِدُنِي عَلَى الْمَشْيِ بِرِفْقٍ. | done |
| reem_hint_path_3 | Reem | gentle, clear, thoughtful notebook reading | سَأَقْرَأُ اللَّافِتَةَ، ثُمَّ أَتَّبِعُ الطَّرِيقَ نَحْوَ الْيَمِينِ. | done |
| reem_hint_bee_1 | Reem | gentle, clear, thoughtful notebook reading | لَعَلَّ شَهْدَ تَحْتَاجُ إِلَى مُسَاعَدَتِي. | done |
| reem_hint_bee_2 | Reem | gentle, clear, thoughtful notebook reading | سَأَسْأَلُ النَّحْلَةَ عَنِ الزُّهُورِ. | done |
| reem_hint_bee_3 | Reem | gentle, clear, thoughtful notebook reading | سَأَضْغَطُ عَلَى شَهْدَ بِجَانِبِ خَلَايَا النَّحْلِ. | done |
| reem_hint_water_1 | Reem | gentle, clear, thoughtful notebook reading | يُمْكِنُنِي إِصْلَاحُ مَا حَدَثَ لِلزُّهُورِ. | done |
| reem_hint_water_2 | Reem | gentle, clear, thoughtful notebook reading | الزُّهُورُ الذَّابِلَةُ تَحْتَاجُ إِلَى الْمَاءِ. | done |
| reem_hint_water_3 | Reem | gentle, clear, thoughtful notebook reading | سَآخُذُ إِبْرِيقَ الرَّيِّ مِنَ الْبِئْرِ، ثُمَّ أَضْغَطُ عَلَى الزُّهُورِ الَّتِي دُسْتُهَا. | done |
| reem_hint_examine_1 | Reem | gentle, clear, thoughtful notebook reading | سَأَنْظُرُ إِلَى الزُّهُورِ الْمُغْلَقَةِ. | done |
| reem_hint_examine_2 | Reem | gentle, clear, thoughtful notebook reading | رُبَّمَا أَحْتَاجُ إِلَى شَيْءٍ يُسَاعِدُهَا. | done |
| reem_hint_examine_3 | Reem | gentle, clear, thoughtful notebook reading | سَأَضْغَطُ عَلَى الزُّهُورِ فِي الظِّلِّ لِأَعْرِفَ مَا يَنْقُصُنِي. | done |
| reem_hint_confess_1 | Reem | gentle, clear, thoughtful notebook reading | يُمْكِنُنِي أَنْ أَتَحَدَّثَ مَعَ جَدِّي بِصِدْقٍ. | done |
| reem_hint_confess_2 | Reem | gentle, clear, thoughtful notebook reading | جَدِّي يُسَاعِدُنِي حِينَ أُخْبِرُهُ بِمَا حَدَثَ. | done |
| reem_hint_confess_3 | Reem | gentle, clear, thoughtful notebook reading | سَأَعُودُ إِلَى السَّاحَةِ وَأَضْغَطُ عَلَى جَدِّي لِأُخْبِرَهُ عَنِ الْمِرْآةِ. | done |
| reem_hint_mirror_1 | Reem | gentle, clear, thoughtful notebook reading | الزُّهُورُ فِي الظِّلِّ تَحْتَاجُ إِلَى الضَّوْءِ. | done |
| reem_hint_mirror_2 | Reem | gentle, clear, thoughtful notebook reading | الْمِرْآةُ تَعْكِسُ ضَوْءَ الشَّمْسِ. | done |
| reem_hint_mirror_3 | Reem | gentle, clear, thoughtful notebook reading | مَعِي مِرْآةُ جَدِّي؛ سَأَضْغَطُ عَلَى الزُّهُورِ الْمُغْلَقَةِ لِأُوَجِّهَ الضَّوْءَ إِلَيْهَا. | done |
| reem_hint_forward_1 | Reem | gentle, clear, thoughtful notebook reading | يُمْكِنُنِي أَنْ أُكْمِلَ رِحْلَتِي. | done |
| reem_hint_forward_2 | Reem | gentle, clear, thoughtful notebook reading | الطَّرِيقُ يَمْتَدُّ نَحْوَ الْيَمِينِ. | done |
| reem_hint_forward_3 | Reem | gentle, clear, thoughtful notebook reading | سَأَضْغَطُ عَلَى السَّهْمِ الْأَيْمَنِ لِأُكْمِلَ الطَّرِيقَ. | done |
| reem_hint_stone_1 | Reem | gentle, clear, thoughtful notebook reading | هَلِ الْحَجَرُ كَمَا وَصَفَهُ ثَعْلُوبُ؟ | done |
| reem_hint_stone_2 | Reem | gentle, clear, thoughtful notebook reading | سَأَفْحَصُ الْحَجَرَ الَّذِي أَعْطَانِي إِيَّاهُ. | done |
| reem_hint_stone_3 | Reem | gentle, clear, thoughtful notebook reading | سَأَضْغَطُ عَلَى الْحَجَرِ فِي السَّلَّةِ لِأَمْسَحَهُ. | done |
| reem_hint_return_stone_1 | Reem | gentle, clear, thoughtful notebook reading | يُمْكِنُنِي إِصْلَاحُ هَذَا الْخَطَإِ. | done |
| reem_hint_return_stone_2 | Reem | gentle, clear, thoughtful notebook reading | ثَعْلُوبُ مَا زَالَ بِجَانِبِ الصَّخْرَةِ. | done |
| reem_hint_return_stone_3 | Reem | gentle, clear, thoughtful notebook reading | سَأَضْغَطُ عَلَى ثَعْلُوبَ لِأُعِيدَ الْحَجَرَ وَأَسْتَرِدَّ الْمِرْآةَ. | done |
| reem_card_shahd_name | Reem | gentle, clear, thoughtful notebook reading | شَهْد | done |
| reem_card_shahd_fact | Reem | gentle, clear, thoughtful notebook reading | تَجْمَعُ النَّحْلَةُ الرَّحِيقَ مِنَ الْأَزْهَارِ. | done |
| reem_stream_arrive | Reem | gentle, clear, reflective | هَذَا جَدْوَلٌ جَمِيلٌ. سَأَسِيرُ عَلَى الضِّفَّةِ بِهُدُوءٍ. | done |
| reem_stream_ducks | Reem | gentle, clear, reflective | تُرِيدُ الْبَطَّةُ وَصِغَارُهَا الْعُبُورَ، وَلَكِنَّ الْحِجَارَةَ تَحَرَّكَتْ. | done |
| reem_stream_log | Reem | gentle, clear, reflective | بِسْمِ اللّٰهِ. هَذَا الْجِذْعُ خَفِيفٌ. سَأُدَحْرِجُهُ لِيَصِيرَ جِسْرًا صَغِيرًا. | done |
| reem_stream_thanks | Reem | gentle, clear, reflective | عَبَرَتِ الْبَطَّةُ وَصِغَارُهَا! وَتَرَكَتْ لِي رِيشَةً مُلَوَّنَةً لِلْمِهْرَجَانِ. | done |
| reem_stream_rabbit | Reem | gentle, clear, reflective | هَذَا أَرْنُوبُ! رَكَضَ قَبْلَ أَنْ يَسْمَعَ وَصْفَ الطَّرِيقِ. هَلْ أَتْبَعُهُ؟ | done |
| reem_stream_map | Reem | gentle, clear, reflective | سَأَقْرَأُ خَرِيطَةَ جَدِّي أَوَّلًا. هَا هُوَ الطَّرِيقُ إِلَى الصَّنَوْبَرِ! | done |
| reem_stream_lost | Reem | gentle, clear, reflective | أَيْنَ الطَّرِيقُ؟ لَقَدْ تَسَرَّعْتُ. سَأَعُودُ إِلَى الضِّفَّةِ وَأَنْظُرُ فِي الْخَرِيطَةِ. | done |
| reem_stream_found | Reem | gentle, clear, reflective | الْحَمْدُ لِلّٰهِ! عَرَفْتُ الطَّرِيقَ مِنَ الْخَرِيطَةِ. سَأَتَمَهَّلُ. | done |
| fox_stream_offer | Thaaloob | playful, sly but gentle | يَا رِيمُ، دَعِينِي أَحْمِلُ الْفَانُوسَ عَنْكِ! سَتَصِيرُ سَلَّتُكِ أَخَفَّ. | done |
| reem_stream_keep | Reem | gentle, clear, reflective | جَزَاكَ اللّٰهُ خَيْرًا، وَلَكِنَّ الْفَانُوسَ أَمَانَةٌ. سَأَحْمِلُهُ بِنَفْسِي. | done |
| fox_stream_borrow | Thaaloob | playful, sly but gentle | سَأَجْلِسُ هُنَا وَأُجَرِّبُ ضَوْءَهُ قَلِيلًا! | done |
| reem_stream_ask_back | Reem | gentle, clear, reflective | يَا ثَعْلُوبُ، أَحْتَاجُ إِلَى الْفَانُوسِ لِلْمِهْرَجَانِ. أَعِدْهُ إِلَيَّ مِنْ فَضْلِكَ. | done |
| fox_stream_return | Thaaloob | playful, sly but gentle | تَفَضَّلِي. هَا هُوَ فَانُوسُكِ. | done |
| reem_card_duck_name | Reem | gentle, clear, reflective | الْبَطَّةُ | done |
| reem_card_duck_fact | Reem | gentle, clear, reflective | يُسَاعِدُ رِيشُ الْبَطَّةِ عَلَى إِبْعَادِ الْمَاءِ عَنْ جِسْمِهَا. | done |
| reem_hint_stream_bridge_1 | Reem | gentle, clear, reflective | كَيْفَ تَعْبُرُ الْبَطَّةُ مَعَ صِغَارِهَا؟ | done |
| reem_hint_stream_bridge_2 | Reem | gentle, clear, reflective | قُرْبَ الْمَاءِ جِذْعٌ خَفِيفٌ. | done |
| reem_hint_stream_bridge_3 | Reem | gentle, clear, reflective | أَضْغَطُ عَلَى الْجِذْعِ لِأَصْنَعَ جِسْرًا. | done |
| reem_hint_stream_map_1 | Reem | gentle, clear, reflective | التَّمَهُّلُ يُسَاعِدُنِي عَلَى مَعْرِفَةِ الطَّرِيقِ. | done |
| reem_hint_stream_map_2 | Reem | gentle, clear, reflective | خَرِيطَةُ جَدِّي فِي دَفْتَرِي. | done |
| reem_hint_stream_map_3 | Reem | gentle, clear, reflective | أَضْغَطُ عَلَى أَرْنُوبَ، ثُمَّ أَخْتَارُ الْخَرِيطَةَ. | done |
| reem_hint_stream_lantern_1 | Reem | gentle, clear, reflective | الْفَانُوسُ أَمَانَةٌ مَعِي. | done |
| reem_hint_stream_lantern_2 | Reem | gentle, clear, reflective | ثَعْلُوبُ مَا زَالَ قَرِيبًا مِنِّي. | done |
| reem_hint_stream_lantern_3 | Reem | gentle, clear, reflective | أَضْغَطُ عَلَى ثَعْلُوبَ لِأَطْلُبَ الْفَانُوسَ. | done |

| reem_pine_arrive | Reem | gentle, reflective | هُنَا تَلْتَقِي الطُّرُقُ عِنْدَ أَشْجَارِ الصَّنَوْبَرِ. | done |
| fox_pine_offer | Thaaloob | playful, sly | أَعْرِفُ طَرِيقًا سَهْلًا! لَا تَتَوَقَّفِي لِمُسَاعَدَةِ أَحَدٍ، فَلَنْ يَرَاكِ أَحَدٌ. | done |
| reem_pine_kind | Reem | gentle, reflective | سَأَخْتَارُ طَرِيقِي بِهُدُوءٍ، وَأُسَاعِدُ مَنْ يَحْتَاجُ إِلَيَّ إِنْ شَاءَ اللّٰهُ. | done |
| reem_pine_skip | Reem | gentle, reflective | سَأُوَافِقُكَ لِأَصِلَ بِسُرْعَةٍ، وَلَنْ أَتَوَقَّفَ لِأَحَدٍ. | done |
| fox_pine_cave | Thaaloob | playful, sly | طَرِيقُ الْكَهْفِ وَاحِدٌ مِنْ هَذِهِ الطُّرُقِ الثَّلَاثَةِ. | done |
| reem_pine_repair | Reem | gentle, reflective | الْوُصُولُ سَرِيعًا لَيْسَ كُلَّ شَيْءٍ. أَسْتَطِيعُ أَنْ أُغَيِّرَ اخْتِيَارِي. | done |
| reem_pine_fixed | Reem | gentle, reflective | سَأُسَاعِدُ مَنْ يَحْتَاجُ إِلَيَّ عَلَى أَيِّ طَرِيقٍ أَخْتَارُهُ. | done |
| reem_hint_pine_meet_1 | Reem | gentle, reflective | ثَعْلُوبُ عِنْدَ مُفْتَرَقِ الطُّرُقِ. | done |
| reem_hint_pine_meet_2 | Reem | gentle, reflective | مَاذَا يُرِيدُ أَنْ يَقُولَ لِي؟ | done |
| reem_hint_pine_meet_3 | Reem | gentle, reflective | أَضْغَطُ عَلَى ثَعْلُوبَ لِأَسْمَعَهُ. | done |
| reem_hint_pine_repair_1 | Reem | gentle, reflective | أَسْتَطِيعُ أَنْ أُغَيِّرَ اخْتِيَارِي. | done |
| reem_hint_pine_repair_2 | Reem | gentle, reflective | اللَّافِتَةُ تُسَاعِدُنِي عَلَى التَّفْكِيرِ. | done |
| reem_hint_pine_repair_3 | Reem | gentle, reflective | أَضْغَطُ عَلَى اللَّافِتَةِ وَأَخْتَارُ الْمُسَاعَدَةَ. | done |
| reem_hint_pine_route_1 | Reem | gentle, reflective | هُنَاكَ ثَلَاثَةُ طُرُقٍ. | done |
| reem_hint_pine_route_2 | Reem | gentle, reflective | أَسْتَطِيعُ أَنْ أَخْتَارَ الْغَابَةَ أَوِ الْكَهْفَ أَوِ الْبُحَيْرَةَ. | done |
| reem_hint_pine_route_3 | Reem | gentle, reflective | أَضْغَطُ عَلَى سَهْمِ الطَّرِيقِ الَّذِي أُرِيدُهُ. | done |
| reem_oak_arrive | Reem | warm | هُنَا تَنْمُو أَشْجَارُ الْبَلُّوطِ. | done |
| reem_oak_search | Reem | warm | نَسِيَ سِنْجُوبُ مَكَانَ ثِمَارِهِ. لِنَبْحَثْ قُرْبَ الْجُذُورِ. | done |
| reem_oak_found | Reem | warm | وَجَدْنَا الثِّمَارَ الثَّلَاثَ. مَاذَا نَفْعَلُ بِهَا؟ | done |
| reem_oak_share | Reem | warm | لِنَتَقَاسَمْهَا. هَذِهِ حِصَّةٌ لِلْمِهْرَجَانِ. | done |
| reem_oak_keep | Reem | warm | بَقِيَتِ الثِّمَارُ كُلُّهَا فِي كَوْمَةٍ وَاحِدَةٍ. | done |
| reem_oak_meet | Reem | warm | هَذَا قُنْفُوذٌ. يَقِفُ وَحْدَهُ. هَلْ أُسَلِّمُ عَلَيْهِ؟ | done |
| reem_oak_greet | Reem | warm | السَّلَامُ عَلَيْكَ يَا قُنْفُوذُ! شُكْرًا لِمُسَاعَدَتِكَ فِي جَمْعِ الْأَوْرَاقِ. | done |
| reem_oak_avoid | Reem | warm | بَقِيَ قُنْفُوذٌ وَحْدَهُ. يُمْكِنُنِي أَنْ أَعُودَ إِلَيْهِ. | done |
| reem_oak_card_sinjoob | Reem | warm | يُخَبِّئُ السِّنْجَابُ بَعْضَ طَعَامِهِ لِيَأْكُلَهُ لَاحِقًا. | done |
| reem_oak_card_qunfood | Reem | warm | تَحْمِي الْأَشْوَاكُ جِسْمَ الْقُنْفُذِ. | done |
| reem_oak_sinjoob_name | Reem | warm | سِنْجُوبُ | done |
| reem_oak_qunfood_name | Reem | warm | قُنْفُوذُ | done |

## Recording verification

2026-11-07: User approved the Reem Stream sample. Previous pending rows and Oak forest rows were recorded with their saved voices. See AGENTS.md for model, tags and available settings.
