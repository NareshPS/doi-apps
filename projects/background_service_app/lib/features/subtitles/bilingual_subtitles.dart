import 'package:flutter/services.dart';
import 'package:subtitle_wrapper_package/subtitle_wrapper_package.dart';

class BilingualSubtitles {
  final Map<String, String> sources;
  late Map<String, Subtitles> languageSubtitles;

  BilingualSubtitles({required this.sources});

  Future<Subtitles> loadSource(source) async {
    print('loading ');
    final data = await rootBundle.loadString(source);

    final controller = SubtitleController(subtitlesContent: data);
    final repository = SubtitleDataRepository(subtitleController: controller);

    Subtitles subtitles = repository.getSubtitlesData(data, SubtitleType.srt);
    return subtitles;
  }

  load() async {
    final futures =
        sources.entries.map<Future<Subtitles>>((e) => loadSource(e.value));

    final loaded = await Future.wait<Subtitles>(futures);
    languageSubtitles = Map.fromIterables(sources.keys, loaded);
  }

  search(term, lang, {start = 0}) {
    final subtitles = languageSubtitles[lang]!.subtitles;
    final match =
        subtitles.indexWhere((item) => item.text.contains(term), start);

    print(
        'Term: $term Lang: $lang Matching Index: $match Text: ${subtitles[match].text}');
    // print('Term: $term Lang: $lang Matching Index: $match Text: ${subtitles[match].text}');
    return match == -1 ? null : match;
  }

  searchMany(term, lang, {count = 1}) {
    final matches = <int>[];
    int start = 0;
    for (int idx = 0; idx < count; idx++) {
      final matchId = search(term, lang, start: start);
      if (matchId == -1) {
        break;
      } else {
        start = matchId + 1;
        matches.add(matchId);
      }
    }
    return matches;
  }
}
