import 'package:flutter/services.dart';
import 'package:nokhwook/main.dart';
import 'package:subtitle_wrapper_package/subtitle_wrapper_package.dart';

class SubtitlesService {
  final alignmentContext = 1;
  final Map<String, String> sources;
  late Map<String, Subtitles> languageSubtitles;

  SubtitlesService({required this.sources});

  Future<Subtitles> loadSource(source) async {
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

    logger.i('Term: $term Lang: $lang Index: $match'
        ' Text: ${match != -1 ? subtitles[match].text : null}');

    return match == -1 ? null : match;
  }

  List<int> searchMany({required term, required lang, count = 1}) {
    final matches = <int>[];
    int start = 0;
    for (int idx = 0; idx < count; idx++) {
      final matchId = search(term, lang, start: start);
      if (matchId == null) {
        break;
      } else {
        start = matchId + 1;
        matches.add(matchId);
      }
    }
    return matches;
  }

  Map<String, List<int>> alignedSearch(
      {required term, required primaryLanguage, count = 1}) {
    final matchIds =
        searchMany(term: term, lang: primaryLanguage, count: count);
    final secondaryLanguages =
        languageSubtitles.keys.where((lang) => lang != primaryLanguage);

    final secondaryAlignments = secondaryLanguages.map((lang) {
      return matchIds.map((matchId) {
        final searchMatch =
            languageSubtitles[primaryLanguage]!.subtitles[matchId];
        int alignment = RangeSearch(languageSubtitles[lang]!.subtitles)
            .search(searchMatch, (Subtitle a, Subtitle b) {
          return a.endTime < b.startTime;
        });

        ///
        /// RangeSearch returns the index right after the pivot ends.
        /// We adjust the alignment to select the range that overlaps with the pivot.
        alignment = alignment == -1 ? alignment : alignment - 1;
        final alignedMatch = languageSubtitles[lang]!.subtitles[alignment];
        print('Match: ${searchMatch.text} Pivot: ${searchMatch.endTime}'
            ' Alignment: $alignment Start: ${alignedMatch.startTime} End: ${alignedMatch.endTime}'
            ' Text: ${alignedMatch.text}');
        return alignment;
      }).toList();
    });

    final alignments =
        Map.fromIterables(secondaryLanguages, secondaryAlignments);

    // Add primary results to the aligned matches.
    alignments[primaryLanguage] = matchIds;

    return alignments;
  }

  Map<String, List<String>> resolve({required term, required lang, count = 1}) {
    // List<int> matchIds = searchMany(term: term, lang: lang, count: count);
    final alignments =
        alignedSearch(term: term, primaryLanguage: lang, count: count);

    final alignedMatches = alignments.map((key, value) {
      return MapEntry(
          key,
          value
              .map((subId) => withContext(languageSubtitles[key]!.subtitles,
                  subId, key == lang ? 0 : alignmentContext))
              .toList());
    });

    return alignedMatches;
  }

  String withContext(List<Subtitle> items, index, context) {
    final result = (index == -1
            ? <Subtitle>[]
            : items.sublist(index > 0 ? index - context : index,
                (index + context < items.length ? index + context : index) + 1))
        .map((e) => e.text.replaceAll('\n', ' '))
        .join(' ');
    return result;
  }
}

class RangeSearch {
  final List ranges;
  RangeSearch(this.ranges);

  ///
  /// It searches the pivot in ranges and returns the index of the first match
  /// where comparisonFn resolves to true.
  ///
  search(pivot, comparisonFn, {start = 0}) {
    return ranges.indexWhere((element) => comparisonFn(pivot, element), start);
  }
}
