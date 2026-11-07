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
| reem_cave_arrive | Reem | warm | فِي الْكَهْفِ ظِلٌّ بَارِدٌ، وَمَعِي فَانُوسِي. | done |
| reem_cave_kitten | Reem | warm | تَخَافُ قَطْقُوطَةُ مِنَ الظَّلَامِ. هَلْ أَمْشِي مَعَهَا؟ | done |
| reem_cave_light | Reem | warm | تَعَالَيْ يَا قَطْقُوطَةُ، سَنَمْشِي خُطْوَةً خُطْوَةً. سَتَدُقِّينَ جَرَسَ الْمِهْرَجَانِ! | done |
| reem_cave_mock | Reem | warm | بَقِيَتْ قَطْقُوطَةُ عِنْدَ الْمَدْخَلِ. يُمْكِنُنِي أَنْ أَعُودَ إِلَيْهَا. | done |
| reem_cave_web | Reem | warm | قَطَعَتِ الرِّيحُ خُيُوطَ عَنْكُوبٍ. لِنَصِلِ الْأَشْكَالَ كَمَا فِي الْمِثَالِ. | done |
| reem_cave_give_up | Reem | warm | لَمْ تَكْتَمِلِ الشَّبَكَةُ. يُمْكِنُنِي الْمُحَاوَلَةُ مَرَّةً أُخْرَى. | done |
| reem_cave_thread | Reem | warm | اكْتَمَلَتِ الشَّبَكَةُ! شُكْرًا لَكَ يَا عَنْكُوبُ عَلَى خُيُوطِ الْفَوَانِيسِ. | done |
| fox_cave_praise | Thaaloob | playful | يَا رِيمُ، مَا أَجْمَلَ صَوْتَكِ! ضَعِي سَلَّتَكِ هُنَا وَغَنِّي لَنَا. | done |
| reem_cave_keep | Reem | warm | شُكْرًا يَا ثَعْلُوبُ. سَأُبْقِي سَلَّتِي قُرْبِي. | done |
| reem_cave_stolen | Reem | warm | أَخَذَ ثَعْلُوبُ جَرَّةَ الْعَسَلِ! سَأَرْفَعُ سَلَّتِي. | done |
| reem_cave_empty | Reem | warm | فَتَّشَ ثَعْلُوبُ فِي سَلَّتِي. سَأَرْفَعُهَا وَأُبْقِيهَا قُرْبِي. | done |
| reem_cave_repair | Reem | warm | سَلَّتِي مَعِي مِنْ جَدِيدٍ. | done |
| reem_cave_cat_name | Reem | warm | قَطْقُوطَةُ | done |
| reem_cave_cat_fact | Reem | warm | تُسَاعِدُ شَوَارِبُ الْقِطَّةِ عَلَى الإِحْسَاسِ بِمَا حَوْلَهَا. | done |
| reem_cave_spider_name | Reem | warm | عَنْكُوبُ | done |
| reem_cave_spider_fact | Reem | warm | لِلْعَنْكَبُوتِ ثَمَانِي أَرْجُلٍ. | done |
| reem_lake_arrive | Reem | warm | مَاءُ الْبُحَيْرَةِ هَادِئٌ. سَأَمْشِي عَلَى الضِّفَّةِ. | done |
| reem_lake_frog | Reem | warm | فَقَدَ دَفْدُوفُ صَوْتَهُ. قَلِيلٌ مِنَ الْعَسَلِ مَعَ مَاءٍ دَافِئٍ قَدْ يُسَاعِدُهُ. | done |
| reem_lake_need_honey | Reem | warm | لَيْسَ مَعِي عَسَلٌ. لِنَسْأَلِ الْقَارِبَ عِنْدَ الرَّصِيفِ. | done |
| reem_lake_boat | Reem | warm | يَقُولُ الْقَارِبُ إِنَّهُ سَيَأْخُذُنِي إِلَى الْبَحْرِ يَوْمًا مَا. | done |
| reem_lake_reserve | Reem | warm | لَدَى الْقَارِبِ مِلْعَقَةٌ مِنَ الْعَسَلِ لِدَفْدُوفَ. | done |
| reem_lake_share | Reem | warm | عَادَ صَوْتُ دَفْدُوفَ! أَهْدَانِي مِزْمَارًا مِنَ الْقَصَبِ. | done |
| reem_lake_keep | Reem | warm | بَقِيَ دَفْدُوفُ صَامِتًا. يُمْكِنُنِي أَنْ أُشَارِكَهُ الْعَسَلَ. | done |
| reem_lake_gazelle | Reem | warm | ابْتَعَدَتْ غَزْلَانَةُ عَنِ الْمَكَانِ الَّذِي حَدَّدَتْهُ أُمُّهَا. لِنَتْبَعْ آثَارَ خُطَاهَا. | done |
| reem_lake_tracks | Reem | warm | هَذَا أَثَرُ حَافِرٍ. لِنَبْحَثْ عَنِ الْأَثَرِ التَّالِي عَلَى الضِّفَّةِ. | done |
| reem_lake_reunion | Reem | warm | وَجَدْنَا أُمَّ غَزْلَانَةَ! سَتَبْقَى قُرْبَهَا هَذِهِ الْمَرَّةَ. | done |
| reem_lake_frog_name | Reem | warm | دَفْدُوفُ | done |
| reem_lake_frog_fact | Reem | warm | يَعِيشُ كَثِيرٌ مِنَ الضَّفَادِعِ قُرْبَ الْمَاءِ. | done |
| reem_lake_gazelle_name | Reem | warm | غَزْلَانَةُ | done |
| reem_lake_gazelle_fact | Reem | warm | تَجْرِي الْغِزْلَانُ بِسُرْعَةٍ عَلَى أَرْجُلِهَا الطَّوِيلَةِ. | done |
| reem_orchard_arrive | Reem | warm | وَصَلْتُ إِلَى بُسْتَانِ الْعَسَلِ. | done |
| reem_orchard_bear | Reem | warm | عَلِقَ رَأْسُ دُبٍّ فِي الْجَرَّةِ. كَيْفَ أُسَاعِدُهُ؟ | done |
| reem_orchard_soft | Reem | warm | لَا تَخَفْ يَا دُبُّ. سَأَضَعُ قَلِيلًا مِنَ الْعَسَلِ عَلَى حَافَّةِ الْجَرَّةِ. | done |
| reem_orchard_hard | Reem | warm | بَكَى دُبٌّ عِنْدَمَا شَدَدْتُ الْجَرَّةَ. سَأُحَاوِلُ بِرِفْقٍ. | done |
| reem_orchard_free | Reem | warm | خَرَجَ رَأْسُ دُبٍّ! سَيُسَاعِدُنَا فِي حَمْلِ الْفَوَانِيسِ. | done |
| fox_orchard_accuse | Thaaloob | playful | أَنَا مُتَأَكِّدٌ أَنَّ دُبًّا أَخَذَ فَوَانِيسَ الْمِهْرَجَانِ. | done |
| reem_orchard_look | Reem | warm | سَأَبْحَثُ عَنِ الْفَوَانِيسِ قَبْلَ أَنْ أَحْكُمَ. | done |
| reem_orchard_blame | Reem | warm | حَزِنَ دُبٌّ عِنْدَمَا قُلْتُ إِنَّهُ أَخَذَهَا. سَأَبْحَثُ عَنْهَا. | done |
| reem_orchard_wet | Reem | warm | هَا هِيَ الْفَوَانِيسُ! سَقَطَتْ فِي الْجَدْوَلِ، وَلَمْ يَأْخُذْهَا دُبٌّ. | done |
| reem_orchard_sorry | Reem | warm | عُذْرًا يَا دُبُّ. وَجَدْتُ الْفَوَانِيسَ عِنْدَ الْجَدْوَلِ. | done |
| reem_orchard_report | Reem | warm | يَا دُبُّ، وَجَدْتُ الْفَوَانِيسَ عِنْدَ الْجَدْوَلِ. لِنَحْمِلْهَا مَعًا. | done |
| reem_orchard_dubb_name | Reem | warm | دُبٌّ | done |
| reem_orchard_dubb_fact | Reem | warm | لِلدُّبِّ حَاسَّةُ شَمٍّ قَوِيَّةٌ. | done |
| reem_hill_arrive | Reem | warm | بَدَأَتِ الشَّمْسُ تَغْرُبُ خَلْفَ التَّلِّ. | done |
| reem_hill_proud | Reem | warm | لَا يُرِيدُ طَاوُوسٌ أَنْ يُعِيرَنَا رِيشَهُ. يَقُولُ إِنَّهُ الْأَجْمَلُ. | done |
| reem_hill_flatter | Reem | warm | مَدَحْتُهُ وَحْدَهُ، وَبَقِيَ الْفَانُوسُ بِلَا زِينَةٍ. | done |
| reem_hill_show | Reem | warm | لِنَضَعِ الرِّيشَةَ مَعَ الشَّرِيطِ وَفَانُوسِ الْمِهْرَجَانِ. | done |
| reem_hill_gift | Reem | warm | انْظُرْ يَا طَاوُوسُ! بِعَمَلِنَا مَعًا صَارَ الْفَانُوسُ أَجْمَلَ. شُكْرًا لَكَ عَلَى الرِّيشِ. | done |
| reem_hill_name | Reem | warm | طَاوُوسٌ | done |
| reem_hill_fact | Reem | warm | يَبْسُطُ الطَّاوُوسُ رِيشَ ذَيْلِهِ مِثْلَ الْمِرْوَحَةِ. | done |
| jad_map_intro | Jad | warm | هذه خريطة الوادي يا ريم. كلما زرتِ مكاناً جديداً ظهر عليها، وإن احترتِ في طريقك فانظري إليها. | done |
| reem_waterfall_arrive | Reem | warm | أَسْمَعُ صَوْتَ الشَّلَّالِ مِنْ هُنَا. | done |
| reem_waterfall_provoked | Reem | surprised | دَحْرَجَ قَرْقُورٌ ثَمَرَةً إِلَى طَرِيقِي! لِمَاذَا فَعَلَ ذَلِكَ؟ | done |
| reem_waterfall_throw | Reem | gentle | رَمَيْتُ الثَّمَرَةَ، فَابْتَعَدَ قَرْقُورٌ. سَأَتَحَدَّثُ إِلَيْهِ بِهُدُوءٍ. | done |
| reem_waterfall_ask | Reem | warm | قَالَ قَرْقُورٌ إِنَّهُ أَرَادَ أَنْ يَلْعَبَ مَعَ أَحَدٍ. | done |
| reem_waterfall_roll | Reem | playful | هَيَّا نُدَحْرِجُ الثَّمَرَةَ عَلَى الْأَرْضِ مَعًا! | done |
| reem_waterfall_gift | Reem | warm | لَعِبْنَا مَعًا! سَيُسَاعِدُنَا قَرْقُورٌ فِي تَعْلِيقِ الْفَوَانِيسِ الْعَالِيَةِ. | done |
| reem_waterfall_name | Reem | warm | قَرْقُورٌ | done |
| reem_waterfall_fact | Reem | warm | يَتَسَلَّقُ الْقِرْدُ الْأَغْصَانَ بِيَدَيْهِ وَقَدَمَيْهِ. | done |
| reem_pass_arrive | Reem | warm | هَذَا هُوَ الْمَمَرُّ إِلَى الْقِمَّةِ. | done |
| fox_pass_help | Thaaloob | worried | يَا رِيمُ، عَلِقَ ذَيْلِي بَيْنَ الصَّخْرَتَيْنِ. هَلْ تُسَاعِدِينَنِي؟ | done |
| reem_pass_leave | Reem | gentle | مَضَيْتُ وَبَقِيَ ثَعْلُوبٌ عَالِقًا. أَسْتَطِيعُ أَنْ أَعُودَ إِلَيْهِ. | done |
| reem_pass_stone | Reem | warm | سَأُدَحْرِجُ الْحَجَرَ الصَّغِيرَ بَعِيدًا عَنْ ذَيْلِكَ. | done |
| fox_pass_sorry | Thaaloob | embarrassed | سَاعَدْتِنِي بَعْدَ كُلِّ مَا فَعَلْتُ. أَنَا آسِفٌ يَا رِيمُ. | done |
| fox_pass_honey | Thaaloob | embarrassed | هَذِهِ جَرَّةُ عَسَلِكِ. خُذِيهَا، فَهِيَ لَكِ. | done |
| fox_pass_join | Thaaloob | gentle | هَلْ يُمْكِنُنِي أَنْ آتِيَ مَعَكِ إِلَى الْمِهْرَجَانِ؟ | done |
| reem_pass_welcome | Reem | warm | سَامَحْتُكَ يَا ثَعْلُوبُ. تَعَالَ مَعِي، وَلْنَحْمِلِ الْفَوَانِيسَ مَعًا. | done |
| reem_festival_arrive | Reem | warm | وَصَلْنَا إِلَى الْقِمَّةِ! أَصْدِقَائِي هُنَا، وَالْفَانُوسُ الْكَبِيرُ يَنْتَظِرُنَا. | done |
| reem_festival_high | Reem | playful | قَرْقُورٌ يُعَلِّقُ الْفَوَانِيسَ الْعَالِيَةَ. | done |
| reem_festival_light | Reem | warm | بِسْمِ اللهِ، لِنُضِئِ الْفَانُوسَ الْكَبِيرَ. | done |
| jad_festival_arrive | Jad | warm | السَّلَامُ عَلَيْكُمْ! حَمَلَنِي دُبٌّ إِلَى الْقِمَّةِ، فَشُكْرًا لَهُ. | done |
| jad_festival_thanks | Jad | warm | كُلَّمَا سَاعَدْتِ صَدِيقًا يَا رِيمُ، حَمَلَ مَعَكِ شَيْئًا إِلَى الْمِهْرَجَانِ. جَزَاكِ اللهُ خَيْرًا. | done |
| jad_festival_repair | Jad | gentle | وَحِينَ أَخْطَأْتِ، عُدْتِ وَأَصْلَحْتِ خَطَأَكِ. فَرِحَ أَصْدِقَاؤُكِ بِعَوْدَتِكِ. | done |
| jad_festival_wilt | Jad | gentle | مَا زَالَ هُنَاكَ مَكَانٌ تَسْتَطِيعِينَ أَنْ تَعُودِي إِلَيْهِ. سَيَفْرَحُ صَدِيقُكِ بِرُؤْيَتِكِ. | done |
| jad_festival_oak | Jad | warm | سَمِعْتُ أَنَّ قُنْفُذًا فِي غَابَةِ الْبَلُّوطِ يَنْتَظِرُ صَدِيقًا. هَلْ تَزُورِينَهُ فِي رِحْلَةٍ أُخْرَى؟ | done |
| jad_festival_cave | Jad | warm | عِنْدَ الْكَهْفِ قِطَّةٌ صَغِيرَةٌ تُحِبُّ ضَوْءَ الْفَانُوسِ. هَلْ تَزُورِينَهَا فِي رِحْلَةٍ أُخْرَى؟ | done |
| jad_festival_lake | Jad | warm | عِنْدَ الْبُحَيْرَةِ ضِفْدَعٌ يُحِبُّ الْغِنَاءَ. هَلْ تَسْمَعِينَ غِنَاءَهُ فِي رِحْلَةٍ أُخْرَى؟ | done |
| jad_festival_other | Jad | warm | فِي الْوَادِي دُرُوبٌ أُخْرَى. اخْتَارِي دَرْبًا جَدِيدًا فِي رِحْلَةٍ أُخْرَى. | done |
| reem_gull_board | Reem | warm | الْقَارِبُ مُسْتَعِدٌّ لِيَأْخُذَنِي إِلَى جَزِيرَةِ النَّوَارِسِ. | done |
| reem_gull_shore | Reem | warm | وَصَلْنَا إِلَى الشَّاطِئِ. مَاءُ الْبَحْرِ يَعْلُو ثُمَّ يَنْخَفِضُ. | done |
| reem_gull_turtle | Reem | warm | السُّلَحْفَاةُ تَرَى قِطَعًا مِنَ النُّفَايَاتِ قُرْبَ الْمَاءِ. هَلْ أَجْمَعُهَا؟ | done |
| reem_gull_leave | Reem | gentle | بَقِيَتِ النُّفَايَاتُ قُرْبَ الْمَاءِ. يُمْكِنُنِي أَنْ أَعُودَ وَأَجْمَعَهَا. | done |
| reem_gull_collect | Reem | warm | سَأَضَعُ النُّفَايَاتِ فِي السَّلَّةِ. | done |
| reem_gull_clean | Reem | warm | أَصْبَحَ الشَّاطِئُ نَظِيفًا، وَالسُّلَحْفَاةُ سَعِيدَةٌ. | done |
| reem_gull_low | Reem | warm | انْخَفَضَ الْمَاءُ، وَظَهَرَ الدَّرْبُ إِلَى الْكَهْفِ. | done |
| reem_gull_high | Reem | warm | ارْتَفَعَ الْمَاءُ وَغَطَّى الدَّرْبَ. سَنَنْتَظِرُ عَلَى الشَّاطِئِ. | done |
| reem_gull_turtle_name | Reem | warm | سُلَحْفَاةُ الْبَحْرِ | done |
| reem_gull_turtle_fact | Reem | warm | تَسْتَخْدِمُ السُّلَحْفَاةُ الْبَحْرِيَّةُ زَعَانِفَهَا لِلسِّبَاحَةِ. | done |
| reem_gull_cave | Reem | warm | تَبْدُو الْبِرَكُ الصَّغِيرَةُ بِلَوْنِ السَّمَاءِ وَالصَّخْرِ وَالرَّمْلِ. | done |
| reem_gull_pattern | Reem | warm | يُرِينِي الْأُخْطُبُوطُ الْأَشْكَالَ. سَأَتَّبِعُ تَرْتِيبَهَا. | done |
| reem_gull_retry | Reem | gentle | لِنَرَ الْأَشْكَالَ مَرَّةً أُخْرَى. | done |
| reem_gull_lens | Reem | warm | هَذِهِ عَدَسَةُ الْمَنَارَةِ. شُكْرًا لَكَ يَا أُخْطُبُوطُ! | done |
| reem_gull_octopus_name | Reem | warm | أُخْطُبُوطٌ | done |
| reem_gull_octopus_fact | Reem | warm | لِلْأُخْطُبُوطِ ثَمَانِيَةُ أَذْرُعٍ، وَيَسْتَطِيعُ أَنْ يُغَيِّرَ لَوْنَهُ. | done |
| reem_gull_storm | Reem | gentle | هَبَّتْ رِيحٌ خَفِيفَةٌ. سَيَنْتَظِرُ الْقَارِبُ حَتَّى تَضِيءَ الْمَنَارَةُ. | done |
| reem_gull_shells | Reem | warm | يُرِيدُ النَّوْرَسُ أَنْ يَأْخُذَ كُلَّ الْأَصْدَافِ. لِنَتْرُكْ بَعْضَهَا لِلْبَحْرِ. | done |
| reem_gull_pile | Reem | gentle | تَدَحْرَجَتِ الْأَصْدَافُ مِنَ الْكَوْمَةِ. سَنُعِيدُ بَعْضَهَا إِلَى الشَّاطِئِ. | done |
| reem_gull_share | Reem | warm | تَرَكْنَا بَعْضَ الْأَصْدَافِ عَلَى الشَّاطِئِ، وَفَرِحَ النَّوْرَسُ بِصَدَفَةٍ وَاحِدَةٍ. | done |
| fox_gull_trade | Thaaloob | playful | مَا أَلْمَعَ هَذِهِ الصَّدَفَةَ! كُنْتُ سَأُبَادِلُكِ بِهَا، وَلَكِنِّي سَأَتْرُكُهَا هُنَا. | done |
| reem_gull_light | Reem | warm | رَكَّبْتُ الْعَدَسَةَ فَأَضَاءَتِ الْمَنَارَةُ. يَسْتَطِيعُ الْقَارِبُ أَنْ يَرَى الطَّرِيقَ. | done |
| reem_gull_lens_hint | Reem | gentle | نَحْتَاجُ إِلَى عَدَسَةٍ لِمِصْبَاحِ الْمَنَارَةِ. سَأَبْحَثُ فِي كَهْفِ الْمَدِّ. | done |
| reem_gull_bird_name | Reem | warm | نَوْرَسٌ | done |
| reem_gull_bird_fact | Reem | warm | لِلنَّوْرَسِ أَقْدَامٌ مُكْفَّفَةٌ تُسَاعِدُهُ عَلَى السِّبَاحَةِ. | done |
| reem_ramadan_offer | Reem | warm | أَضَاءَتْ فَوَانِيسُ الْحَيِّ. هَلْ أَذْهَبُ لِأُسَاعِدَ فِي تَجْهِيزِ الْإِفْطَارِ؟ | done |
| reem_ramadan_lane | Reem | warm | هَذِهِ لَيْلَةٌ مِنْ لَيَالِي رَمَضَانَ. سَأَحْمِلُ فَانُوسِي فِي الطَّرِيقِ. | done |
| reem_ramadan_caller | Reem | warm | يُرِينِي الْمُسَحِّرَاتِي كَيْفَ يَكْشِفُ ضَوْءُ الْفَانُوسِ مَا فِي الظِّلِّ. | done |
| reem_ramadan_search | Reem | warm | عِنْدَمَا أُضِيءُ الْفَانُوسَ، أَسْتَطِيعُ أَنْ أَرَى السَّلَّتَيْنِ وَالْإِبْرِيقَ. | done |
| reem_ramadan_found | Reem | warm | وَجَدْتُ السَّلَّتَيْنِ وَالْمَاءَ. لِنَذْهَبْ إِلَى عَائِلَةِ الْقَنَافِذِ. | done |
| reem_ramadan_court | Reem | warm | تُرِيدُ عَائِلَةُ الْقَنَافِذِ أَنْ تُفَاجِئَ مُسَافِرًا بِالْإِفْطَارِ. | done |
| reem_ramadan_keep | Reem | gentle | أَبْقَيْتُ التَّمْرَ لِنَفْسِي، فَبَقِيَ الطَّبَقُ فَارِغًا. يُمْكِنُنِي أَنْ أُشَارِكَ. | done |
| reem_ramadan_dates | Reem | warm | سَأَبْحَثُ عَنِ التَّمْرِ وَأَضَعُهُ فِي الطَّبَقِ لِنَأْكُلَ مَعًا. | done |
| reem_ramadan_shared | Reem | warm | جَمَعْتُ التَّمْرَ لِلْمُسَافِرِ. شُكْرًا لَكُمْ يَا أَصْدِقَائِي. | done |
| reem_ramadan_shelter | Reem | warm | هَذَا مَكَانٌ هَادِئٌ لِنَجْلِسَ مَعَ الْمُسَافِرِ. | done |
| fox_ramadan_date | Thaaloob | playful | هَذِهِ آخِرُ تَمْرَةٍ! سَأَضَعُهَا مَعَ التَّمْرِ لِنَتَقَاسَمَهُ. | done |
| reem_ramadan_feast | Reem | warm | هَا هُوَ الْمَاءُ وَالتَّمْرُ. تَفَضَّلْ، سَنُفْطِرُ مَعًا عِنْدَ الْمَغْرِبِ. | done |
| reem_ramadan_hedgehog_name | Reem | warm | عَائِلَةُ الْقَنَافِذِ | done |
| reem_ramadan_hedgehog_fact | Reem | warm | يَخْرُجُ الْقُنْفُذُ فِي اللَّيْلِ لِيَبْحَثَ عَنْ طَعَامِهِ. | done |
| reem_market_offer | Reem | warm | هَذَا دَرْبٌ إِلَى سُوقِ الْمَدِينَةِ. هَلْ أَذْهَبُ إِلَيْهِ؟ | done |
| reem_market_arrive | Reem | warm | وَصَلْتُ إِلَى بَوَّابَةِ السُّوقِ. هُنَا أَسْتَطِيعُ أَنْ أَبِيعَ الْعَسَلَ. | done |
| reem_market_sale | Reem | warm | بِعْتُ الْعَسَلَ بِخَمْسِ قِطَعٍ نَقْدِيَّةٍ. سَأَعُدُّهَا قَبْلَ أَنْ أَشْتَرِيَ. | done |
| reem_market_baker | Reem | warm | يَقُولُ الْخَبَّازُ إِنَّ ثَمَنَ الْخُبْزِ ثَلَاثُ قِطَعٍ نَقْدِيَّةٍ. | done |
| reem_market_count | Reem | gentle | لِنَعُدَّ الْقِطَعَ مَرَّةً أُخْرَى. ثَمَنُ الْخُبْزِ ثَلَاثُ قِطَعٍ. | done |
| reem_market_paid | Reem | warm | دَفَعْتُ ثَلَاثَ قِطَعٍ، وَبَقِيَتْ مَعِي قِطْعَتَانِ. | done |
| reem_market_cat | Reem | warm | تَنْظُرُ قِطَّةُ السُّوقِ إِلَى الْخُبْزِ. هَلْ أُشَارِكُهَا؟ | done |
| reem_market_keep | Reem | gentle | بَقِيَ طَبَقُ الْقِطَّةِ فَارِغًا. أَسْتَطِيعُ أَنْ أُشَارِكَهَا. | done |
| reem_market_share | Reem | warm | وَضَعْتُ قِطْعَةً صَغِيرَةً فِي طَبَقِهَا، وَجَلَسْنَا مَعًا. | done |
| reem_market_cat_name | Reem | warm | قِطَّةُ السُّوقِ | done |
| reem_market_cat_fact | Reem | warm | تُسَاعِدُ شَوَارِبُ الْقِطَّةِ فِي مَعْرِفَةِ الْأَمَاكِنِ الضَّيِّقَةِ. | done |
| reem_market_scale | Reem | warm | هُنَا مِيزَانٌ بِكَفَّتَيْنِ. لِنَنْظُرْ كَيْفَ يَعْمَلُ. | done |
| fox_market_offer | Thaaloob | playful | تَفَضَّلِي إِلَى مِيزَانِي! لَا حَاجَةَ إِلَى اخْتِبَارِهِ. | done |
| reem_market_trust | Reem | gentle | مَالَتْ كَفَّةُ الْمِيزَانِ. سَأُجَرِّبُهُ بِوَزْنَيْنِ مُتَسَاوِيَيْنِ. | done |
| reem_market_weights | Reem | warm | سَأَضَعُ وَزْنًا فِي كُلِّ كَفَّةٍ، ثُمَّ أُحَرِّكُ الْمِقْبَضَ. | done |
| reem_market_tilt | Reem | warm | الْوَزْنَانِ مُتَسَاوِيَانِ، وَلَكِنَّ الْمِيزَانَ مَائِلٌ. سَأُرِي الْخَبَّازَ. | done |
| fox_market_sorry | Thaaloob | embarrassed | آسِفٌ يَا رِيمُ. سَأُعِيدُ الثِّقْلَ إِلَى مَكَانِهِ الصَّحِيحِ. | done |
| reem_market_fair | Reem | warm | الْآنَ تَسَاوَتِ الْكَفَّتَانِ. هَذَا مِيزَانٌ عَادِلٌ. | done |
| reem_snow_offer | Reem | warm | هَذَا دَرْبُ الثَّلْجِ. هَلْ أَسْلُكُهُ؟ | done |
| reem_snow_edge | Reem | warm | غَطَّى الثَّلْجُ الْأَشْجَارَ، وَبَقِيَ الدَّرْبُ وَاضِحًا. | done |
| reem_snow_cold | Reem | gentle | الْحَسُّونُ الصَّغِيرُ يَشْعُرُ بِالْبَرْدِ. هَلْ أُعْطِيهِ الْقِطْعَةَ الدَّافِئَةَ؟ | done |
| reem_snow_keep | Reem | gentle | بَقِيَ الْحَسُّونُ بَارِدًا. أَسْتَطِيعُ أَنْ أَضَعَ الْقِطْعَةَ فِي مَأْوَاهُ. | done |
| reem_snow_shelter | Reem | warm | سَأَضَعُ الْقِطْعَةَ النَّاعِمَةَ فِي مَأْوَى الْحَسُّونِ. | done |
| reem_snow_warm | Reem | warm | دَخَلَ الْحَسُّونُ مَأْوَاهُ وَدَفِئَ. | done |
| reem_snow_bird_name | Reem | warm | حَسُّونٌ | done |
| reem_snow_bird_fact | Reem | warm | يَأْكُلُ الْحَسُّونُ الْبُذُورَ بِمِنْقَارِهِ الصَّغِيرِ. | done |
| reem_snow_tracks | Reem | warm | هَذِهِ آثَارُ أَقْدَامٍ عَلَى الثَّلْجِ. | done |
| reem_snow_rabbit | Reem | warm | يُرِينِي أَرْنُوبٌ آثَارَ قَفَزَاتِهِ. أَمَّا الصَّغِيرُ فَلِحَوَافِرِهِ شَقٌّ فِي الْوَسَطِ. | done |
| fox_snow_tracks | Thaaloob | playful | اِتَّبِعِي آثَارِي! أَوْ لِنُقَارِنْهَا أَوَّلًا بِآثَارِ حَوَافِرِ الْأَيِّلِ. | done |
| reem_snow_compare | Reem | gentle | هَذَا الْأَثَرُ مُخْتَلِفٌ. سَأَبْحَثُ عَنْ أَثَرٍ فِيهِ شَقٌّ. | done |
| reem_snow_follow | Reem | warm | تُؤَدِّي آثَارُ الْحَوَافِرِ إِلَى أَسْفَلِ التَّلِّ. | done |
| reem_snow_sled | Reem | warm | أَرَى الْأَيِّلَ أَسْفَلَ التَّلِّ. سَأَنْزَلُ عَلَى اللَّوْحِ الْخَشَبِيِّ. | done |
| reem_snow_help | Reem | warm | هَيَّا نَمْشِي إِلَى الْمَأْوَى الدَّافِئِ قَبْلَ غُرُوبِ الشَّمْسِ. | done |
| reem_snow_deer_name | Reem | warm | أَيِّلٌ صَغِيرٌ | done |
| reem_snow_deer_fact | Reem | warm | لِصِغَارِ بَعْضِ الْأَيَائِلِ بُقَعٌ فَاتِحَةٌ عَلَى ظُهُورِهَا. | done |
| reem_ant_offer | Reem | warm | مَا أَكْبَرَ هَذِهِ الزَّهْرَةَ! هَلْ أَقْتَرِبُ لِأَرَى مَمْلَكَةَ النَّمْلِ؟ | done |
| reem_ant_tiny | Reem | warm | صِرْتُ صَغِيرَةً، وَصَارَتْ حَبَّةُ الرَّمْلِ كَحَجَرٍ كَبِيرٍ. | done |
| reem_ant_worker | Reem | warm | تَوَقَّفَتِ النَّمْلَةُ عَنْ حَمْلِ الْبُذُورِ. لِنَحْمِلْ وَاحِدَةً مَعًا. | done |
| reem_ant_leave | Reem | gentle | بَقِيَتِ النَّمْلَةُ وَحْدَهَا مَعَ الْحِمْلِ الثَّقِيلِ. يُمْكِنُنِي أَنْ أُسَاعِدَهَا. | done |
| reem_ant_carry | Reem | warm | سَأَرْفَعُ طَرَفَ الْبَذْرَةِ مَعَ النَّمْلَةِ. | done |
| reem_ant_helped | Reem | warm | حَمَلْنَا الْبَذْرَةَ مَعًا، وَالْآنَ تَسْتَرِيحُ النَّمْلَةُ. | done |
| reem_ant_worker_name | Reem | warm | النَّمْلَةُ الْعَامِلَةُ | done |
| reem_ant_worker_fact | Reem | warm | لِلنَّمْلَةِ سِتُّ أَرْجُلٍ. | done |
| reem_ant_dew | Reem | warm | قَطْرَةُ الْمَاءِ هُنَا كَأَنَّهَا بُحَيْرَةٌ. | done |
| reem_ant_guard | Reem | warm | تُرِينِي الْخُنْفُسَاءُ الْوَرَقَةَ. إِذَا وَصَلَتْ إِلَى الضِّفَّتَيْنِ، صَارَتْ جِسْرًا. | done |
| fox_ant_hurry | Thaaloob | playful | كِدْتُ أَعْبُرُ قَبْلَ أَنْ تَسْتَقِرَّ الْوَرَقَةُ! سَأَنْتَظِرُ مَعَكِ. | done |
| reem_ant_bridge | Reem | warm | اسْتَقَرَّتِ الْوَرَقَةُ، وَصَارَ لَنَا جِسْرٌ. | done |
| reem_ant_beetle_name | Reem | warm | الْخُنْفُسَاءُ الْحَارِسَةُ | done |
| reem_ant_beetle_fact | Reem | warm | تَحْمِي أَغْطِيَةُ الْخُنْفُسَاءِ الصُّلْبَةُ أَجْنِحَتَهَا. | done |
| reem_ant_city | Reem | warm | هَذِهِ مَخَازِنُ النَّمْلِ. لِكُلِّ بَذْرَةٍ مَكَانٌ. | done |
| reem_ant_order | Reem | warm | سَأَضَعُ الْبُذُورَ مِنَ الْأَصْغَرِ إِلَى الْأَكْبَرِ. | done |
| reem_ant_try | Reem | gentle | لِنَنْظُرْ إِلَى حَجْمِ الْبَذْرَةِ الَّتِي تَأْتِي بَعْدَهَا. | done |
| reem_ant_rain | Reem | gentle | بَدَأَ الْمَطَرُ فِي الْخَارِجِ. لِنَدْخُلِ النَّفَقَ مَعًا. | done |
| reem_ant_safe | Reem | warm | وَصَلْنَا إِلَى مَكَانٍ جَافٍّ، وَالْبُذُورُ فِي مَخَازِنِهَا. | done |
| reem_ant_queen_name | Reem | warm | مَلِكَةُ النَّمْلِ | done |
| reem_ant_queen_fact | Reem | warm | تَضَعُ مَلِكَةُ النَّمْلِ الْبَيْضَ فِي الْمُسْتَعْمَرَةِ. | done |

## Recording verification

2026-11-07: User approved the Reem Stream sample. Previous pending rows and Oak forest rows were recorded with their saved voices. See AGENTS.md for model, tags and available settings.
